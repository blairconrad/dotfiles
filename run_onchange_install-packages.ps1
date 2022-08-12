@(
    "Git.Git",
    "Google.Chrome",
    "JanDeDobbeleer.OhMyPosh",
    "Microfost.VisualStudioCode"
) | Foreach-Object {
    winget install --scope user --exact --accept-package-agreements --accept-source-agreements $_
}

@(
    "pyenv"
) | Foreach-Object {
    scoop install $_
}