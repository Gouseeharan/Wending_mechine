module vending_machine_short (
    input clk,
    input reset,
    input [2:0] coin_in,       // Coin input: 0-5
    input [1:0] item_select,   // 01=₹1, 10=₹2, 11=₹3
    output reg vend,           // 1 when vending occurs
    output reg [2:0] change,   // Change returned
    output reg [1:0] item_dispensed
);

    reg [2:0] total;           // Total coins inserted
    reg [2:0] price;

    // Set item price
    always @(*) begin
        case(item_select)
            2'b01: price = 3'd1;
            2'b10: price = 3'd2;
            2'b11: price = 3'd3;
            default: price = 3'd0;
        endcase
    end

    // Update total coins
    always @(posedge clk or posedge reset) begin
        if (reset)
            total <= 3'd0;
        else if (vend)
            total <= 3'd0;
        else if (total + coin_in <= 3'd5)
            total <= total + coin_in;
    end

    // Vend output logic
    always @(*) begin
        vend = 0;
        change = 0;
        item_dispensed = 2'b00;

        if (price != 0 && total >= price) begin
            vend = 1;
            item_dispensed = item_select;
            change = total - price;
        end
    end

endmodule
