`timescale 1ns/1ps

module tb_add16;
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;

    add16 dut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    task check;
        input [15:0] aa;
        input [15:0] bb;
        input [15:0] expected;
        begin
            a = aa;
            b = bb;
            #1;
            if (sum !== expected) begin
                $display("FAIL add16: a=%h b=%h expected=%h got=%h", a, b, expected, sum);
                $fatal(1, "tb_add16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_add16.vcd");
        $dumpvars(0, tb_add16);

        check(16'h0000, 16'h0000, 16'h0000);
        check(16'h0001, 16'h0001, 16'h0002);
        check(16'h1234, 16'h1111, 16'h2345);
        check(16'hffff, 16'h0001, 16'h0000);
        check(16'h8000, 16'h8000, 16'h0000);
        check(16'habcd, 16'h1234, 16'hbe01);

        $display("PASS tb_add16");
        $finish;
    end
endmodule
