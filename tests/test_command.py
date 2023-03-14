from __future__ import annotations

from typing import TYPE_CHECKING

import pytest

from poetry_dev_version.command import DevVersionCommand

if TYPE_CHECKING:
    from cleo.testers.command_tester import CommandTester

    from .types import CommandTesterFactory


@pytest.fixture()
def command() -> DevVersionCommand:
    return DevVersionCommand()


@pytest.fixture
def tester(command_tester_factory: CommandTesterFactory) -> CommandTester:
    return command_tester_factory("dev-version")


@pytest.mark.parametrize(
    "level, build_number, local, current_version, expected",
    [
        ("rc", 12, None, "0.0.1", "0.0.1rc12"),
        ("rc", 2, "git.24fd2396", "0.1.0", "0.1.0rc2+git.24fd2396"),
        ("alpha", 23, None, "1.0.1", "1.0.1a23"),
        ("alpha", 9, "git.24fd2396", "3.1.0", "3.1.0a9+git.24fd2396"),
        ("beta", 2, None, "1.0.1rc12", "1.0.1b2"),
        ("beta", 9, None, "3.1.0a10+git.24fd2396", "3.1.0b9+git.24fd2396"),
        ("dev", 2, None, "1.0.1rc12", "1.0.1rc12.dev2"),
        ("dev", 9, None, "3.1.0a10+git.24fd2396", "3.1.0a10.dev9+git.24fd2396"),
    ],
)
def test_set_development_version(
    level: str, build_number: int, local: str | None, current_version: str, expected: str, command: DevVersionCommand
):
    assert (
        command.set_development_version(
            level=level,
            build_number=build_number,
            local=local,
            current_version=current_version,
        ).text
        == expected
    )
