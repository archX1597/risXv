COMPILER = vcs
GCC      = /opt/gcc-9.5.0/bin/x86_64-pc-linux-gnu-c++
VIEWER   = Verdi-Ultra
VERDI_RC = ~/.script/novas.rc
SRC_DIR  = ../src

SRC = $(SRC_DIR)/IMEM.cpp $(SRC_DIR)/IMEM.hpp $(SRC_DIR)/Imem_rd_wr_test.cpp
.PHONY:all
all: scan comp sim
.PHONY:scan
scan:
	syscan -cpp $(GCC) -kdb -cflags -g $(SRC)
.PHONY:comp
comp:
	$(COMPILER) -sysc=show_sc_main -kdb -debug_access+all -cpp $(GCC) 

.PHONY:sim
sim:
	./simv -ucli -do dump.tcl

.PHONY:wave
wave:
	$(VIEWER) -rcFile $(VERDI_RC) -dbdir ./simv.daidir -simBin simv -ssf *.fsdb &

.PHONY:clean
clean:
	rm *fsdb \
		*.log \
		simv  \
		-r ./simv.daidir \
		-r ./verdiLog \
		-r ./csrc \
		-r ./Verdi-UltraLog \
		-r ./vfastLog \
		*novas*
