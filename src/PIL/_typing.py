from __future__ import annotations

import os
import sys
from collections.abc import Sequence
from typing import TYPE_CHECKING, Any, Protocol, TypeVar, Union

if TYPE_CHECKING:
    try:
        import numpy.typing as npt

        NumpyArray = npt.NDArray[Any]  # requires numpy>=1.21
    except (ImportError, AttributeError):
        pass

if sys.version_info >= (3, 10):
    from typing import TypeGuard
else:
    try:
        from typing_extensions import TypeGuard
    except ImportError:

        class TypeGuard:  # type: ignore[no-redef]
            def __class_getitem__(cls, item: Any) -> type[bool]:
                return bool


Coords = Union[Sequence[float], Sequence[Sequence[float]]]


_T_co = TypeVar("_T_co", covariant=True)


class SupportsRead(Protocol[_T_co]):
    def read(self, __length: int = ...) -> _T_co: ...


StrOrBytesPath = Union[str, bytes, "os.PathLike[str]", "os.PathLike[bytes]"]


__all__ = ["TypeGuard", "StrOrBytesPath", "SupportsRead"]
