$env:XDG_DATA_HOME = Join-Path $env:HOME ".local/share"

$env:EDITOR = "code --wait"
$env:K9S_CONFIG_DIR = Join-Path $env:XDG_CONFIG_HOME k9s
$env:PYTHONSTARTUP = Join-Path $env:XDG_CONFIG_HOME pythonrc.py
if (($env:PATHEXT -split ";") -notcontains ".PY") {
    $env:PATHEXT += ";.PY"
}

$pythonVersions = @"
3.13
3.12
3.11
3.10
3.9
"@  -split "`n" | Foreach-Object { $_.Trim() }
$pythonVersions | Foreach-Object {
    $null = New-Item -Path function: -Name "script:python${_}" -Value "uv run --with=rich --python=${_} python `$args"
}
$null = New-Item -Path function: -Name "script:python" -Value "uv run --with=rich --python=$($pythonVersions[0]) python `$args"

$env:UV_LINK_MODE = "symlink"

$PSStyle.FileInfo.Directory = $PSStyle.Foreground.Blue;


# Let oh-my-posh decide whether the virtual environemnt is in the prompt
$env:VIRTUAL_ENV_DISABLE_PROMPT = "true"


Import-Module posh-git
Import-Module PSReadLine

Function Set-LocationToParent {
    Set-Location ..
}

Set-Alias .. Set-LocationToParent

Function Set-LocationToRepositoryRoot {
    $originalLocation = Get-Location
    $currentLocation = $originalLocation
    while ( $currentLocation -And ! (Test-Path (Join-Path $currentLocation .git)) ) {
        $currentLocation = Split-Path -Parent $currentLocation
    }
    if ($currentLocation) {
        Set-Location $currentLocation
    }
    else {
        Write-Output "$originalLocation does not appear to be inside a git repository. Not changing directory."
    }
}

Set-Alias rr Set-LocationToRepositoryRoot

Function Activate-VirtualEnvironment {
    Param(
        [Parameter(Mandatory = $false)]
        [string] $VenvName = $null,
        [Parameter(Mandatory = $false)]
        [string] $PythonVersion = "3"
    )

    $activatePath = "Scripts/Activate.ps1"

    if ($VenvName) {
        $preferredLocations = [array](Join-Path (Resolve-Path .) .venv $VenvName)
    }
    else {
        $baseName = Split-Path -Leaf (Get-Location)
        $preferredLocations = @(
            (Join-Path (Resolve-Path .) .venv $baseName),
            (Join-Path (Resolve-Path .) .venv *),
            # legacy
            (Join-Path $env:XDG_DATA_HOME venv $baseName),
            (Join-Path (Resolve-Path .) .venv)
        )
    }

    foreach ($location in $preferredLocations) {
        $candidateVenv = Join-Path $location $activatePath
        if (Test-Path $candidateVenv) {
            if ( ([array](Get-Item $candidateVenv)).Length -eq 1) {
                Write-Output "Activating ${candidateVenv}"
                & $candidateVenv
                return
            }
            else {
                Write-Error "Too many virtual environments: $(Get-Item $candidateVenv | Resolve-Path -Relative)"
                return
            }
        }
    }

    if ("y" -eq (Read-Host -Prompt "There's no virtual environment found for $(Get-Location). Create one?")) {
        $newVenvDir = $preferredLocations[0]
        $newVenv = Join-Path $newVenvDir $activatePath
        Write-Output "Creating virtual environment in ${newVenvDir}"
        uv venv --seed --python "${PythonVersion}" $newVenvDir
        Write-Output "Activating ${newVenvDir}"
        & $newVenv
        return
    }

    Write-Host "Okay. Nevermind."
}

Set-Alias ss Select-String
Set-Alias venv Activate-VirtualEnvironment

Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -EditMode Emacs

Set-PSReadlineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadlineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadlineKeyHandler -Key "Tab" -Function Complete

# oh-my-posh settings
oh-my-posh --init --shell pwsh --config ${env:XDG_CONFIG_HOME}/oh-my-posh/themes/blair-blocky-mocha.omp.json | Invoke-Expression
