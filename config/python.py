from typing import List


config_requires: List[str] = []
dev_requires: List[str] = []
install_requires: List[str] = []
make_requires: List[str] = [
    "pymakehelper",
    "pydmt",
]
test_requires: List[str] = []
requires = config_requires + install_requires + make_requires + test_requires
