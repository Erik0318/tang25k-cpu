IVERILOG=iverilog
VVP=vvp
 
.PHONY: test-and clean
 
test-and:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_and_gate rtl/gates/and_gate.v sim/tb_and_gate.v
	$(VVP) build/tb_and_gate
 
clean:
	rm -rf build waves
