TARGETS	=all clean clobber diff distclean import install uninstall
TARGET	=all

SUBDIRS	=

.PHONY:	${TARGETS} ${SUBDIRS}

PREFIX	=/opt
BINDIR	=${PREFIX}/bin

INSTALL	=install

FILES	=cache-osd

MODE	=0755

all::	${FILES}

${TARGETS}::

clobber distclean:: clean

define	DIFF_template
.PHONY: diff-${1}
diff-${1}: ${1}
	@cmp -s $${BINDIR}/${1} ${1} || $${SHELL} -xc "diff -uNp $${BINDIR}/${1} ${1}"
diff:: diff-${1}
endef

$(foreach f,${FILES},$(eval $(call DIFF_template,${f})))

define	IMPORT_template
.PHONY: import-${1}
import-${1}: $${BINDIR}/${1}
	@cmp -s $${BINDIR}/${1} ${1} || $${SHELL} -xc "${INSTALL} -Dc -m ${MODE} $${BINDIR}/${1} ${1}"
import:: import-${1}
endef

$(foreach f,${FILES},$(eval $(call IMPORT_template,${f})))

define	INSTALL_template
.PHONY: install-${1}
install-${1}: ${1}
	@cmp -s $${BINDIR}/${1} ${1} || $${SHELL} -xc "${INSTALL} -Dc -m ${MODE} ${1} $${BINDIR}/${1}"
install:: install-${1}
endef

$(foreach f,${FILES},$(eval $(call INSTALL_template,${f})))

define	UNINSTALL_template
.PHONY: uninstall-${1}
uninstall-${1}: ${1}
	${RM} $${BINDIR}/${1}
uninstall:: uninstall-${1}
endef

$(foreach f,${FILES},$(eval $(call UNINSTALL_template,${f})))

# Keep at bottom so we do local stuff first.

# ${TARGETS}::
#	${MAKE} TARGET=$@ ${SUBDIRS}

# ${SUBDIRS}::
#	${MAKE} -C $@ ${TARGET}
