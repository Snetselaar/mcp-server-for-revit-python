<#
.SYNOPSIS
  PostToolUse-hook: compileert een zojuist bewerkt pyRevit-script onder
  IronPython 2.7.12 en meldt een syntaxfout terug aan Claude.

.DESCRIPTION
  Leest de hook-invoer (JSON) van stdin. Doet alleen iets als het bewerkte
  bestand een .py is binnen een pyRevit-extensie (een map die op .extension
  eindigt) en pyRevit het in IronPython laadt. Scripts voor CPython 3 (map
  tools, mcp_lezen, annotatie_autopilot, tests) worden overgeslagen.

  Gebruikt de engine die pyRevit meelevert, zelfde aanpak als
  RnD.extension\tools\check_ironpython.ps1. Voert niets uit en raakt Revit niet.

  Exitcodes: 0 = in orde of niet van toepassing, 2 = syntaxfout (stderr gaat
  terug naar Claude). Ontbreekt de engine, dan exit 0 met een melding: de hook
  mag het werk nooit blokkeren.

  Versie: 1.0
#>
$ErrorActionPreference = 'Stop'
try {
    $invoer = [Console]::In.ReadToEnd() | ConvertFrom-Json
} catch { exit 0 }

$pad = $invoer.tool_input.file_path
if (-not $pad) { $pad = $invoer.tool_response.filePath }
if (-not $pad -or $pad -notmatch '\.py$') { exit 0 }

$norm = $pad -replace '/', '\'
if ($norm -notmatch '\.extension\\') { exit 0 }
# CPython-scripts binnen de extensie: niet onder IronPython toetsen.
if ($norm -match '\\(tools|mcp_lezen|annotatie_autopilot|tests|__pycache__)\\') { exit 0 }
if (-not (Test-Path -LiteralPath $norm)) { exit 0 }

$engines = "$env:APPDATA\pyRevit-Master\bin\netcore\engines\IPY2712PR"
if (-not (Test-Path $engines)) {
    Write-Output "ipy_compile: pyRevit-IronPython niet gevonden ($engines), compilecheck overgeslagen."
    exit 0
}

try {
    Add-Type -Path "$engines\pyRevitLabs.Microsoft.Scripting.dll",
                   "$engines\pyRevitLabs.Microsoft.Dynamic.dll",
                   "$engines\pyRevitLabs.IronPython.dll"
    $engine = [IronPython.Hosting.Python]::CreateEngine()
} catch {
    Write-Output "ipy_compile: engine niet te laden ($($_.Exception.Message)), compilecheck overgeslagen."
    exit 0
}

try {
    $null = $engine.CreateScriptSourceFromFile($norm).Compile()
    exit 0
} catch {
    $fout = $_.Exception
    if ($fout.InnerException) { $fout = $fout.InnerException }
    $regel = ''
    if ($fout.PSObject.Properties['Line']) { $regel = " (regel $($fout.Line))" }
    [Console]::Error.WriteLine("SYNTAXFOUT onder IronPython 2.7$regel in $norm")
    [Console]::Error.WriteLine("  $($fout.Message)")
    [Console]::Error.WriteLine("Zo verdwijnt de knop zonder melding uit het lint. Herstel dit nu (geen f-strings, type hints of andere Python 3-syntax).")
    exit 2
}
