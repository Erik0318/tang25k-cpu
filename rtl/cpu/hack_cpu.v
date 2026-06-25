module hack_cpu(
    input  wire        clk,
    input  wire        reset,

    input  wire [15:0] instruction,
    input  wire [15:0] inM,

    output wire [15:0] outM,
    output wire        writeM,
    output wire [14:0] addressM,
    output wire [14:0] pc
);

    // Hack instruction types
    wire is_a = ~instruction[15];  // 0vvvvvvvvvvvvvvv
    wire is_c =  instruction[15];  // 111accccccdddjjj

    // Registers
    wire [15:0] a_out;
    wire [15:0] d_out;

    // C-instruction layout:
    // 111 a cccccc ddd jjj
    wire a_bit = instruction[12];

    wire zx = instruction[11];
    wire nx = instruction[10];
    wire zy = instruction[9];
    wire ny = instruction[8];
    wire f  = instruction[7];
    wire no = instruction[6];

    // Destination bits: ddd = A D M
    wire dest_a = instruction[5];
    wire dest_d = instruction[4];
    wire dest_m = instruction[3];

    // Jump bits: jjj = JLT JEQ JGT in bit positions 2,1,0
    wire jump_jlt = instruction[2];
    wire jump_jeq = instruction[1];
    wire jump_jgt = instruction[0];

    // ALU
    wire [15:0] alu_y = a_bit ? inM : a_out;
    wire [15:0] alu_out;
    wire zr;
    wire ng;

    alu16 alu(
        .x(d_out),
        .y(alu_y),
        .zx(zx),
        .nx(nx),
        .zy(zy),
        .ny(ny),
        .f(f),
        .no(no),
        .out(alu_out),
        .zr(zr),
        .ng(ng)
    );

    // A register:
    // A-instruction loads the 15-bit value into A.
    // C-instruction loads ALU output into A only if dest A is set.
    wire [15:0] a_in = is_a ? {1'b0, instruction[14:0]} : alu_out;
    wire load_a = is_a | (is_c & dest_a);

    reg16 a_reg(
        .clk(clk),
        .reset(reset),
        .load(load_a),
        .in(a_in),
        .out(a_out)
    );

    // D register:
    // C-instruction loads ALU output into D only if dest D is set.
    wire load_d = is_c & dest_d;

    reg16 d_reg(
        .clk(clk),
        .reset(reset),
        .load(load_d),
        .in(alu_out),
        .out(d_out)
    );

    // Memory interface:
    // The CPU does not contain RAM.
    // It only tells the outside memory system what to write and where.
    assign outM = alu_out;
    assign writeM = is_c & dest_m;
    assign addressM = a_out[14:0];

    // Jump logic
    wire positive = ~zr & ~ng;

    wire should_jump =
        is_c & (
            (jump_jlt & ng) |
            (jump_jeq & zr) |
            (jump_jgt & positive)
        );

    // Program counter
    wire [15:0] pc_out;

    pc16 pc_reg(
        .clk(clk),
        .reset(reset),
        .load(should_jump),
        .inc(~should_jump),
        .in(a_out),
        .out(pc_out)
    );

    assign pc = pc_out[14:0];

endmodule