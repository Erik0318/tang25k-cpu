module reg16 (
    input clk,
    input reset,
    input load,
    input [15:0] in,
    output reg [15:0] out
);
    always @(posedge clk) begin
        if (reset)
            out <= 16'd0;
        else if (load)
            out <= in;
    end
endmodule