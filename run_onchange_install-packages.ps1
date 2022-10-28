@(
    "Git.Git",
    "Google.Chrome",
    "JanDeDobbeleer.OhMyPosh",
    "Microsoft.VisualStudioCode"
) | Foreach-Object {
    winget list --id $_ > $null
    if ($?) {
        Write-Output "Package $_ is already installed. Not re-installing."
    }
    else {
        Write-Output "Installing package $_."
        winget install --scope user --exact --accept-package-agreements --accept-source-agreements $_
    }
}

Invoke-WebRequest `
    -UseBasicParsing `
    -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" `
    -OutFile "./install-pyenv-win.ps1"; `
    &"./install-pyenv-win.ps1"; `
    Remove-Item "./install-pyenv-win.ps1"

@(
    "autohotkey2",
    "bat",
    "less"
) | Foreach-Object {
    scoop install $_
}