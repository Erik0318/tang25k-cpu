`timescale 1ns/1ps

module tb_nand_gate;
    reg a;
    reg b;
    wire y;

    nand_gate dut (
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
                $display("FAIL nand_gate: a=%b b=%b expected=%b got=%b", a, b, expected, y);
                $fatal(1, "tb_nand_gate failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_nand_gate.vcd");
        $dumpvars(0, tb_nand_gate);

        check(1'b0, 1'b0, 1'b1);
        check(1'b0, 1'b1, 1'b1);
        check(1'b1, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b0);

        $display("PASS tb_nand_gate");
        $finish;
    end
endmodule
