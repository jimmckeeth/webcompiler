#!/bin/bash

# Exit on error
set -e

DEMO_DIR="webcompiler"
SOURCES_DIR="$DEMO_DIR/sources"
FILES_JSON="$DEMO_DIR/files.json"
LPR_FILE="$DEMO_DIR/webcompiler.lpr"

# Default compiler path, can be overridden by env var
PAS2JS_BIN="${PAS2JS_BIN:-pas2js}"

FPC_PATH="fpc"
PAS2JS_REPO="pas2js"

echo "=========================================="
echo "Build Script for WebCompiler"
echo "=========================================="
echo "Compiler: $PAS2JS_BIN"
echo "Sources:  $SOURCES_DIR"
echo "FPC Path: $FPC_PATH"
echo "=========================================="

# Check compiler
if ! command -v "$PAS2JS_BIN" &> /dev/null && [ ! -f "$PAS2JS_BIN" ]; then
    echo "Error: Compiler '$PAS2JS_BIN' not found."
    exit 1
fi

# Check sources
if [ ! -d "$SOURCES_DIR" ]; then
    echo "Error: Sources directory '$SOURCES_DIR' not found."
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
