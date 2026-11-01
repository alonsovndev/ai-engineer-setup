#!/usr/bin/env python3

import errno
import os
from pathlib import Path
import pty
import select
import subprocess
import sys
import tempfile
import time


def snapshot(directory):
    entries = {}
    for parent, directories, files in os.walk(directory, followlinks=False):
        for name in directories + files:
            path = Path(parent) / name
            relative_path = str(path.relative_to(directory))
            if path.is_symlink():
                entries[relative_path] = ("symlink", os.readlink(path))
            elif path.is_file():
                entries[relative_path] = ("file", path.read_bytes())
            else:
                entries[relative_path] = ("directory",)
    return entries


def run_in_terminal(command, response, environment):
    terminal, child_terminal = pty.openpty()
    process = subprocess.Popen(
        command,
        stdin=child_terminal,
        stdout=child_terminal,
        stderr=child_terminal,
        env=environment,
    )
    os.close(child_terminal)
    output = bytearray()
    deadline = time.monotonic() + 15
    try:
        while time.monotonic() < deadline:
            readable, _, _ = select.select([terminal], [], [], 0.1)
            if not readable:
                if process.poll() is not None:
                    break
                continue
            try:
                chunk = os.read(terminal, 65536)
            except OSError as error:
                if error.errno == errno.EIO:
                    break
                raise
            if not chunk:
                break
            output.extend(chunk)
            if response is not None and b"Choose one or more numbers" in output:
                os.write(terminal, response)
                response = None
        else:
            raise AssertionError(f"Terminal interaction timed out: {output.decode()}")
        return process.wait(timeout=3), output.decode()
    finally:
        os.close(terminal)
        if process.poll() is None:
            process.kill()
            process.wait()


def main():
    clone = Path(sys.argv[1])
    work_root = Path(sys.argv[2])
    harnesses = ["claude", "codex", "opencode", "copilot", "antigravity"]
    markers = {
        "claude": ".claude/AGENTS.md",
        "codex": ".codex/AGENTS.md",
        "opencode": ".config/opencode/opencode.jsonc",
        "copilot": ".copilot/agents",
        "antigravity": ".gemini/config/AGENTS.md",
    }
    scenarios = [
        ("one tool", b"2\n", ["codex"], [], 1),
        ("multiple tools", b"1 3\n", ["claude", "opencode"], [], 1),
        ("all tools", b"6\n", harnesses, [], 1),
        ("invalid input", b"*\n3\n", ["opencode"], [], 2),
        ("invalid mixed input", b"6 12\n2\n", ["codex"], [], 2),
        ("blank input", b"\n1\n", ["claude"], [], 2),
        ("cancel", b"0\n", [], [], 1),
        ("closed input", b"\x04", [], [], 1),
        ("dry run", b"6\n", harnesses, ["--dry-run"], 1),
        ("explicit flags", None, ["claude"], ["--harness", "claude"], 0),
        ("individual selection of every tool", b"1 2 3 4 5\n", harnesses, [], 1),
    ]

    for script in ("install", "uninstall"):
        for label, response, selected, arguments, prompt_count in scenarios:
            fixture_home = Path(tempfile.mkdtemp(prefix="menu-", dir=work_root))
            environment = dict(os.environ, HOME=str(fixture_home))
            if script == "uninstall":
                subprocess.run(
                    [str(clone / "scripts/install.sh"), "--all"],
                    env=environment,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    check=True,
                )
            before = snapshot(fixture_home)
            status, output = run_in_terminal(
                [str(clone / f"scripts/{script}.sh"), *arguments],
                response,
                environment,
            )
            if status != 0:
                raise AssertionError(f"{script}: {label}: exit {status}: {output}")
            if output.count("Choose one or more numbers") != prompt_count:
                raise AssertionError(
                    f"{script}: {label}: unexpected prompt count: {output}"
                )
            if not selected or "--dry-run" in arguments:
                if snapshot(fixture_home) != before:
                    raise AssertionError(f"{script}: {label}: changed configuration")
            else:
                for harness, relative_path in markers.items():
                    installed = (fixture_home / relative_path).exists()
                    expected = (
                        harness in selected
                        if script == "install"
                        else harness not in selected
                    )
                    if installed != expected:
                        raise AssertionError(
                            f"{script}: {label}: incorrect state for {harness}"
                        )
                shared_skills = fixture_home / ".agents/skills"
                explicit_all = script == "uninstall" and label == "all tools"
                if shared_skills.is_symlink() == explicit_all:
                    raise AssertionError(
                        f"{script}: {label}: incorrect shared skills state"
                    )
                remaining = (
                    selected
                    if script == "install"
                    else [harness for harness in harnesses if harness not in selected]
                )
                if remaining:
                    verification = [str(clone / "scripts/verify.sh")]
                    for harness in remaining:
                        verification.extend(["--harness", harness])
                    result = subprocess.run(
                        verification, env=environment, capture_output=True, text=True
                    )
                    if result.returncode:
                        raise AssertionError(
                            f"{script}: {label}: {result.stdout}{result.stderr}"
                        )
            print(f"PASS  {script} terminal menu: {label}")


if __name__ == "__main__":
    main()
