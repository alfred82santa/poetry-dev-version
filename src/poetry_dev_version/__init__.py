try:
    import importlib.metadata as importlib_metadata
except ModuleNotFoundError:  # pragma: no cover
    import importlib_metadata

from .command import DevVersionCommand
from .plugin import DevVersionPlugin

__all__ = ["DevVersionCommand", "DevVersionPlugin", "__version__"]

try:
    __version__ = importlib_metadata.version(__name__)
except importlib_metadata.PackageNotFoundError:
    __version__ = "0.1.0"
