all: html

initdir:
	cd tests; \
	make initdir

html:
	cd tests; \
	make html

install:
	pip3 install .

uninstall:
	pip3 uninstall -y pandocker-lua-filters

reinstall: uninstall install
#	pip3 install .

clean:
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
