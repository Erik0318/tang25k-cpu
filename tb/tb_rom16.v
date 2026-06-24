`timescale 1ns/1ps

module tb_rom16;
    reg [3:0] addr;
    wire [15:0] data;

    rom16 #(
        .ADDR_WIDTH(4),
        .INIT_FILE("tb/rom16_test.hex")
    ) dut (
        .addr(addr),
        .data(data)
    );

    task check;
        input [3:0] aaddr;
        input [15:0] expected;
        begin
            addr = aaddr;
            #1;
            if (data !== expected) begin
                $display("FAIL rom16: addr=%h expected data=%h got=%h", addr, expected, data);
                $fatal(1, "tb_rom16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_rom16.vcd");
        $dumpvars(0, tb_rom16);

        check(4'h0, 16'h1234);
        check(4'h1, 16'habcd);
        check(4'h2, 16'h0000);
        check(4'h3, 16'hffff);
        check(4'h4, 16'h00ff);
        check(4'hf, 16'hdead);

        $display("PASS tb_rom16");
        $finish;
    end
endmodule
