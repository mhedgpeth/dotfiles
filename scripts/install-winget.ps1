# Install winget from GitHub releases (not the Store) so it works from services/SYSTEM context.
# Uses Add-AppxProvisionedPackage to provision OS-wide instead of per-user.

#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"

$tempDir = Join-Path $env:TEMP "winget-install"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Write-Host "Downloading latest winget release assets..."
    $assets = @(
        "*.msixbundle"
        "*License*.xml"
        "*Dependencies.zip"
    )
    foreach ($pattern in $assets) {
        gh release download --repo microsoft/winget-cli --pattern $pattern --dir $tempDir --clobber
    }

    $msixBundle = Get-ChildItem -Path $tempDir -Filter "*.msixbundle" | Select-Object -First 1
    $license = Get-ChildItem -Path $tempDir -Filter "*License*.xml" | Select-Object -First 1

    if (-not $msixBundle -or -not $license) {
        throw "Failed to download required assets (msixbundle or license XML)"
    }

    # Extract and collect dependency packages
    $depsZip = Get-ChildItem -Path $tempDir -Filter "*Dependencies.zip" | Select-Object -First 1
    $depPaths = @()
    if ($depsZip) {
        $depsDir = Join-Path $tempDir "deps"
        Expand-Archive -Path $depsZip.FullName -DestinationPath $depsDir -Force
        # Only need x64 dependencies
        $depPaths = @(Get-ChildItem -Path $depsDir -Filter "*.appx" -Recurse |
            Where-Object { $_.FullName -match "x64" } |
            ForEach-Object { $_.FullName })
    }

    Write-Host "Installing winget system-wide via Add-AppxProvisionedPackage..."
    $params = @{
        Online      = $true
        PackagePath = $msixBundle.FullName
        LicensePath = $license.FullName
    }
    if ($depPaths.Count -gt 0) {
        $params.DependencyPackagePath = $depPaths
    }
    Add-AppxProvisionedPackage @params

    Write-Host "winget installed successfully (provisioned for all users)."
}
finally {
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}
