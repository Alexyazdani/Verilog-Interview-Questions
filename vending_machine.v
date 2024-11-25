/*
Alex Yazdani
18 November 2024
Vending Machine Module

Inputs:
    clk
    reset
    coin
    dispense

Outputs:
    water_out
    status

States:
    IDLE
    COIN_INSERTED
    DISPENSE_WATER
    DISPENSE_COMPLETE
*/

module vending_machine(
    input clk, reset,
    input coin, dispense,
    output water_out,
    output [1:0] status
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter COIN_INSERTED = 2'b01;
    parameter DISPENSE_WATER = 2'b10;
    parameter DISPENSE_COMPLETE = 2'b11;

    // Counter Logic
    reg [2:0] counter;
    always @(posedge clk) begin
        if (reset) counter <= 3'd0;
        else if (state == DISPENSE_WATER) begin
            if (counter == 3'd4) counter <= 3'd0;
            else counter <= counter + 1;
        end else counter <= 3'd0;
    end

    // State Memory
    reg [1:0] state, next_state;
    always @(posedge clk) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:               if (coin) next_state = COIN_INSERTED;
            COIN_INSERTED:      if (dispense) next_state = DISPENSE_WATER;
            DISPENSE_WATER:     if (counter == 3'd4) next_state = DISPENSE_COMPLETE;
            DISPENSE_COMPLETE:  next_state = IDLE;
            default:            next_state = IDLE;
        endcase
    end

    // Output Function Logic
    assign water_out = (state == DISPENSE_WATER);
    assign status = state;

endmodule