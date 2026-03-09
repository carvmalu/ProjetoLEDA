Haskell examples
-----------------

This repository contains Haskell implementations under `Implementacoes/Haskell`.

To build and run the small example (uses `Data.Vector.Simple`), you can use
Docker so you don't need GHC installed locally.

Run the example with:

```bash
./run.sh
```

What I changed for convenience
- Added a portable test module at `Data/Vector/Simple.hs` (a list-backed
	implementation) so the example compiles in a vanilla GHC Docker image.
- Kept your original implementation in `Implementacoes/Haskell/ArrayList.hs` as reference.
- Created `run.sh` which compiles and runs `Main.hs` inside `haskell:latest` Docker image.

If you prefer the original primitive-based implementation to be used directly,
we can restore it to `Data/Vector/Simple.hs` and adjust the environment to
compile with a local GHC (requires ghcup/cabal and disk space).

