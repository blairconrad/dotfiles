@(
    "JanDeDobbeleer.OhMyPosh"
) | Foreach-Object {
    winget install --scope user --exact --accept-package-agreements --accept-source-agreements $_
}
