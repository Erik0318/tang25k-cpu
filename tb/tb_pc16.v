`timescale 1ns/1ps

module tb_pc16;
    reg clk;
    reg reset;
    reg load;
    reg inc;
    reg [15:0] in;
    wire [15:0] out;

    pc16 dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .inc(inc),
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
                $display("FAIL pc16: expected out=%h got=%h", expected, out);
                $fatal(1, "tb_pc16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_pc16.vcd");
        $dumpvars(0, tb_pc16);

        clk = 1'b0;
        reset = 1'b1;
        load = 1'b0;
        inc = 1'b0;
        in = 16'h2222;
        step();
        expect_out(16'h0000);

        reset = 1'b0;
        load = 1'b1;
        inc = 1'b0;
        in = 16'h1000;
        step();
        expect_out(16'h1000);

        load = 1'b0;
        inc = 1'b1;
        step();
        expect_out(16'h1001);
        step();
        expect_out(16'h1002);

        inc = 1'b0;
        in = 16'h7777;
        step();
        expect_out(16'h1002);

        load = 1'b1;
        inc = 1'b1;
        in = 16'habcd;
        step();
        expect_out(16'habcd);

        reset = 1'b1;
        load = 1'b1;
        inc = 1'b1;
        in = 16'hffff;
        step();
        expect_out(16'h0000);

        $display("PASS tb_pc16");
        $finish;
    end
endmodule
