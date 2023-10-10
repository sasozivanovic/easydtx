PACKAGE = easydtx
VERSION = 0.1.0
YEAR = 2023
MONTH = 10
DAY = 10

FORMAT = support

SCRIPTS = edtx2dtx.pl
DOC = easydoctex-mode.el
MAN = edtx2dtx.1

README = README.md
LICENCE = LICENCE

ctan/$(PACKAGE).zip:
	$(MAKE-TDS)
	$(MAKE-CTAN)

version:
	$(call EDIT-VERSION-PERL,edtx2dtx.pl)
	sed -i '1c ;; easydoctex-mode.el $(VERSION)' easydoctex-mode.el
	$(call EDIT-VERSION-MAN,edtx2dtx.1.md)

include Makefile.package
CTAN-DOC-DIR = $(CTAN-DIR)
VERSION-PERL = $(VERSION)
