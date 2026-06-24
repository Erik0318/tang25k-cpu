`timescale 1ns/1ps

module tb_full_adder;
    reg a;
    reg b;
    reg cin;
    wire sum;
    wire cout;

    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    task check;
        input aa;
        input bb;
        input ccin;
        input expected_sum;
        input expected_cout;
        begin
            a = aa;
            b = bb;
            cin = ccin;
            #1;
            if (sum !== expected_sum || cout !== expected_cout) begin
                $display("FAIL full_adder: a=%b b=%b cin=%b expected sum=%b cout=%b got sum=%b cout=%b", a, b, cin, expected_sum, expected_cout, sum, cout);
                $fatal(1, "tb_full_adder failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        check(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        check(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        check(1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        check(1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
        check(1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        check(1'b1, 1'b1, 1'b1, 1'b1, 1'b1);

        $display("PASS tb_full_adder");
        $finish;
    end
endmodule
