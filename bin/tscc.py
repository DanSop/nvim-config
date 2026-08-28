"""C compiler shim for the tree-sitter CLI on Windows with mingw gcc.

The CLI canonicalises its output path into the extended-length form
(a leading backslash-backslash-question-mark-backslash) and mingw's ld
refuses to open such a path. Everything else it passes is plain gcc, so
strip that prefix from every argument and hand the rest to gcc unchanged.
Called through tscc.cmd, which init.lua names in CC_x86_64_pc_windows_msvc
so that only the tree-sitter CLI's cc crate sees it.
"""

import subprocess
import sys

PREFIX = "\\\\?\\"


def strip(arg: str) -> str:
    if arg.startswith(PREFIX):
        return arg[len(PREFIX) :]
    for flag in ("-o", "-I", "-L"):
        if arg.startswith(flag + PREFIX):
            return flag + arg[len(flag) + len(PREFIX) :]
    return arg


args = [strip(a) for a in sys.argv[1:]]
sys.exit(subprocess.call(["gcc", "-static-libgcc", *args]))
