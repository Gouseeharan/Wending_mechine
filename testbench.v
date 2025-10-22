`timescale 1ns / 1ps

module tb_vending_machine_short;

    reg clk = 0, reset = 1;
    reg [2:0] coin_in = 0;
    reg [1:0] item_select = 0;

    wire vend;
    wire [2:0] change;
    wire [2:0] total;  // optional to monitor
    wire [2:0] total_wire;
    wire [1:0] item_dispensed;

    // Instantiate DUT
    vending_machine_short dut (
        .clk(clk),
        .reset(reset),
        .coin_in(coin_in),
        .item_select(item_select),
        .vend(vend),
        .change(change),
        .item_dispensed(item_dispensed)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Release reset
        #10 reset = 0;

        // Test case 1: Insert ₹2 + ₹1, buy ₹2 chocolate
        #10 coin_in = 3'd2; #10 coin_in = 0;
        #10 coin_in = 3'd1; #10 coin_in = 0;
        #10 item_select = 2'b10; #10 item_select = 0;

        // Test case 2: Insert ₹3 + ₹1, buy ₹3 chocolate
        #20 coin_in = 3'd3; #10 coin_in = 0;
        #10 coin_in = 3'd1; #10 coin_in = 0;
        #10 item_select = 2'b11; #10 item_select = 0;

        // Test case 3: Over-insert ₹4 + ₹2 → ignored
        #20 coin_in = 3'd4; #10 coin_in = 0;
        #10 coin_in = 3'd2; #10 coin_in = 0;
        #10 item_select = 2'b01; #10 item_select = 0;

        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time | Coin | Item | Vend | Change | Dispensed | Total");
        $monitor("%4t |  %d   |  %b  |  %b   |   %d    |    %b     |   %d",
                 $time, coin_in, item_select, vend, change, item_dispensed, dut.total);
    end

endmodule
