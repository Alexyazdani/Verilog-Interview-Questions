/*
Alex Yazdani
18 November 2024
Traffic Controller Module
*/

module traffic_controller(
    input clk, reset, ped_req,
    output [1:0] veh_light,
    output ped_light
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter GREEN = 2'b01;
    parameter YELLOW = 2'b10;
    parameter RED = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] counter;

    // Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset) counter <= 0;
        else if (counter == 4'd9 && state == GREEN) counter <= 0;
        else if (counter == 4'd4 && state == YELLOW) counter <= 0;
        else if ((counter == 4'd9 && !ped_req) || (counter > 4'd9)) counter <= 0;
        else if (state != next_state) counter <= 0;
        else counter <= counter + 1;
    end

    // State Memory
    always @(posedge clk or posedge reset) begin
        if (reset) state <= IDLE;
        else state <= next_state;
    end

    // Next State Logic (NSL)
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:       next_state = GREEN;
            GREEN:      if (counter == 4'd9) next_state = YELLOW;
            YELLOW:     if (counter == 4'd4) next_state = RED;
            RED:        if (((counter == 4'd9) && !ped_req) || (counter > 4'd9)) next_state = GREEN;
            default:    next_state = IDLE;
        endcase
    end

    // Output Logic (OFL)
    assign veh_light = state;
    assign ped_light = (state == RED);

endmodule
