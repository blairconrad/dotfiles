$wingetPackages = @(
    "dandavison.delta",
    "dotPDNLLC.paintdotnet",
    "EclipseAdoptium.Temurin.11.JDK",
    "EclipseAdoptium.Temurin.17.JDK",
    "EclipseAdoptium.Temurin.8.JDK",
    "Git.Git",
    "Google.Chrome",
    "JanDeDobbeleer.OhMyPosh",
    "jftuga.less", # used by sharkdp.bat
    "Microsoft.PowerShell",
    "Microsoft.VisualStudioCode",
    "Microsoft.WindowsTerminal",
    "OpenWhisperSystems.Signal",
    "Python.Python.3.10",
    "Python.Python.3.11",
    "Python.Python.3.8",
    "Python.Python.3.9",
    "sharkdp.bat",
    "sharkdp.fd"
)
winget install --no-upgrade --scope user --exact --accept-package-agreements --accept-source-agreements $wingetPackages

@(
    "7zip"
) | Foreach-Object {
    scoop install $_
}
