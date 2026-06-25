IVERILOG=iverilog
VVP=vvp

.PHONY: test \
	test-and_gate test-nand_gate test-or_gate test-xor_gate test-not_gate \
	test-mux2 test-mux16 test-dmux \
	test-half_adder test-full_adder test-add16 test-inc16 \
	test-reg16 test-pc16 test-ram16 test-rom16 test-hack_cpu \
	clean

test: test-and_gate test-nand_gate test-or_gate test-xor_gate test-not_gate \
	test-mux2 test-mux16 test-dmux \
	test-half_adder test-full_adder test-add16 test-inc16 \
	test-reg16 test-pc16 test-ram16 test-rom16 test-hack_cpu

test-and_gate:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_and_gate rtl/gates/and_gate.v tb/tb_and_gate.v
	$(VVP) build/tb_and_gate

test-nand_gate:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_nand_gate rtl/gates/nand_gate.v tb/tb_nand_gate.v
	$(VVP) build/tb_nand_gate

test-or_gate:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_or_gate rtl/gates/or_gate.v tb/tb_or_gate.v
	$(VVP) build/tb_or_gate

test-xor_gate:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_xor_gate rtl/gates/xor_gate.v tb/tb_xor_gate.v
	$(VVP) build/tb_xor_gate

test-not_gate:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_not_gate rtl/gates/not_gate.v tb/tb_not_gate.v
	$(VVP) build/tb_not_gate

test-mux2:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_mux2 rtl/gates/mux2.v tb/tb_mux2.v
	$(VVP) build/tb_mux2

test-mux16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_mux16 rtl/gates/mux16.v tb/tb_mux16.v
	$(VVP) build/tb_mux16

test-dmux:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_dmux rtl/gates/dmux.v tb/tb_dmux.v
	$(VVP) build/tb_dmux

test-half_adder:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_half_adder rtl/alu/half_adder.v tb/tb_half_adder.v
	$(VVP) build/tb_half_adder

test-full_adder:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_full_adder rtl/alu/full_adder.v tb/tb_full_adder.v
	$(VVP) build/tb_full_adder

test-add16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_add16 rtl/alu/add16.v tb/tb_add16.v
	$(VVP) build/tb_add16

test-inc16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_inc16 rtl/alu/inc16.v tb/tb_inc16.v
	$(VVP) build/tb_inc16

test-reg16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_reg16 rtl/cpu/reg16.v tb/tb_reg16.v
	$(VVP) build/tb_reg16

test-pc16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_pc16 rtl/cpu/pc16.v tb/tb_pc16.v
	$(VVP) build/tb_pc16

test-ram16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_ram16 rtl/memory/ram16.v tb/tb_ram16.v
	$(VVP) build/tb_ram16

test-rom16:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_rom16 rtl/memory/rom16.v tb/tb_rom16.v
	$(VVP) build/tb_rom16

test-hack_cpu:
	mkdir -p build waves
	$(IVERILOG) -g2012 -o build/tb_hack_cpu rtl/alu/alu16.v rtl/cpu/reg16.v rtl/cpu/pc16.v rtl/cpu/hack_cpu.v tb/tb_hack_cpu.v
	$(VVP) build/tb_hack_cpu

clean:
	rm -rf build waves
