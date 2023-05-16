PYTHON ?= python
PYTHON_VENV ?= ./venv/bin/python
TWINE_VENV ?= ./venv/bin/twine

venv:
	$(PYTHON) -m venv venv
	$(PYTHON_VENV) -m pip install --upgrade pip
	$(PYTHON_VENV) -m pip install -r requirements.txt


build-libconst:
	cp lib/libcythonconst/lsum_const.pxd lib/libcythonconst/lsum.pxd
	cp lib/libcythonconst/lsum_const.pyx lib/libcythonconst/lsum.pyx
	$(PYTHON_VENV) bump.py --patch lib
	$(PYTHON_VENV) -m build lib

build-libnoconst:
	cp lib/libcythonconst/lsum_noconst.pxd lib/libcythonconst/lsum.pxd
	cp lib/libcythonconst/lsum_noconst.pyx lib/libcythonconst/lsum.pyx
	$(PYTHON_VENV) bump.py --minor lib
	$(PYTHON_VENV) -m build lib

build-client:
	# $(PYTHON_VENV) bump.py --minor client
	$(PYTHON_VENV) -m build client

upload-lib:
	$(TWINE_VENV) upload lib/dist/*

upload-client:
	$(TWINE_VENV) upload client/dist/*

clean:
	rm -f lib/const_cython_lib/lsum.pxd lib/const_cython_lib/lsum.pyx
	rm -f lib/const_cython_lib/lsum.c lib/const_cython_lib/lsum.h
	rm -rf lib/dist
	rm -rf lib/*.egg-info
	rm -f client/const_cython_client.c
	rm -rf client/dist
	rm -rf client/*.egg-info

clean-venv: clean
	rm -rf venv

