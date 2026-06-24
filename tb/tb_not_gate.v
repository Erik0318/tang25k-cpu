`timescale 1ns/1ps

module tb_not_gate;
    reg a;
    wire y;

    not_gate dut (
        .a(a),
        .y(y)
    );

    task check;
        input aa;
        input expected;
        begin
            a = aa;
            #1;
            if (y !== expected) begin
                $display("FAIL not_gate: a=%b expected=%b got=%b", a, expected, y);
                $fatal(1, "tb_not_gate failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_not_gate.vcd");
        $dumpvars(0, tb_not_gate);

        check(1'b0, 1'b1);
        check(1'b1, 1'b0);

        $display("PASS tb_not_gate");
        $finish;
    end
endmodule
