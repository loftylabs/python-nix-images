#!/usr/bin/env nix-shell
#!nix-shell -p skopeo -i bash
# shellcheck shell=bash
set -eu

nix run .#"${NIX_PACKAGE}".copyTo -- "${IMAGE_URI:-docker://loftylabs/python-nix-images:latest}"
