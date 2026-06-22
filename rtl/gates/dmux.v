module dmux (
    input a,
    input sel,
    output y0,
    output y1
);
    assign y0 = ~sel & a;
    assign y1 = sel & a;
endmodule