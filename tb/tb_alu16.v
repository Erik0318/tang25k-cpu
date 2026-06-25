`timescale 1ns/1ps

module tb_alu16;
    reg [15:0] x;
    reg [15:0] y;
    reg zx;
    reg nx;
    reg zy;
    reg ny;
    reg f;
    reg no;

    wire [15:0] out;
    wire zr;
    wire ng;

    alu16 dut (
        .x(x),
        .y(y),
        .zx(zx),
        .nx(nx),
        .zy(zy),
        .ny(ny),
        .f(f),
        .no(no),
        .out(out),
        .zr(zr),
        .ng(ng)
    );

    task check;
        input [15:0] xx;
        input [15:0] yy;
        input zzx;
        input nnx;
        input zzy;
        input nny;
        input ff;
        input nno;
        input [15:0] expected;
        begin
            x = xx;
            y = yy;
            zx = zzx;
            nx = nnx;
            zy = zzy;
            ny = nny;
            f  = ff;
            no = nno;
            #1;

            if (out !== expected || zr !== (expected == 16'd0) || ng !== expected[15]) begin
                $display("FAIL alu16: x=%h y=%h zx=%b nx=%b zy=%b ny=%b f=%b no=%b expected out=%h zr=%b ng=%b got out=%h zr=%b ng=%b",
                         x, y, zx, nx, zy, ny, f, no,
                         expected, (expected == 16'd0), expected[15], out, zr, ng);
                $fatal(1, "tb_alu16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_alu16.vcd");
        $dumpvars(0, tb_alu16);

        // Main Hack ALU function table, using x=0x1234 and y=0x00ff.
        check(16'h1234, 16'h00ff, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 16'h0000); // 0
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0001); // 1
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 16'hffff); // -1
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 16'h1234); // x
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 16'h00ff); // y
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 16'hedcb); // !x
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 16'hff00); // !y
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 16'hedcc); // -x
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 16'hff01); // -y
        check(16'h1234, 16'h00ff, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 16'h1235); // x+1
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 16'h0100); // y+1
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 16'h1233); // x-1
        check(16'h1234, 16'h00ff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 16'h00fe); // y-1
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 16'h1333); // x+y
        check(16'h1234, 16'h00ff, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 16'h1135); // x-y
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 16'heecb); // y-x
        check(16'h1234, 16'h00ff, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 16'h0034); // x&y
        check(16'h1234, 16'h00ff, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 16'h12ff); // x|y

        // Extra flag checks.
        check(16'h8000, 16'h0000, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 16'h8000); // ng=1
        check(16'h0001, 16'h0001, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 16'h0000); // x-y=0, zr=1
        check(16'hffff, 16'h0001, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 16'h0000); // overflow wraps, zr=1

        $display("PASS tb_alu16");
        $finish;
    end
endmodule
