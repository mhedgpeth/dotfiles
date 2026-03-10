# Install Android SDK command-line tools and NDK
# Idempotent: safe to run repeatedly

param(
    [string]$NdkVersion = "29.0.14206865"
)

$ErrorActionPreference = "Stop"

$androidHome = "$env:USERPROFILE\AppData\Local\Android\Sdk"
$cmdlineToolsDir = "$androidHome\cmdline-tools\latest"
$sdkmanager = "$cmdlineToolsDir\bin\sdkmanager.bat"

# Ensure ANDROID_HOME exists
if (-not (Test-Path $androidHome)) {
    New-Item -ItemType Directory -Force -Path $androidHome | Out-Null
}

# Install command-line tools if sdkmanager is not available
if (-not (Test-Path $sdkmanager)) {
    Write-Host "Installing Android command-line tools..."

    # Download latest command-line tools
    $zip = "$env:TEMP\commandlinetools-win.zip"
    $url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
    Invoke-WebRequest -Uri $url -OutFile $zip

    # Extract to temp location (zip contains cmdline-tools/ folder)
    $extractDir = "$env:TEMP\android-cmdline-tools"
    if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
    Expand-Archive -Path $zip -DestinationPath $extractDir

    # Move to correct location: $ANDROID_HOME/cmdline-tools/latest/
    $parentDir = "$androidHome\cmdline-tools"
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }
    if (Test-Path $cmdlineToolsDir) { Remove-Item $cmdlineToolsDir -Recurse -Force }
    Move-Item "$extractDir\cmdline-tools" $cmdlineToolsDir

    # Cleanup
    Remove-Item $zip -ErrorAction SilentlyContinue
    Remove-Item $extractDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Command-line tools installed."
} else {
    Write-Host "Android command-line tools already installed."
}

# Accept licenses non-interactively
Write-Host "Accepting Android SDK licenses..."
$yes = "y`n" * 20
$yes | & $sdkmanager --licenses 2>&1 | Out-Null

# Install NDK if not present
$ndkDir = "$androidHome\ndk\$NdkVersion"
if (-not (Test-Path $ndkDir)) {
    Write-Host "Installing NDK $NdkVersion..."
    & $sdkmanager "ndk;$NdkVersion"
    Write-Host "NDK $NdkVersion installed."
} else {
    Write-Host "NDK $NdkVersion already installed."
}
