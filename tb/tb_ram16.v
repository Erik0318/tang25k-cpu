`timescale 1ns/1ps

module tb_ram16;
    reg clk;
    reg we;
    reg [3:0] addr;
    reg [15:0] din;
    wire [15:0] dout;

    ram16 #(
        .ADDR_WIDTH(4)
    ) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    always #5 clk = ~clk;

    task step;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task expect_dout;
        input [15:0] expected;
        begin
            if (dout !== expected) begin
                $display("FAIL ram16: addr=%h expected dout=%h got=%h", addr, expected, dout);
                $fatal(1, "tb_ram16 failed");
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_ram16.vcd");
        $dumpvars(0, tb_ram16);

        clk = 1'b0;
        we = 1'b0;
        addr = 4'h0;
        din = 16'h0000;

        // Write address 3. dout is not checked here because old memory is uninitialized.
        we = 1'b1;
        addr = 4'h3;
        din = 16'ha5a5;
        step();

        // Synchronous read: selected data appears after a clock edge.
        we = 1'b0;
        addr = 4'h3;
        din = 16'h0000;
        step();
        expect_dout(16'ha5a5);

        // This RAM is read-first. Writing and reading the same address returns the old value on dout.
        we = 1'b1;
        addr = 4'h3;
        din = 16'h1234;
        step();
        expect_dout(16'ha5a5);

        // The newly written value appears on the next read clock.
        we = 1'b0;
        addr = 4'h3;
        step();
        expect_dout(16'h1234);

        // Check another address too.
        we = 1'b1;
        addr = 4'h4;
        din = 16'hbeef;
        step();

        we = 1'b0;
        addr = 4'h4;
        step();
        expect_dout(16'hbeef);

        $display("PASS tb_ram16");
        $finish;
    end
endmodule
