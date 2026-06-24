`timescale 1ns/1ps

module tb_or_gate;
    reg a;
    reg b;
    wire y;

    or_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    task check;
        input aa;
        input bb;
        input expected;
        begin
            a = aa;
            b = bb;
            #1;
            if (y !== expected) begin
                $display("FAIL or_gate: a=%b b=%b expected=%b got=%b", a, b, expected, y);
                $fatal(1, "tb_or_gate failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_or_gate.vcd");
        $dumpvars(0, tb_or_gate);

        check(1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b1);
        check(1'b1, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b1);

        $display("PASS tb_or_gate");
        $finish;
    end
endmodule
