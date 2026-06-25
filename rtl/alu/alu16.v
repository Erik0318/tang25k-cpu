module alu16(   //hack-style ALU. thanks to nand2tetris
    input  wire [15:0] x,
    input  wire [15:0] y,
    input  wire        zx,
    input  wire        nx,
    input  wire        zy,
    input  wire        ny,
    input  wire        f,
    input  wire        no,
    output wire [15:0] out,
    output wire        zr,
    output wire        ng
);
    wire [15:0] x1 = zx ? 16'd0 : x;
    wire [15:0] x2 = nx ? ~x1   : x1;
    wire [15:0] y1 = zy ? 16'd0 : y;
    wire [15:0] y2 = ny ? ~y1   : y1;
    wire [15:0] f0 = f ? (x2 + y2) : (x2 & y2);
    assign out = no ? ~f0 : f0;
    assign zr = (out == 16'd0);
    assign ng = out[15];
endmodule