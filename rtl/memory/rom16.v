module rom16 #(parameter ADDR_WIDTH = 12, parameter INIT_FILE = "program.hex")(
    input  [ADDR_WIDTH-1:0] addr,
    output [15:0] data
);
    reg [15:0] mem [0:(1<<ADDR_WIDTH)-1];
 
    initial begin
        $readmemh(INIT_FILE, mem);
    end
 
    assign data = mem[addr];
endmodule