
# --- Constants -------------------------------------------------------------

# name of project
project = mypack

# name of R program
R = R

# --- Default target --------------------------------------------------------

all: help

# --- Help ------------------------------------------------------------------

help:
	@echo ""
	@echo "build  ... build package 'mypack'"
	@echo "check  ... check package 'mypack'"
	@echo "clean  ... clear working space"
	@echo ""

# --- Phony targets ---------------------------------------------------------

.PHONY: all help clean maintainer-clean clean build check

# --- mypack ----------------------------------------------------------------

build:
	${R} CMD build ${project}

check:
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 ${R} CMD check ${project}_*.tar.gz)

valgrind:
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 ${R} CMD check --use-valgrind ${project}_*.tar.gz)

# --- Clear working space ---------------------------------------------------

clean:
	@rm -rf ${project}.Rcheck
	@rm -fv ${project}_*.tar.gz
	@rm -fv ${project}/src/*.o ${project}/src/*.so 
	@find -L . -type f -name "*~" -exec rm -v {} ';'

maintainer-clean: clean

# --- End -------------------------------------------------------------------
