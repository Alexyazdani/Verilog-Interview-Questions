/*
Alex Yazdani
18 November 2024
4-to-2 Priority Encoder

Inputs:
    in (4 bits): Input signal
Outputs:
    out (2 bits): Encoded output
    valid (1 bit): Indicates if any input is valid
*/

module priority_encoder(
    input [3:0] in,
    output reg [1:0] out,
    output reg valid
);

    always @(*) begin
        valid = 1'b0; // Default to no valid input
        out = 2'b00;  // Default output value
        casez (in)
            4'b1???: begin
                valid = 1'b1;
                out = 2'b11;
            end
            4'b01??: begin
                valid = 1'b1;
                out = 2'b10;
            end
            4'b001?: begin
                valid = 1'b1;
                out = 2'b01;
            end
            4'b0001: begin
                valid = 1'b1;
                out = 2'b00;
            end
            default: begin
                valid = 1'b0;
                out = 2'b00;
            end
        endcase
    end

endmodule
