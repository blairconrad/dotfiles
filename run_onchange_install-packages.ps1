
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

$upgradeSwitch = if ($Upgrade) { "" } else { "--no-upgrade" }

$wingetPackages = @(
    "dandavison.delta",
    "dotPDN.PaintDotNet",
    "EclipseAdoptium.Temurin.11.JDK",
    "EclipseAdoptium.Temurin.17.JDK",
    "EclipseAdoptium.Temurin.8.JDK",
    "Git.Git",
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

$wingetCommand = "winget install ${upgradeSwitch} --scope user --exact --accept-package-agreements --accept-source-agreements ${wingetPackages}"
Invoke-Command $wingetCommand

@(
    "7zip"
) | Foreach-Object {
    Invoke-Command "scoop install ${_}"
}

if (Get-Command -ErrorAction SilentlyContinue uv) {
    if ($Upgrade) {
        Invoke-Command "uv self update"
    }
}
else {
    Invoke-Command "Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression"
}
