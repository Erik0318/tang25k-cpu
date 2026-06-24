`timescale 1ns/1ps

module tb_inc16;
    reg [15:0] a;
    wire [15:0] y;

    inc16 dut (
        .a(a),
        .y(y)
    );

    task check;
        input [15:0] aa;
        input [15:0] expected;
        begin
            a = aa;
            #1;
            if (y !== expected) begin
                $display("FAIL inc16: a=%h expected=%h got=%h", a, expected, y);
                $fatal(1, "tb_inc16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_inc16.vcd");
        $dumpvars(0, tb_inc16);

        check(16'h0000, 16'h0001);
        check(16'h0001, 16'h0002);
        check(16'h1234, 16'h1235);
        check(16'hfffe, 16'hffff);
        check(16'hffff, 16'h0000);

        $display("PASS tb_inc16");
        $finish;
    end
endmodule
