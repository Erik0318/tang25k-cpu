`timescale 1ns/1ps

module tb_mux2;
    reg a;
    reg b;
    reg sel;
    wire y;

    mux2 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    task check;
        input aa;
        input bb;
        input ssel;
        input expected;
        begin
            a = aa;
            b = bb;
            sel = ssel;
            #1;
            if (y !== expected) begin
                $display("FAIL mux2: a=%b b=%b sel=%b expected=%b got=%b", a, b, sel, expected, y);
                $fatal(1, "tb_mux2 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_mux2.vcd");
        $dumpvars(0, tb_mux2);

        check(1'b0, 1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b0, 1'b0);
        check(1'b1, 1'b0, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b0, 1'b1);

        check(1'b0, 1'b0, 1'b1, 1'b0);
        check(1'b0, 1'b1, 1'b1, 1'b1);
        check(1'b1, 1'b0, 1'b1, 1'b0);
        check(1'b1, 1'b1, 1'b1, 1'b1);

        $display("PASS tb_mux2");
        $finish;
    end
endmodule
