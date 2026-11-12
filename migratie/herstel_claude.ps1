# herstel_claude.ps1
#
# Zet een back-up van backup_claude.ps1 terug na de overstap naar Claude Team
# (of op een nieuwe pc) en controleert of alles weer werkt.
#
# Volgorde: eerst in Claude Code /login met het Team-account, dan dit script.
#
#   - ontbrekende repo's klonen van GitHub
#   - memory, plannen, settings, desktop-config terugzetten
#     (bestaande bestanden: alleen overschreven met -Overschrijf; er gaat
#      altijd eerst een kopie van het huidige bestand naar <naam>.voor-herstel)
#   - controle: ANTHROPIC_API_KEY, uv/git, claude mcp list, skill-drift
#   - opent de map met skill-zips en de skills-pagina van claude.ai
#
# Gebruik:  dubbelklik Herstel.cmd   of   .\herstel_claude.ps1 [-Backup <map>] [-Overschrijf]
#
# Versie: 1.0 (2026-11-11)

param(
    [string]$Backup,
    [switch]$Overschrijf,
    [switch]$GeenVensters
)

$ErrorActionPreference = 'Stop'
$U   = $env:USERPROFILE
$OD  = Join-Path $U 'OneDrive - Snetselaar Constructieve Ingenieurs'
$MCP = Join-Path $U 'Documents\GitHub\mcp-server-for-revit-python'
$BIM = Join-Path $OD 'Documenten\GitHub\Snetselaar_BIM'
$APP = Join-Path $env:APPDATA 'Claude'
$CL  = Join-Path $U '.claude'

if (-not $Backup) {
    $Backup = Get-ChildItem (Join-Path $OD 'Claude-backup') -Directory |
              Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $Backup -or -not (Test-Path (Join-Path $Backup 'manifest.json'))) {
    throw "Geen geldige back-up gevonden (verwacht manifest.json). Geef -Backup <map> op."
}
Write-Host "Herstel uit $Backup" -ForegroundColor Cyan
$rapport = New-Object System.Collections.Generic.List[object]
function Regel($onderdeel, $status, $actie) {
    $script:rapport.Add([pscustomobject]@{ Onderdeel = $onderdeel; Status = $status; Actie = $actie })
}

# 0. Integriteit van de back-up
$manifest = Get-Content (Join-Path $Backup 'manifest.json') -Raw | ConvertFrom-Json
$kapot = @($manifest | Where-Object {
    $p = Join-Path $Backup $_.pad
    -not (Test-Path $p) -or (Get-FileHash $p).Hash -ne $_.sha256 })
Regel 'Back-up intact' $(if ($kapot.Count) {"$($kapot.Count) afwijkend"} else {"ok ($($manifest.Count) bestanden)"}) $(if ($kapot.Count) {'controleer de back-up'} else {''})

# 1. Repo's
foreach ($r in @(
    @{ pad = $MCP; url = 'https://github.com/Snetselaar/mcp-server-for-revit-python.git' },
    @{ pad = $BIM; url = 'https://github.com/Snetselaar/Snetselaar_BIM.git' })) {
    if (Test-Path (Join-Path $r.pad '.git')) {
        Regel (Split-Path $r.pad -Leaf) 'aanwezig' ''
    } else {
        git clone $r.url $r.pad
        Regel (Split-Path $r.pad -Leaf) 'gekloond' ''
    }
}

# 2. Bestanden terugzetten
function Zet([string]$rel, [string]$doel) {
    $bron = Join-Path $Backup $rel
    if (-not (Test-Path $bron)) { return 0 }
    $n = 0
    $bronnen = if ((Get-Item $bron).PSIsContainer) { Get-ChildItem $bron -Recurse -File } else { @(Get-Item $bron) }
    foreach ($f in $bronnen) {
        $sub = if ((Get-Item $bron).PSIsContainer) { $f.FullName.Substring($bron.Length).TrimStart('\') } else { '' }
        $dst = if ($sub) { Join-Path $doel $sub } else { $doel }
        if (Test-Path $dst) {
            if (-not $Overschrijf) { continue }
            if ((Get-FileHash $dst).Hash -eq (Get-FileHash $f.FullName).Hash) { continue }
            Copy-Item $dst "$dst.voor-herstel" -Force
        }
        New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
        Copy-Item $f.FullName $dst -Force
        $n++
    }
    return $n
}

$n = 0
$n += Zet 'claude-code\settings.json'                   (Join-Path $CL 'settings.json')
$n += Zet 'claude-code\.claude\settings.local.json'     (Join-Path $CL '.claude\settings.local.json')
$n += Zet 'claude-code\plans'                           (Join-Path $CL 'plans')
$n += Zet 'claude-code\plugins\known_marketplaces.json' (Join-Path $CL 'plugins\known_marketplaces.json')
$mem = 0
Get-ChildItem (Join-Path $Backup 'claude-code\projects') -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $mem += Zet ("claude-code\projects\" + $_.Name + "\memory") (Join-Path $CL ("projects\" + $_.Name + "\memory"))
}
$n += Zet 'repo-lokaal\mcp-server-for-revit-python\.claude\settings.local.json' (Join-Path $MCP '.claude\settings.local.json')
$n += Zet 'repo-lokaal\Snetselaar_BIM\.claude\settings.local.json'              (Join-Path $BIM '.claude\settings.local.json')
foreach ($f in 'claude_desktop_config.json','ccd-session-presets.json','mcp-user-tool-toggles.json') {
    $n += Zet ("claude-desktop\" + $f) (Join-Path $APP $f)
}
Regel 'Config-bestanden' "$n teruggezet" $(if (-not $Overschrijf) {'bestaande bestanden overgeslagen (-Overschrijf om te vervangen)'} else {''})
Regel 'Memory' "$mem teruggezet" ''

# 3. Controles
$apiKey = [bool]([Environment]::GetEnvironmentVariable('ANTHROPIC_API_KEY','User') -or
                 [Environment]::GetEnvironmentVariable('ANTHROPIC_API_KEY','Machine') -or
                 $env:ANTHROPIC_API_KEY)
Regel 'ANTHROPIC_API_KEY' $(if ($apiKey) {'GEZET'} else {'niet gezet'}) $(if ($apiKey) {'verwijderen, anders rekent Claude Code via de API af'} else {''})

foreach ($tool in 'git','uv') {
    $ok = [bool](Get-Command $tool -ErrorAction SilentlyContinue)
    Regel "programma $tool" $(if ($ok) {'ok'} else {'ONTBREEKT'}) $(if ($ok) {''} else {"installeer $tool"})
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Regel 'MCP revit / revit-lezen' 'niet getest' 'geen claude-CLI op PATH (Desktop-app): vraag in Claude Code "test de Revit-MCP met get_status"'
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Push-Location $MCP
    try {
        $lijst = claude mcp list 2>&1 | Out-String
        foreach ($srv in 'revit','revit-lezen') {
            $r = ($lijst -split "`n" | Where-Object { $_ -match "^${srv}:" } | Select-Object -First 1)
            $st = if ($r -match 'Connected|✓') {'verbonden'} elseif ($r) {'niet verbonden'} else {'niet gevonden'}
            Regel "MCP $srv" $st $(if ($st -ne 'verbonden') {'Revit open? project-MCP goedkeuren in Claude Code'} else {''})
        }
    } finally { Pop-Location }
}

$drift = Join-Path $BIM 'tools\skill_uploads.ps1'
if (Test-Path $drift) {
    $out = & $drift 2>&1 | Out-String
    Regel 'Skills repo vs upload' $(if ($out -match 'Alle skills in de repo zijn gelijk') {'gelijk'} else {'verschil'}) 'na de overstap: skill-zips opnieuw uploaden in het Team-account'
}

# 4. Handwerk klaarzetten
$zips = Join-Path $Backup 'skill-zips'
if (-not $GeenVensters) {
    if (Test-Path $zips) { Start-Process explorer.exe $zips }
    Start-Process 'https://claude.ai/customize/skills'
}

Write-Host ""
$rapport | Format-Table -AutoSize -Wrap | Out-Host
Write-Host "Nog met de hand op claude.ai:" -ForegroundColor Yellow
Write-Host "  1. skills uploaden uit de map die nu open staat"
Write-Host "  2. app-koppelingen opnieuw koppelen (Google Drive, Notion, ...)"
Write-Host "  3. controleer in Claude Code met /status dat het Team-account actief is"
