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

$private:wingetUpgradeSwitch = if ($Upgrade) { "" } else { "--no-upgrade" }
$private:scoopAction = if ($Upgrade) { "update" } else { "install" }

$private:wingetMachinePackages = @(
    "dotPDN.PaintDotNet",
    "EclipseAdoptium.Temurin.11.JDK",
    "EclipseAdoptium.Temurin.17.JDK",
    "EclipseAdoptium.Temurin.8.JDK",
    "Google.Chrome"
)

$private:wingetCommand = "winget install ${wingetUpgradeSwitch} --scope machine --exact --accept-package-agreements --accept-source-agreements ${wingetMachinePackages}"
Invoke-Command $wingetCommand

$private:wingetUserPackages = @(
    "dandavison.delta",
    "JanDeDobbeleer.OhMyPosh",
    "jftuga.less", # used by sharkdp.bat
    "Microsoft.PowerShell",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "OpenWhisperSystems.Signal",
    "sharkdp.bat",
    "sharkdp.fd"
)

$private:wingetCommand = "winget install ${wingetUpgradeSwitch} --scope user --exact --accept-package-agreements --accept-source-agreements ${wingetUserPackages}"
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

$private:pythonVersions = (@"
  3.13
  3.12
  3.11
  3.10
  3.9
"@ |
    Select-String -AllMatches "\S+" |
    Select-Object -ExpandProperty Matches |
    Select-Object -ExpandProperty Value)

uv python install $pythonVersions