#!/bin/bash

# Exit on error
set -e

PROJECT_DIR="."
SOURCES_DIR="$PROJECT_DIR/sources"
FILES_JSON="$PROJECT_DIR/files.json"
LPR_FILE="$PROJECT_DIR/webcompiler.lpr"
FPC_PATH="fpc"
PAS2JS_REPO="pas2js"

# --- Compiler Detection & Download ---

# Determine OS
OS="$(uname -s)"
ARCH="$(uname -m)"
case "$OS" in
    Linux*)     OS_TYPE=linux;; 
    Darwin*)    OS_TYPE=macos;; 
    CYGWIN*|MINGW*|MSYS*) OS_TYPE=windows;; 
    *)          OS_TYPE="unknown";;
esac

# Compiler download URLs
URL_LINUX="https://getpas2js.freepascal.org/downloads/linux/pas2js-linux-x86_64-current.zip"
URL_LINUX_ARM="https://getpas2js.freepascal.org/downloads/linux/pas2js-linux-aarch64-current.zip"
URL_WINDOWS="https://getpas2js.freepascal.org/downloads/windows/pas2js-win64-x86_64-current.zip"
URL_MACOS_INTEL="https://getpas2js.freepascal.org/downloads/darwin/pas2js-darwin-x86_64-current.zip"
URL_MACOS_ARM="https://getpas2js.freepascal.org/downloads/darwin/pas2js-darwin-aarch64-current.zip"

# 1. Check environment variable (highest priority)
if [ -n "$PAS2JS_BIN" ]; then
    echo "Using compiler from environment variable PAS2JS_BIN: $PAS2JS_BIN"
# 2. Check local bin folder
elif [ "$OS_TYPE" == "windows" ] && [ -f "bin/pas2js.exe" ]; then
    PAS2JS_BIN="bin/pas2js.exe"
elif [ -f "bin/pas2js" ]; then
    PAS2JS_BIN="bin/pas2js"
# 3. Check system path
elif command -v pas2js &> /dev/null; then
    PAS2JS_BIN="pas2js"
fi

# 4. Download if missing
if [ -z "$PAS2JS_BIN" ]; then
    echo "Compiler not found locally or in PATH. Attempting to download..."
    
    DOWNLOAD_DIR="compiler_dist"
    mkdir -p "$DOWNLOAD_DIR"
    
    DOWNLOAD_URL=""
    SEARCH_NAME="pas2js"
    
    if [ "$OS_TYPE" == "linux" ]; then
        if [ "$ARCH" == "aarch64" ]; then
             DOWNLOAD_URL="$URL_LINUX_ARM"
        else
             DOWNLOAD_URL="$URL_LINUX"
        fi
        
elif [ "$OS_TYPE" == "macos" ]; then
        if [ "$ARCH" == "arm64" ]; then
             DOWNLOAD_URL="$URL_MACOS_ARM"
        else
             DOWNLOAD_URL="$URL_MACOS_INTEL"
        fi

    elif [ "$OS_TYPE" == "windows" ]; then
        DOWNLOAD_URL="$URL_WINDOWS"
        SEARCH_NAME="pas2js.exe"
    else
        echo "Error: Auto-download not supported for OS: $OS_TYPE ($ARCH)"
        exit 1
    fi
    
    ZIP_FILE="$DOWNLOAD_DIR/pas2js.zip"
    echo "Downloading compiler from $DOWNLOAD_URL..."
    curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL" || wget -O "$ZIP_FILE" "$DOWNLOAD_URL"
    
    echo "Extracting..."
    unzip -q -o "$ZIP_FILE" -d "$DOWNLOAD_DIR"
    
    # Find binary recursively
    FOUND_BIN=$(find "$DOWNLOAD_DIR" -type f -name "$SEARCH_NAME" | head -n 1)
    if [ -n "$FOUND_BIN" ]; then
        chmod +x "$FOUND_BIN"
        PAS2JS_BIN="$FOUND_BIN"
        echo "Found binary at: $PAS2JS_BIN"
    fi
fi

if [ -z "$PAS2JS_BIN" ]; then
    echo "Error: Could not determine or download pas2js compiler."
    exit 1
fi

echo "=========================================="
echo "Build Script for WebCompiler"
echo "=========================================="
echo "OS:       $OS_TYPE"
echo "Compiler: $PAS2JS_BIN"
echo "Sources:  $SOURCES_DIR"
echo "FPC Path: $FPC_PATH"
echo "=========================================="

# Check sources
if [ ! -d "$SOURCES_DIR" ]; then
    echo "Error: Sources directory '$SOURCES_DIR' not found."
    exit 1
fi

# Check FPC directory (crucial for includes)
if [ ! -d "$FPC_PATH" ]; then
    echo "Error: FPC directory '$FPC_PATH' not found. Did you check out submodules?"
    ls -la
    echo "Git modules content:"
    cat .gitmodules || echo "No .gitmodules found"
    exit 1
fi

# Generate files.json using Python for reliable JSON formatting
echo "Generating $FILES_JSON..."
python3 -c "
import os
import json
import glob

source_dir = '$SOURCES_DIR'
files = [os.path.basename(f) for f in glob.glob(os.path.join(source_dir, '*')) if os.path.isfile(f)]
files.sort()

print(f'Found {len(files)} source files.')

with open('$FILES_JSON', 'w') as f:
    json.dump(files, f, indent=2)
"

# Compile
echo "Compiling $LPR_FILE..."

# Ensure units exist to fail fast
if [ ! -f "$FPC_PATH/utils/pas2js/webfilecache.pp" ]; then
    echo "WARNING: '$FPC_PATH/utils/pas2js/webfilecache.pp' not found. Listing FPC path:"
    find "$FPC_PATH" -maxdepth 3 | head -n 20
    echo "Compilation likely to fail."
fi

"$PAS2JS_BIN" -Tbrowser -Jc -O2 \
    "-Fu$FPC_PATH/utils/pas2js" \
    "-Fu$FPC_PATH/packages/fcl-json/src" \
    "-Fu$FPC_PATH/packages/fcl-passrc/src" \
    "-Fu$FPC_PATH/packages/pastojs/src" \
    "-Fu$FPC_PATH/packages/fcl-js/src" \
    "-Fu$PAS2JS_REPO/packages/*/src" \
    "$LPR_FILE"

echo "=========================================="
echo "Build Completed Successfully"
echo "=========================================="