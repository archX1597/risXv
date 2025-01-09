COMPILER = vcs
GCC      = /opt/gcc-9.5.0/bin/x86_64-pc-linux-gnu-c++
VIEWER   = Verdi-Ultra
VERDI_RC = ~/.script/novas.rc
SRC_DIR  = ../src

.PHONY:all
all: scan comp sim
.PHONY:scan
scan:
	syscan -cpp $(GCC) -kdb -cflags -g $(SRC_DIR)/*.cpp
.PHONY:comp
comp:
	$(COMPILER) -sysc=show_sc_main -kdb -debug_access+all $(SRC_DIR)/*.cpp -cpp $(GCC) 

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
