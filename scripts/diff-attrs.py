#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p "python311.withPackages(ps: with ps; [glom sh])" -p nix
from collections import namedtuple
from itertools import product
import os
from io import StringIO
import sys
import sh
from glom import glom
from pprint import pprint
import json

nix = sh.Command("nix")
git = sh.Command("git")


def get_attr_keys():
    out = nix.flake.show("--json")
    attrs = glom(json.loads(out), "packages.x86_64-linux").keys()
    return set(attrs)


PR_Refs = namedtuple("PR_Refs", "head_ref base_ref")


def get_sha_refs() -> PR_Refs:
    env = os.environ
    head_ref, base_ref = (
        env.get("HEAD_REF"),
        env.get("BASE_REF"),
    )
    if not all([head_ref, base_ref]):
        raise IOError("Missing HEAD_REF or BASE_REF env variable")
    return PR_Refs(head_ref, base_ref)


def build_nix_output(attr: str, ref: str):
    print(f"Checking out: {ref}")
    sh.git.checkout(
        f"{ref}",
        _out=sys.stdout,
        _err=sys.stderr,
    )
    print(f"Building: .#{attr}")
    nix.build(
        "-o",
        f"./{ref}-{attr}",
        f".#{attr}",
        _out=sys.stdout,
        _err=sys.stderr,
    )


def diff_closures(attr: str, base_ref: str, head_ref: str, _out: StringIO):
    nix.store(
        "diff-closures",
        f"./{base_ref}-{attr}",
        f"./{head_ref}-{attr}",
        _tty_out=False,
        _out=_out,
        _err=sys.stderr,
    )


def process_diff():
    attrs = get_attr_keys()
    refs = get_sha_refs()
    head_ref, base_ref = refs
    for ref, attr in product(refs, attrs):
        pprint(
            (
                attr,
                ref,
            )
        )
        build_nix_output(attr, ref)
    io = StringIO()
    print("# Changes", file=io)
    for attr in attrs:
        print(f"## {attr}: {base_ref} -> {head_ref}", file=io)
        diff_closures(attr, base_ref, head_ref, _out=io)
        print("", file=io)
    write_to_output(io)
    clean_up(attrs, refs)


def write_to_output(val: StringIO):
    from pathlib import Path

    file = Path("./log.txt").open(mode="a")
    file.write(strip_ansi(val.getvalue()))


def clean_up(attrs: set[str], refs: PR_Refs):
    for ref, attr in product(refs, attrs):
        sh.rm("-rf", f"{ref}-{attr}")


def strip_ansi(input: str) -> str:
    import re

    ansi_escape = re.compile(
        r"""
        \x1B  # ESC
        (?:   # 7-bit C1 Fe (except CSI)
            [@-Z\\-_]
        |     # or [ for CSI, followed by a control sequence
            \[
            [0-?]*  # Parameter bytes
            [ -/]*  # Intermediate bytes
            [@-~]   # Final byte
        )
        """,
        re.VERBOSE,
    )
    return ansi_escape.sub("", input)


if __name__ == "__main__":
    process_diff()
