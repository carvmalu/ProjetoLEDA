#!/usr/bin/env bash
set -euo pipefail

# Run the Haskell example inside a Docker container with GHC
cd "$(dirname "$0")"
docker run --rm -v "$PWD":/src -w /src haskell:latest sh -c "ghc Main.hs -o main && ./main"
