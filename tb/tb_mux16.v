`timescale 1ns/1ps

module tb_mux16;
    reg [15:0] a;
    reg [15:0] b;
    reg sel;
    wire [15:0] y;

    mux16 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task check;
        input [15:0] aa;
        input [15:0] bb;
        input ssel;
        input [15:0] expected;
        begin
            a = aa;
            b = bb;
            sel = ssel;
            #1;
            if (y !== expected) begin
                $display("FAIL mux16: a=%h b=%h sel=%b expected=%h got=%h", a, b, sel, expected, y);
                $fatal(1, "tb_mux16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_mux16.vcd");
        $dumpvars(0, tb_mux16);

        check(16'h0000, 16'hffff, 1'b0, 16'h0000);
        check(16'h0000, 16'hffff, 1'b1, 16'hffff);
        check(16'h1234, 16'habcd, 1'b0, 16'h1234);
        check(16'h1234, 16'habcd, 1'b1, 16'habcd);

        $display("PASS tb_mux16");
        $finish;
    end
endmodule
