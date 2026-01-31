#!/bin/bash
set -e

# Configuration
if [ -z "$JAVA_HOME" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        export JAVA_HOME=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
    elif [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ]; then
        export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
    fi
fi

if [ -z "$ANDROID_HOME" ]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
fi

export ANDROID_SDK_ROOT=$ANDROID_HOME

if [ -z "$GRADLE_HOME" ] && [ -d "$PWD/gradle-8.5" ]; then
    export GRADLE_HOME=$PWD/gradle-8.5
fi

if [ -d "$PWD/node_modules/.bin" ]; then
    export PATH=$PWD/node_modules/.bin:$PATH
fi

export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin
if [ -n "$GRADLE_HOME" ]; then
    export PATH=$PATH:$GRADLE_HOME/bin
fi

# Project paths
PLUGIN_PATH=$PWD
if [ "$(uname)" == "Darwin" ]; then
    TEST_PROJECT_DIR=$(mktemp -d /tmp/build_test_inappbrowser.XXXXXX)
else
    TEST_PROJECT_DIR=$(mktemp -d -t build_test_inappbrowser.XXXXXX)
fi

PROJECT_ID="com.example.buildtest"
PROJECT_NAME="BuildTest"

echo "=== Environment ==="
echo "JAVA_HOME: $JAVA_HOME"
echo "ANDROID_HOME: $ANDROID_HOME"
echo "PLUGIN_PATH: $PLUGIN_PATH"

echo "=== Cleaning up previous test project ==="
rm -rf "$TEST_PROJECT_DIR"

echo "=== Creating new Cordova project ==="
# Using cordova-android@10.1.2 for Java 8 compatibility
cordova create "$TEST_PROJECT_DIR" "$PROJECT_ID" "$PROJECT_NAME"
cd "$TEST_PROJECT_DIR"

echo "=== Adding Android Platform ==="
# Using cordova-android@10.1.2 which supports Java 8
cordova platform add android@10.1.2

echo "=== Adding Plugin (from source) ==="
cordova plugin add "$PLUGIN_PATH"

echo "=== Building Android APK ==="
cordova build android

if [ $? -eq 0 ]; then
    echo "=== BUILD SUCCESSFUL ==="
    echo "APK location: $(find platforms/android/app/build/outputs/apk/debug -name '*.apk')"
else
    echo "=== BUILD FAILED ==="
    exit 1
fi
