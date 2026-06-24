module ram16 #(parameter ADDR_WIDTH = 12)(
    //its not 16 lol
    input  clk,
    input  we,
    input  [ADDR_WIDTH-1:0] addr,
    input  [15:0] din,
    output reg  [15:0] dout
);
    reg [15:0] mem [0:(1<<ADDR_WIDTH)-1];
    //about 8kB of memory, 2^12 = 4096 words, 4096*16 bits = 65536 bits = 8kB
 
    always @(posedge clk) begin
        /*read-first stuff so dout sometimes gets the old value of 
        mem[addr] before it is updated cuz verilog tends to read all 
        right-side values FIRST and then update all left-side values 
        together in non-blocking assignments*/
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule