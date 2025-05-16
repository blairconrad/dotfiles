# If this fails, try updating the execution policy.
# If you can't try using the Goup Policy Editor to Turn on Script Execution
[CmdletBinding()]
param (
    [string] $JustPackage,
    [switch] $Upgrade,
    [switch] $WhatIf
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

Function Limit-Packages {
    Param(
        [string[]] $Packages
    )
    if ($JustPackage) {
        if ($Packages -contains $JustPackage) {
            return @($JustPackage)
        }
        else {
            return @()
        }
    }
    return $Packages
}

if ( $WhatIf ) {
    # If we're not going to do anything, might as well talk about it
    $VerbosePreference = "Continue"
}

$private:wingetUpgradeSwitch = if ($Upgrade) { "" } else { "--no-upgrade" }
$private:scoopAction = if ($Upgrade) { "update" } else { "install" }

$private:wingetMachinePackages = Limit-Packages @(
    "dotPDN.PaintDotNet",
    "EclipseAdoptium.Temurin.11.JDK",
    "EclipseAdoptium.Temurin.17.JDK",
    "EclipseAdoptium.Temurin.8.JDK",
    "Google.Chrome",
    "" # This is a placeholder to make it easier to add more packages
)

if ($private:wingetMachinePackages) {
    $private:wingetCommand = "winget install ${wingetUpgradeSwitch} --scope machine --exact --accept-package-agreements --accept-source-agreements ${wingetMachinePackages}"
    Invoke-Command $wingetCommand
}

$private:wingetUserPackages = Limit-Packages @(
    "dandavison.delta",
    "JanDeDobbeleer.OhMyPosh",
    "jftuga.less", # used by sharkdp.bat
    "Microsoft.PowerShell",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "OpenWhisperSystems.Signal",
    "sharkdp.bat",
    "sharkdp.fd",
    "tummychow.git-absorb",
    "" # This is a placeholder to make it easier to add more packages
)

if ($private:wingetUserPackages) {
    $private:wingetCommand = "winget install ${wingetUpgradeSwitch} --scope user --exact --accept-package-agreements --accept-source-agreements ${wingetUserPackages}"
    Invoke-Command $wingetCommand
}

Limit-Packages @(
    "7zip",
    "git",
    "" # This is a placeholder to make it easier to add more packages
) | Where-Object { $_ -ne "" } | Foreach-Object {
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