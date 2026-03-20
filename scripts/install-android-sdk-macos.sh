#!/usr/bin/env bash
# Install Android SDK components and Rust cross-compilation targets for macOS
# Idempotent: safe to run repeatedly
# Requires: Android Studio (provides sdkmanager)
set -euo pipefail

NDK_VERSION="29.0.14206865"
ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"

if [[ ! -x "$SDKMANAGER" ]]; then
    echo "ERROR: sdkmanager not found at $SDKMANAGER"
    echo "Open Android Studio and install Android SDK Command-line Tools via:"
    echo "  Settings > Languages & Frameworks > Android SDK > SDK Tools"
    exit 1
fi

# Accept licenses non-interactively
yes 2>/dev/null | "$SDKMANAGER" --licenses >/dev/null 2>&1 || true

# Install NDK, platform-tools, and platform
echo "Installing Android SDK components..."
"$SDKMANAGER" "ndk;$NDK_VERSION" "platform-tools" "platforms;android-36"

# Add Rust Android cross-compilation targets
echo "Adding Rust Android targets..."
rustup target add \
    aarch64-linux-android \
    armv7-linux-androideabi \
    i686-linux-android \
    x86_64-linux-android

echo "Android SDK setup complete."
