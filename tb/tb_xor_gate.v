`timescale 1ns/1ps

module tb_xor_gate;
    reg a;
    reg b;
    wire y;

    xor_gate dut (
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
                $display("FAIL xor_gate: a=%b b=%b expected=%b got=%b", a, b, expected, y);
                $fatal(1, "tb_xor_gate failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_xor_gate.vcd");
        $dumpvars(0, tb_xor_gate);

        check(1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b1);
        check(1'b1, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b0);

        $display("PASS tb_xor_gate");
        $finish;
    end
endmodule
