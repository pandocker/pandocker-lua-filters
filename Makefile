PIPBASE= $(shell get-pip-base)

all: html

initdir:
	cd tests; \
	make initdir

html: copy
	cd tests; \
	make html

install:
	pip3 install -U .

uninstall:
	pip3 uninstall -y pandocker-lua-filters

reinstall: uninstall install
#	pip3 install .

copy:
	cp lua/* $(PIPBASE)/share/lua/5.3/pandocker/

clean:
	rm -rf dist
	cd tests; \
	make clean

tex: copy
	cd tests; \
	make tex

docx: copy
	cd tests; \
	make docx

pdf: copy
	cd tests; \
	make pdf

#wavedrom:
#	@echo "wavedrom"
#	docker run --rm -v $(PWD):/root -w /tmp node:10 /root/scripts/wavedrom.sh

svgbob:
	@echo "svgbob"
	docker run --rm -it -v $(PWD):/tmp -w /tmp joseluisq/rust-linux-darwin-builder ./scripts/svgbob.sh
	docker run --rm -v $(PWD):/tmp -w /tmp svgbob ./scripts/svgbob.sh

wheel: svgbob
	 python3 setup.py bdist_wheel

check: wheel
	twine check dist/pandocker_lua_filters*.whl
