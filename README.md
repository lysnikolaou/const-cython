# const-cython

This project aims to create a small easily-reproducible example of how Cython does not support
the following scenario:

- A library package `const-cython-lib` defines a Cython `cdef` function that does not have `const`
  in its arguments in version 1.0.0. In version 1.0.1, it adds `const` to the function.
- A client package `const-cython-client` depends on `const-cython-lib` and, specifically, to the
  above-mentioned function. It is built against version 1.0.0 (without `const`), but it's installed alongside
  version 1.0.1 (with `const`). *This is in contrast to C/C++ semantics, which would allow it.*

Importing `const-cython-client` in this scenario fails with the following stack trace:

```python3
const-cython on  main via 🐍 pyenv 3.11.3 (venv) 
❯ python
Python 3.11.3 (main, May  8 2023, 13:16:43) [Clang 14.0.3 (clang-1403.0.22.14.1)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import cythonconst
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/Users/lysnikolaou/repos/python/const-cython/venv/lib/python3.11/site-packages/cythonconst/__init__.py", line 1, in <module>
    from cythonconst.plus import plus_1
  File "cythonconst/plus.pyx", line 1, in init cythonconst.plus
TypeError: C function libcythonconst.lsum.lsum has wrong signature (expected PyObject *(int, int), got PyObject *(int const , int const ))
```

In order to reproduce this, you can do the following (or run `make test`):

```zsh
const-cython on  main via 🐍 pyenv 3.11.3
❯ python -m venv venv

const-cython on  main [?] via 🐍 pyenv 3.11.3 took 2s
❯ source venv/bin/activate

const-cython on  main [?] via 🐍 pyenv 3.11.3 (venv)
❯ python -m pip install cythonconst
Collecting cythonconst
  Using cached cythonconst-1.1.0-cp311-cp311-macosx_13_0_arm64.whl (29 kB)
Collecting libcythonconst
  Using cached libcythonconst-1.0.1-cp311-cp311-macosx_13_0_arm64.whl (27 kB)
Installing collected packages: libcythonconst, cythonconst
Successfully installed cythonconst-1.1.0 libcythonconst-1.0.1

[notice] A new release of pip available: 22.3.1 -> 23.1.2
[notice] To update, run: pip install --upgrade pip

const-cython on  main [?] via 🐍 pyenv 3.11.3 (.venv)
❯ python
Python 3.11.3 (main, May  8 2023, 13:16:43) [Clang 14.0.3 (clang-1403.0.22.14.1)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import cythonconst
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/Users/lysnikolaou/repos/python/const-cython/.venv/lib/python3.11/site-packages/cythonconst/__init__.py", line 1, in <module>
    from cythonconst.plus import plus_1
  File "cythonconst/plus.pyx", line 1, in init cythonconst.plus
TypeError: C function libcythonconst.lsum.lsum has wrong signature (expected PyObject *(int const , int const ), got PyObject *(int, int))
```

See [`pyproject.toml` in client](client/pyproject.toml) for some extra info on how this is built to fail.
