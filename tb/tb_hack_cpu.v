`timescale 1ns/1ps

module tb_hack_cpu;
    reg clk;
    reg reset;
    reg [15:0] instruction;
    reg [15:0] inM;

    wire [15:0] outM;
    wire writeM;
    wire [14:0] addressM;
    wire [14:0] pc;

    hack_cpu dut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .inM(inM),
        .outM(outM),
        .writeM(writeM),
        .addressM(addressM),
        .pc(pc)
    );

    always #5 clk = ~clk;

    task step;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task expect_core;
        input [15:0] expected_a;
        input [15:0] expected_d;
        input [14:0] expected_pc;
        begin
            if (dut.a_out !== expected_a || dut.d_out !== expected_d || pc !== expected_pc) begin
                $display("FAIL hack_cpu core: expected A=%h D=%h PC=%h got A=%h D=%h PC=%h",
                         expected_a, expected_d, expected_pc, dut.a_out, dut.d_out, pc);
                $fatal(1, "tb_hack_cpu failed");
            end
        end
    endtask

    task expect_mem;
        input expected_writeM;
        input [14:0] expected_addressM;
        input [15:0] expected_outM;
        begin
            if (writeM !== expected_writeM || addressM !== expected_addressM || outM !== expected_outM) begin
                $display("FAIL hack_cpu memory: expected writeM=%b addressM=%h outM=%h got writeM=%b addressM=%h outM=%h",
                         expected_writeM, expected_addressM, expected_outM, writeM, addressM, outM);
                $fatal(1, "tb_hack_cpu failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_hack_cpu.vcd");
        $dumpvars(0, tb_hack_cpu);

        clk = 1'b0;
        reset = 1'b1;
        instruction = 16'h0000;
        inM = 16'h0000;

        // Reset clears A, D, and PC.
        step();
        expect_core(16'h0000, 16'h0000, 15'h0000);

        reset = 1'b0;

        // @21: A = 21, PC increments.
        instruction = 16'd21;
        step();
        expect_core(16'd21, 16'h0000, 15'd1);

        // D=A: D = 21, PC increments.
        instruction = 16'hec10;
        step();
        expect_core(16'd21, 16'd21, 15'd2);

        // @7: A = 7, PC increments.
        instruction = 16'd7;
        step();
        expect_core(16'd7, 16'd21, 15'd3);

        // M=D: write D to RAM[A].
        instruction = 16'he308;
        #1;
        expect_mem(1'b1, 15'd7, 16'd21);
        step();
        expect_core(16'd7, 16'd21, 15'd4);

        // D=M: read external memory input into D.
        instruction = 16'hfc10;
        inM = 16'h1234;
        step();
        expect_core(16'd7, 16'h1234, 15'd5);

        // @42: set jump target.
        instruction = 16'd42;
        step();
        expect_core(16'd42, 16'h1234, 15'd6);

        // 0;JMP: unconditional jump to A.
        instruction = 16'hea87;
        step();
        expect_core(16'd42, 16'h1234, 15'd42);

        // D=0.
        instruction = 16'hea90;
        step();
        expect_core(16'd42, 16'h0000, 15'd43);

        // @55: set jump target.
        instruction = 16'd55;
        step();
        expect_core(16'd55, 16'h0000, 15'd44);

        // D;JEQ: D is zero, so jump to A.
        instruction = 16'he302;
        step();
        expect_core(16'd55, 16'h0000, 15'd55);

        // @1 then D=A: make D positive.
        instruction = 16'd1;
        step();
        expect_core(16'd1, 16'h0000, 15'd56);

        instruction = 16'hec10;
        step();
        expect_core(16'd1, 16'h0001, 15'd57);

        // @60: set jump target.
        instruction = 16'd60;
        step();
        expect_core(16'd60, 16'h0001, 15'd58);

        // D;JGT: D is positive, so jump to A.
        instruction = 16'he301;
        step();
        expect_core(16'd60, 16'h0001, 15'd60);

        $display("PASS tb_hack_cpu");
        $finish;
    end
endmodule
