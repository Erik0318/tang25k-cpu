`timescale 1ns/1ps

module tb_and_gate;
    reg a;
    reg b;
    wire y;

    and_gate dut (
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
                $display("FAIL and_gate: a=%b b=%b expected=%b got=%b", a, b, expected, y);
                $fatal(1, "tb_and_gate failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_and_gate.vcd");
        $dumpvars(0, tb_and_gate);

        check(1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b0);
        check(1'b1, 1'b0, 1'b0);
        check(1'b1, 1'b1, 1'b1);

        $display("PASS tb_and_gate");
        $finish;
    end
endmodule
