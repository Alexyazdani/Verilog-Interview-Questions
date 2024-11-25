/*
Alex Yazdani
18 November 2024
Elevator Controller Module

Inputs:
    clk
    reset
    req_floor (3 bits: floor request)

Outputs:
    current_floor (3 bits: current floor)
    moving (1 bit: elevator moving indicator)

States:
    IDLE
    MOVING_UP
    MOVING_DOWN
    ARRIVED
*/

module elevator_controller(
    input clk, reset,
    input [2:0] req_floor,
    output reg [2:0] current_floor,
    output reg moving
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter MOVING_UP = 2'b01;
    parameter MOVING_DOWN = 2'b10;
    parameter ARRIVED = 2'b11;

    reg [1:0] state, next_state;

    // State Memory
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next State Logic (NSL)
    always @(*) begin
        next_state = state; // Default to prevent latches
        case (state)
            IDLE: begin
                if (req_floor > current_floor)
                    next_state = MOVING_UP;
                else if (req_floor < current_floor)
                    next_state = MOVING_DOWN;
            end
            MOVING_UP: begin
                if (current_floor == req_floor)
                    next_state = ARRIVED;
            end
            MOVING_DOWN: begin
                if (current_floor == req_floor)
                    next_state = ARRIVED;
            end
            ARRIVED: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output and Floor Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_floor <= 3'd0; // Reset to ground floor
            moving <= 1'b0;
        end else begin
            case (state)
                MOVING_UP: begin
                    current_floor <= current_floor + 1;
                    moving <= 1'b1;
                end
                MOVING_DOWN: begin
                    current_floor <= current_floor - 1;
                    moving <= 1'b1;
                end
                ARRIVED: moving <= 1'b0;
                default: moving <= 1'b0;
            endcase
        end
    end

endmodule
