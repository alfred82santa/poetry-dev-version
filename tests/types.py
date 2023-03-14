from __future__ import annotations

from typing import TYPE_CHECKING, Protocol

if TYPE_CHECKING:
    from cleo.testers.command_tester import CommandTester
    from poetry.installation import Installer
    from poetry.installation.executor import Executor
    from poetry.poetry import Poetry
    from poetry.utils.env import Env


class CommandTesterFactory(Protocol):
    def __call__(
        self,
        command: str,
        poetry: Poetry | None = None,
        installer: Installer | None = None,
        executor: Executor | None = None,
        environment: Env | None = None,
    ) -> CommandTester:
        ...
