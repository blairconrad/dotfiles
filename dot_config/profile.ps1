$env:DEFAULT_EDITOR = "code"
$env:PYTHONSTARTUP = Join-Path $env:XDG_CONFIG_HOME pythonrc.py

# Let oh-my-posh decide whether the virtual environemnt is in the prompt
$env:VIRTUAL_ENV_DISABLE_PROMPT = "true"


Import-Module posh-git
Import-Module PSReadLine

Function Set-LocationToParent {
    Set-Location ..
}

Set-Alias .. Set-LocationToParent

Function Activate-VirtualEnvironment {
    $venvPath = ".venv/Scripts/Activate.ps1"
    if (! (Test-Path $venvPath)) {
        if ("y" -eq (Read-Host -Prompt "There's no $venvPath in this directory Create one?")) {
            python -m venv .venv
        }
        else {
            Write-Host "Okay. Nevermind."
            return
        }
    }
    & $venvPath
}

Set-Alias venv Activate-VirtualEnvironment

Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -EditMode Emacs

Set-PSReadlineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadlineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadlineKeyHandler -Key "Tab" -Function Complete

# oh-my-posh settings
oh-my-posh --init --shell pwsh --config ${env:XDG_CONFIG_HOME}/oh-my-posh/themes/blair-velvet.omp.json | Invoke-Expression
