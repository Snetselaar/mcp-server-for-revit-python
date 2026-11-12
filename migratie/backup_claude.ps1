# backup_claude.ps1
#
# Stelt alles veilig wat bij een accountwissel (persoonlijk -> Claude Team)
# NIET vanzelf meegaat of alleen op deze pc staat:
#   - Claude Code-memory (alle projecten), plannen, settings, plugin-marketplaces
#   - settings.local.json van de repo's (staan niet in git)
#   - Claude Desktop-config (MCP-servers fetch + Nonica Revit, voorkeuren)
#   - de eigen claude.ai-skills als upload-klare zip (via pack_skill.ps1)
#   - INVENTARIS.md + manifest.json (SHA-256 per bestand)
# Wijzigt niets aan de originelen. Tokens/inlog (.claude.json, Credential
# Manager) gaan bewust NIET mee: die horen bij het oude account.
#
# Gebruik:  dubbelklik Backup.cmd   of   .\backup_claude.ps1 [-Doel <map>]
#
# Versie: 1.0 (2026-11-11)

param(
    [string]$Doel
)

$ErrorActionPreference = 'Stop'
$U   = $env:USERPROFILE
$OD  = Join-Path $U 'OneDrive - Snetselaar Constructieve Ingenieurs'
$MCP = Join-Path $U 'Documents\GitHub\mcp-server-for-revit-python'
$BIM = Join-Path $OD 'Documenten\GitHub\Snetselaar_BIM'
$APP = Join-Path $env:APPDATA 'Claude'
$CL  = Join-Path $U '.claude'

if (-not $Doel) { $Doel = Join-Path $OD 'Claude-backup' }
$stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'
$B = Join-Path $Doel $stamp
New-Item -ItemType Directory -Force $B | Out-Null
$waarsch = New-Object System.Collections.Generic.List[string]

function Kopieer([string]$bron, [string]$rel) {
    if (-not (Test-Path $bron)) { $script:waarsch.Add("ontbreekt: $bron"); return }
    $dst = Join-Path $B $rel
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    if ((Get-Item $bron).PSIsContainer) {
        Copy-Item $bron $dst -Recurse -Force
    } else {
        Copy-Item $bron $dst -Force
    }
}

Write-Host "Back-up naar $B" -ForegroundColor Cyan

# 1. Git: is alles gecommit en gepusht? (git = de echte back-up van code + kennisbank)
$repos = @{ 'mcp-server-for-revit-python' = $MCP; 'Snetselaar_BIM' = $BIM }
$gitRegels = @()
foreach ($n in $repos.Keys) {
    $r = $repos[$n]
    if (-not (Test-Path (Join-Path $r '.git'))) { $waarsch.Add("repo niet gevonden: $r"); continue }
    git -C $r fetch -q 2>$null
    $dirty = @(git -C $r status --porcelain).Count
    $ahead = git -C $r rev-list --count '@{u}..HEAD' 2>$null
    $remote = git -C $r remote get-url origin
    $gitRegels += "| $n | $remote | $dirty | $ahead |"
    if ($dirty -gt 0) { $waarsch.Add("$n heeft $dirty ongecommitte wijziging(en)") }
    if ([int]$ahead -gt 0) { $waarsch.Add("$n heeft $ahead ongepushte commit(s)") }
}

# 2. Claude Code (gebruikersmap)
Kopieer (Join-Path $CL 'settings.json')                     'claude-code\settings.json'
Kopieer (Join-Path $CL '.claude\settings.local.json')       'claude-code\.claude\settings.local.json'
Kopieer (Join-Path $CL 'plans')                             'claude-code\plans'
Kopieer (Join-Path $CL 'plugins\known_marketplaces.json')   'claude-code\plugins\known_marketplaces.json'
Get-ChildItem (Join-Path $CL 'projects') -Directory | ForEach-Object {
    $m = Join-Path $_.FullName 'memory'
    if (Test-Path $m) { Kopieer $m ("claude-code\projects\" + $_.Name + "\memory") }
}

# 3. Niet-git-bestanden in de repo's
Kopieer (Join-Path $MCP '.claude\settings.local.json')      'repo-lokaal\mcp-server-for-revit-python\.claude\settings.local.json'
if (Test-Path (Join-Path $BIM '.claude\settings.local.json')) {
    Kopieer (Join-Path $BIM '.claude\settings.local.json')  'repo-lokaal\Snetselaar_BIM\.claude\settings.local.json'
}

# 4. Claude Desktop
foreach ($f in 'claude_desktop_config.json','ccd-session-presets.json','mcp-user-tool-toggles.json') {
    Kopieer (Join-Path $APP $f) ("claude-desktop\" + $f)
}

# 5. Eigen claude.ai-skills als upload-klare zip
$skillsMap = Join-Path $B 'skill-zips'
New-Item -ItemType Directory -Force $skillsMap | Out-Null
$skills = @()
if (Test-Path $BIM) {
    $skills = Get-ChildItem $BIM -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }
    foreach ($s in $skills) {
        & (Join-Path $BIM 'tools\pack_skill.ps1') -SkillDir $s.FullName -OutDir $skillsMap | Out-Null
    }
}

# 5b. Handwerk uit de vorige back-up meenemen: claude-docs\ en losse zips in de
#     hoofdmap (de claude.ai-export). Die maakt geen script, dus niet kwijtraken.
$vorige = Get-ChildItem $Doel -Directory | Where-Object { $_.Name -lt $stamp } |
          Sort-Object Name -Descending | Select-Object -First 1
$meegenomen = @()
if ($vorige) {
    $cd = Join-Path $vorige.FullName 'claude-docs'
    if (Test-Path $cd) { Copy-Item $cd (Join-Path $B 'claude-docs') -Recurse -Force; $meegenomen += 'claude-docs\' }
    Get-ChildItem $vorige.FullName -File -Filter *.zip | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $B $_.Name) -Force; $meegenomen += $_.Name
    }
}

# 6. API-key-check (alleen ja/nee)
$apiKey = [bool]([Environment]::GetEnvironmentVariable('ANTHROPIC_API_KEY','User') -or
                 [Environment]::GetEnvironmentVariable('ANTHROPIC_API_KEY','Machine') -or
                 $env:ANTHROPIC_API_KEY)

# 7. Inventaris + manifest
$desk = Get-Content (Join-Path $APP 'claude_desktop_config.json') -Raw | ConvertFrom-Json
$deskMcp = ($desk.mcpServers.PSObject.Properties | ForEach-Object { "| $($_.Name) | $($_.Value.command) |" }) -join "`n"
$projMcp = (Get-Content (Join-Path $MCP '.mcp.json') -Raw | ConvertFrom-Json).mcpServers.PSObject.Properties.Name -join ', '
$memAantal = @(Get-ChildItem (Join-Path $B 'claude-code\projects') -Recurse -File -ErrorAction SilentlyContinue).Count
$skillRegels = ($skills | ForEach-Object {
    $d = (Select-String -Path (Join-Path $_.FullName 'SKILL.md') -Pattern '^description:' | Select-Object -First 1).Line
    "| $($_.Name) | " + ($d -replace '^description:\s*','' ).Substring(0, [Math]::Min(90, ($d -replace '^description:\s*','').Length)) + ' |'
}) -join "`n"

$inv = @"
# Inventaris Claude-back-up $stamp

## Git (de echte back-up van code, kennisbank en skills)

| repo | origin | ongecommit | ongepusht |
|---|---|---|---|
$($gitRegels -join "`n")

## Claude Code
- memory-bestanden: $memAantal
- project-MCP-servers (.mcp.json, in git): $projMcp
- ANTHROPIC_API_KEY gezet: $(if ($apiKey) {'JA - verwijderen na de overstap'} else {'nee'})

## Claude Desktop-MCP-servers

| naam | command |
|---|---|
$deskMcp

## Eigen claude.ai-skills (zip in skill-zips\)

| skill | beschrijving |
|---|---|
$skillRegels

## Meegenomen uit vorige back-up
$(if ($meegenomen.Count) { "Uit $($vorige.Name): " + ($meegenomen -join ', ') } else { '- niets' })

## Handwerk op claude.ai (kan geen script doen)
- Settings > Privacy > Export data: download en zet de zip in deze map
- Claude Docs exporteren die je wilt houden
- app-koppelingen (Google Drive, Notion, GitHub ...) opnieuw koppelen na de overstap
- skills uploaden uit skill-zips\ (Customize > Skills)

## Waarschuwingen
$(if ($waarsch.Count) { ($waarsch | ForEach-Object { "- $_" }) -join "`n" } else { '- geen' })
"@
Set-Content -Path (Join-Path $B 'INVENTARIS.md') -Value $inv -Encoding UTF8

$manifest = Get-ChildItem $B -Recurse -File | Where-Object { $_.Name -ne 'manifest.json' } | ForEach-Object {
    [pscustomobject]@{ pad = $_.FullName.Substring($B.Length + 1); sha256 = (Get-FileHash $_.FullName).Hash }
}
$manifest | ConvertTo-Json | Set-Content (Join-Path $B 'manifest.json') -Encoding UTF8

Write-Host ""
Write-Host "Klaar: $($manifest.Count) bestanden, $($skills.Count) skill-zips." -ForegroundColor Green
if ($meegenomen.Count) { Write-Host "Meegenomen uit $($vorige.Name): $($meegenomen -join ', ')" }
if ($waarsch.Count) {
    Write-Host "Let op:" -ForegroundColor Yellow
    $waarsch | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
Write-Host "Inventaris: $(Join-Path $B 'INVENTARIS.md')"
