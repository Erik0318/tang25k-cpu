module pc16 (
    input clk,
    input reset,
    input load,
    input inc,
    input [15:0] in,
    output reg [15:0] out 
);
    always @(posedge clk) begin
        if (reset)
            out <= 16'd0;
        else if (load)
            out <= in;
        else if (inc)
            out <= out + 16'd1;
    end
endmodule