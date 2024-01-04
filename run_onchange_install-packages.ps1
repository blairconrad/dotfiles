$wingetPackages = @(
    "dandavison.delta",
    "Git.Git",
    "Google.Chrome",
    "JanDeDobbeleer.OhMyPosh",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal"
)
winget install --no-upgrade --scope user --exact --accept-package-agreements --accept-source-agreements $wingetPackages

@(
    "7zip",
    "bat",
    "less"
) | Foreach-Object {
    scoop install $_
}