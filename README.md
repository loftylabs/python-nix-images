# Lofty Python Images from Nix

## Goals
Utilize base images for all apps which consist of routinely scanned and
self-managed reproducible bases. Eliminate confusion and wasteful builds with c
compiled dependencies and version mismatches.

## Image Support
Python N-1 (Currently 3.11 and 3.10 as of 06/22/2023)
GDAL Layer

## Contributing
This project uses a nix flake and can be started by entering
```bash
nix develop .
```
Or, if you have direnv, a [.envrc](./.envrc) is in the repo so you can
```bash
direnv allow .envrc
```

## Mentions
Thanks to nix2container, nixos, and all those keeping nixpkgs up to date!
