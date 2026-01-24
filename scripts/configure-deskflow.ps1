if (-not (Get-Process -Name "deskflow" -ErrorAction SilentlyContinue)) {
    Start-Process "deskflow"
}
