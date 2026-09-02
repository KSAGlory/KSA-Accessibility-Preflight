$ErrorActionPreference = "Stop"
$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$packagePath = Join-Path $projectRoot "dist\KSA-Accessibility-Preflight.rbxmx"

& (Join-Path $PSScriptRoot "build.ps1") -OutputPath $packagePath
& (Join-Path $PSScriptRoot "build-test-ui.ps1")

[xml]$package = Get-Content -Raw -Path $packagePath
$rootItem = $package.roblox.Item

if ($rootItem.GetAttribute("class") -ne "Folder") {
    throw "The plugin package must have a Folder root."
}

if ($rootItem.Properties.string.'#text' -ne "KSA Accessibility Preflight") {
    throw "The package root name is incorrect."
}

$expectedItems = @(
    @{ Class = "ModuleScript"; Name = "Contrast" },
    @{ Class = "ModuleScript"; Name = "Auditor" },
    @{ Class = "ModuleScript"; Name = "Theme" },
    @{ Class = "Script"; Name = "Main" }
)

foreach ($expected in $expectedItems) {
    $found = $false
    foreach ($item in $rootItem.Item) {
        if ($item.GetAttribute("class") -eq $expected.Class -and $item.Properties.string.'#text' -eq $expected.Name) {
            if ([string]::IsNullOrWhiteSpace($item.Properties.ProtectedString.'#text')) {
                throw "$($expected.Name) has no source in the package."
            }
            $found = $true
            break
        }
    }

    if (-not $found) {
        throw "Missing $($expected.Class) named $($expected.Name)."
    }
}

$mainSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Main.server.luau")
$auditorSource = Get-Content -Raw -Path (Join-Path $projectRoot "src\Auditor.luau")

if ($mainSource -notmatch "KSA Accessibility Preflight") {
    throw "The KSA resource name is missing from the plugin UI."
}

if ($auditorSource -notmatch "ReducedMotionEnabled" -or $auditorSource -notmatch "PreferredTextSize") {
    throw "Expected accessibility checks are missing from the auditor."
}

$testInterfacePath = Join-Path $projectRoot "examples\KSA-Accessibility-Test-UI.rbxmx"
[xml]$testInterface = Get-Content -Raw -Path $testInterfacePath
if ($testInterface.roblox.Item.GetAttribute("class") -ne "ScreenGui") {
    throw "The test interface must have a ScreenGui root."
}

$expectedTestObjects = @(
    "GoodContrastText",
    "LowContrastText",
    "ScaledText",
    "SmallText",
    "TransparentText",
    "GradientText",
    "TweenWithoutReducedMotion"
)

$testObjectNames = Select-Xml -Xml $testInterface -XPath "//string[@name='Name']" | ForEach-Object { $_.Node.InnerText }
foreach ($expectedName in $expectedTestObjects) {
    if ($expectedName -notin $testObjectNames) {
        throw "The test interface is missing $expectedName."
    }
}

Write-Host "Verification passed: plugin package, accessibility checks, and test interface are present."
