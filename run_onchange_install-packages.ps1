# If this fails, try updating the execution policy.
# If you can't try using the Goup Policy Editor to Turn on Script Execution
[CmdletBinding()]
param (
    [switch]$Upgrade,
    [switch]$WhatIf
)

Function Invoke-Command {
    Param(
        [string]$Command
    )

    Write-Verbose "About to run ${Command}"
    if (!$WhatIf) {
        Invoke-Expression $Command
    }
}

if ( $WhatIf ) {
    # If we're not going to do anything, might as well talk about it
    $VerbosePreference = "Continue"
}

$wingetUpgradeSwitch = if ($Upgrade) { "" } else { "--no-upgrade" }
$scoopAction = if ($Upgrade) { "update" } else { "install" }

$wingetPackages = @(
    "dandavison.delta",
    "dotPDN.PaintDotNet",
    "EclipseAdoptium.Temurin.11.JDK",
    "EclipseAdoptium.Temurin.17.JDK",
    "EclipseAdoptium.Temurin.8.JDK",
    "Google.Chrome",
    "JanDeDobbeleer.OhMyPosh",
    "jftuga.less", # used by sharkdp.bat
    "Microsoft.PowerShell",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "OpenWhisperSystems.Signal",
    "Python.Python.3.10",
    "Python.Python.3.11",
    "Python.Python.3.8",
    "Python.Python.3.9",
    "sharkdp.bat",
    "sharkdp.fd"
)

$wingetCommand = "winget install ${wingetUpgradeSwitch} --scope user --exact --accept-package-agreements --accept-source-agreements ${wingetPackages}"
Invoke-Command $wingetCommand

@(
    "7zip",
    "git"
) | Foreach-Object {
    Invoke-Command "scoop ${scoopAction} ${_}"
}

if (Get-Command -ErrorAction SilentlyContinue uv) {
    if ($Upgrade) {
        Invoke-Command "uv self update"
    }
}
else {
    Invoke-Command "Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression"
}
