#!/usr/bin/env python3
"""Convert Rime's pinyin_simp.dict.yaml to the keyboard's bundled TSV."""

import argparse
import hashlib
import re
from pathlib import Path

SOURCE_COMMIT = "0c6861ef7420ee780270ca6d993d18d4101049d0"
SOURCE_SHA256 = "e341598343a0f0f2035bb1aafc34a7f3bb7887deeecb3f60796262aaa2983e6b"
PINYIN = re.compile(r"[a-z]+(?: [a-z]+)*")


def convert(source: Path, output: Path) -> None:
    source_bytes = source.read_bytes()
    if hashlib.sha256(source_bytes).hexdigest() != SOURCE_SHA256:
        raise ValueError(f"Expected the dictionary from rime/rime-pinyin-simp at {SOURCE_COMMIT}")

    lines = source_bytes.decode("utf-8").splitlines()
    first_entry_index = lines.index("...") + 1
    entries: list[tuple[str, str, int]] = []
    for line_number, line in enumerate(lines[first_entry_index:], first_entry_index + 1):
        if not line:
            continue
        fields = line.split("\t")
        if len(fields) != 3:
            raise ValueError(f"Expected three tab-separated fields at line {line_number}")
        candidate, pinyin, weight = fields
        if not candidate or not PINYIN.fullmatch(pinyin) or not re.fullmatch(r"[0-9]+", weight):
            raise ValueError(f"Invalid dictionary entry at line {line_number}")
        entries.append((pinyin, candidate, int(weight)))

    entries.sort(key=lambda entry: (entry[0], -entry[2], entry[1]))
    with output.open("w", encoding="utf-8", newline="\n") as destination:
        for pinyin, candidate, weight in entries:
            destination.write(f"{pinyin}\t{candidate}\t{weight}\n")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="path to the pinned Rime YAML dictionary")
    parser.add_argument("output", type=Path, help="output TSV path")
    args = parser.parse_args()
    convert(args.source, args.output)


if __name__ == "__main__":
    main()
