`timescale 1ns/1ps

module tb_dmux;
    reg a;
    reg sel;
    wire y0;
    wire y1;

    dmux dut (
        .a(a),
        .sel(sel),
        .y0(y0),
        .y1(y1)
    );

    task check;
        input aa;
        input ssel;
        input expected_y0;
        input expected_y1;
        begin
            a = aa;
            sel = ssel;
            #1;
            if (y0 !== expected_y0 || y1 !== expected_y1) begin
                $display("FAIL dmux: a=%b sel=%b expected y0=%b y1=%b got y0=%b y1=%b", a, sel, expected_y0, expected_y1, y0, y1);
                $fatal(1, "tb_dmux failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_dmux.vcd");
        $dumpvars(0, tb_dmux);

        check(1'b0, 1'b0, 1'b0, 1'b0);
        check(1'b0, 1'b1, 1'b0, 1'b0);
        check(1'b1, 1'b0, 1'b1, 1'b0);
        check(1'b1, 1'b1, 1'b0, 1'b1);

        $display("PASS tb_dmux");
        $finish;
    end
endmodule
