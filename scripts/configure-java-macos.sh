#!/usr/bin/env bash
# Symlink Homebrew JDKs into /Library/Java/JavaVirtualMachines so that
# /usr/libexec/java_home -v <version> and Gradle's toolchain auto-detection
# can find them. Keg-only JDKs (openjdk@17, etc.) aren't discoverable otherwise.
# Idempotent: safe to run repeatedly.
set -euo pipefail

JVM_DIR="/Library/Java/JavaVirtualMachines"

link_jdk() {
    local formula="$1" link_name="$2"
    local prefix target dest

    if ! prefix="$(brew --prefix "$formula" 2>/dev/null)" || [[ ! -d "$prefix" ]]; then
        echo "skip $formula: not installed"
        return
    fi

    target="$prefix/libexec/openjdk.jdk"
    dest="$JVM_DIR/$link_name"

    if [[ -L "$dest" && "$(readlink "$dest")" == "$target" ]]; then
        echo "ok $link_name -> $target"
        return
    fi

    echo "linking $link_name -> $target (requires sudo)"
    sudo ln -sfn "$target" "$dest"
}

link_jdk "openjdk@17" "openjdk-17.jdk"
link_jdk "openjdk"    "openjdk.jdk"

echo "Java symlinks configured."
