/*
Alex Yazdani
18 November 2024
Water Fountain Controller

Inputs:
    clk: Clock signal
    reset: Active-high reset signal
    button: Button press signal (1 bit)

Outputs:
    water_flow: Water flow control (1 bit, 1 = Flowing)
*/

module water_fountain(
    input clk, reset,
    input button,
    output reg water_flow
);

    // State Encoding
    parameter OFF = 1'b0;
    parameter ON = 1'b1;

    reg state, next_state;

    // State Memory
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next State Logic (NSL)
    always @(*) begin
        case (state)
            OFF: next_state = button ? ON : OFF; // Turn on if button is pressed
            ON:  next_state = button ? ON : OFF; // Turn off if button is released
            default: next_state = OFF;
        endcase
    end

    // Output Logic (OFL)
    always @(*) begin
        case (state)
            OFF: water_flow = 1'b0; // No water flow in OFF state
            ON:  water_flow = button; // Water flow depends on button in ON state
            default: water_flow = 1'b0;
        endcase
    end

endmodule
