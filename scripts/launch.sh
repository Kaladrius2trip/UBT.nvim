#!/bin/bash
# launch.sh – Cross-platform UBT launcher (RunUBT.sh or dotnet fallback)

# Exit immediately if a command exits with a non-zero status.
set -e

# --- 1. Get Engine Path ---
# The first argument is always the absolute path to the Unreal Engine root.
ENGINE_PATH="$1"
if [[ -z "$ENGINE_PATH" ]]; then
    echo "[launch.sh] ERROR: Missing Engine Path argument." >&2
    exit 1
fi

# Remove the first argument (Engine Path) from the list of arguments.
shift

# --- 2. Try RunUBT.sh first (Linux source builds), fall back to dotnet ---
RUN_UBT="${ENGINE_PATH}/Engine/Build/BatchFiles/RunUBT.sh"
UBT_DLL="${ENGINE_PATH}/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool.dll"

if [[ -x "$RUN_UBT" ]]; then
    # Linux source build: use RunUBT.sh directly
    "$RUN_UBT" "$@"
elif [[ -f "$UBT_DLL" ]]; then
    # Installed build or Windows-style: use dotnet
    dotnet "$UBT_DLL" "$@"
else
    echo "[launch.sh] ERROR: Neither RunUBT.sh nor UnrealBuildTool.dll found." >&2
    echo "  Tried: $RUN_UBT" >&2
    echo "  Tried: $UBT_DLL" >&2
    exit 1
fi

exit $?
