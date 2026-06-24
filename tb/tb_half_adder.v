`timescale 1ns/1ps

module tb_half_adder;
    reg a;
    reg b;
    wire sum;
    wire carry;

    half_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    task check;
        input aa;
        input bb;
        input expected_sum;
        input expected_carry;
        begin
            a = aa;
            b = bb;
            #1;
            if (sum !== expected_sum || carry !== expected_carry) begin
                $display("FAIL half_adder: a=%b b=%b expected sum=%b carry=%b got sum=%b carry=%b", a, b, expected_sum, expected_carry, sum, carry);
                $fatal(1, "tb_half_adder failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_half_adder.vcd");
        $dumpvars(0, tb_half_adder);

        check(1'b0, 1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b1, 1'b0);
        check(1'b1, 1'b0, 1'b1, 1'b0);
        check(1'b1, 1'b1, 1'b0, 1'b1);

        $display("PASS tb_half_adder");
        $finish;
    end
endmodule
