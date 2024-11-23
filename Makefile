PACKAGE = easydtx
VERSION = 0.2.0
YEAR = 2024
MONTH = 11
DAY = 23

FORMAT = support

SCRIPTS = edtx2dtx.pl
DOC = easydoctex-mode.el $(MAN:%=%.md)
MAN = edtx2dtx.1

README = README.md
LICENCE = LICENCE
CHANGELOG = CHANGELOG.md

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
