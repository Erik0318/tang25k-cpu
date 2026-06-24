`timescale 1ns/1ps

module tb_reg16;
    reg clk;
    reg reset;
    reg load;
    reg [15:0] in;
    wire [15:0] out;

    reg16 dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .in(in),
        .out(out)
    );

    always #5 clk = ~clk;

    task step;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task expect_out;
        input [15:0] expected;
        begin
            if (out !== expected) begin
                $display("FAIL reg16: expected out=%h got=%h", expected, out);
                $fatal(1, "tb_reg16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_reg16.vcd");
        $dumpvars(0, tb_reg16);

        clk = 1'b0;
        reset = 1'b1;
        load = 1'b0;
        in = 16'h1234;
        step();
        expect_out(16'h0000);

        reset = 1'b0;
        load = 1'b1;
        in = 16'hbeef;
        step();
        expect_out(16'hbeef);

        load = 1'b0;
        in = 16'h4444;
        step();
        expect_out(16'hbeef);

        load = 1'b1;
        in = 16'habcd;
        step();
        expect_out(16'habcd);

        reset = 1'b1;
        load = 1'b1;
        in = 16'hffff;
        step();
        expect_out(16'h0000);

        $display("PASS tb_reg16");
        $finish;
    end
endmodule
