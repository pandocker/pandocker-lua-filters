all: html

initdir:
	cd tests; \
	make initdir

html:
	cd tests; \
	make html

install:
	pip3 install --break-system-packages -U .

uninstall:
	pip3 uninstall --break-system-packages -y pandocker-lua-filters

reinstall: uninstall install
#	pip3 install .

clean:
	rm -rf dist
	touch pandocker_lua_filters/version.py
	rm pandocker_lua_filters/version.py
	cd tests; \
	make clean

tex:
	cd tests; \
	make tex

docx:
	cd tests; \
	make docx

pdf:
	cd tests; \
	make pdf

native:
	cd tests; \
	make native

#wavedrom:
#	@echo "wavedrom"
#	docker run --rm -v $(PWD):/root -w /tmp node:10 /root/scripts/wavedrom.sh

build/svgbob: svgbob
build/svgbob.bin: svgbob
build/svgbob.exe: svgbob
svgbob:
	@echo "svgbob"
	docker run --rm -v $(PWD):/tmp -w /tmp svgbob ./scripts/svgbob.sh

wheel: build/svgbob build/svgbob.bin build/svgbob.exe
	sudo python3 setup.py bdist_wheel

check: wheel
	twine check dist/pandocker_lua_filters*.whl
