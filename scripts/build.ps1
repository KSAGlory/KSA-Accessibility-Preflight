param(
    [string]$OutputPath = (Join-Path $PSScriptRoot "..\dist\KSA-Accessibility-Preflight.rbxmx")
)

$ErrorActionPreference = "Stop"
$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

function Escape-Xml([string]$Value) {
    return [System.Security.SecurityElement]::Escape($Value)
}

function Roblox-Item([string]$ClassName, [string]$Name, [string]$Source) {
    $escapedName = Escape-Xml $Name
    $escapedSource = Escape-Xml $Source
    return @"
    <Item class="$ClassName">
      <Properties>
        <string name="Name">$escapedName</string>
        <ProtectedString name="Source">$escapedSource</ProtectedString>
      </Properties>
    </Item>
"@
}

$contrastSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Contrast.luau")
$auditorSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Auditor.luau")
$themeSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Theme.luau")
$mainSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Main.server.luau")

$items = @(
    (Roblox-Item "ModuleScript" "Contrast" $contrastSource),
    (Roblox-Item "ModuleScript" "Auditor" $auditorSource),
    (Roblox-Item "ModuleScript" "Theme" $themeSource),
    (Roblox-Item "Script" "Main" $mainSource)
) -join "`n"

$xml = @"
<roblox version="4">
  <External>null</External>
  <External>nil</External>
  <Item class="Folder">
    <Properties>
      <string name="Name">KSA Accessibility Preflight</string>
    </Properties>
$items
  </Item>
</roblox>
"@

[System.IO.File]::WriteAllText($OutputPath, $xml, [System.Text.UTF8Encoding]::new($false))
Write-Host "Built $OutputPath"
