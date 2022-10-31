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

@(
    "autohotkey2",
    "bat",
    "less"
) | Foreach-Object {
    scoop install $_
}