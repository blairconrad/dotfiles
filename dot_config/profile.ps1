$env:XDG_DATA_HOME = Join-Path $env:HOME ".local/share"

$env:EDITOR = "code --wait"
$env:PYTHONSTARTUP = Join-Path $env:XDG_CONFIG_HOME pythonrc.py

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
    $activatePath = "Scripts/Activate.ps1"
    $localVenv = Join-Path (Get-Location) ".venv" $activatePath
    if (Test-Path $localVenv) {
        Write-Output "Activating ${localVenv}"
        & $localVenv
        return
    }

    $homeVenvDir = Join-Path $env:XDG_DATA_HOME venv (Get-Location | Split-Path -Leaf)
    $homeVenv = Join-Path $homeVenvDir $activatePath
    if (Test-Path $homeVenv) {
        Write-Output "Activating ${homeVenv}"
        & $homeVenv
        return
    }

    if ("y" -eq (Read-Host -Prompt "There's no virtual environment found for $(Get-Location). Create one?")) {
        Write-Output "Creating virtual environment in ${homeVenvDir}"
        python -m venv $homeVenvDir
        Write-Output "Activating ${homeVenv}"
        & $homeVenv
        return
    }

    Write-Host "Okay. Nevermind."
}

Set-Alias venv Activate-VirtualEnvironment

Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -EditMode Emacs

Set-PSReadlineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadlineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadlineKeyHandler -Key "Tab" -Function Complete

# oh-my-posh settings
oh-my-posh --init --shell pwsh --config ${env:XDG_CONFIG_HOME}/oh-my-posh/themes/blair-velvet.omp.json | Invoke-Expression

if (Get-Command autohotkey2) {
    if (! (Get-Process -Name *autohotkey2* | Where-Object { $_.CommandLine -like "*default.ahk*" })) {
        Start-Process -NoNewWindow autohotkey2 -ArgumentList (Join-Path $env:XDG_CONFIG_HOME autohotkey default.ahk)
    }
}
