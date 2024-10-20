function bye { exit }
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

function Invoke-Starship-PreCommand {
  $host.ui.RawUI.WindowTitle = "pwsh: $env:USERNAME@$env:COMPUTERNAME"
}

Invoke-Expression (&starship init powershell)

