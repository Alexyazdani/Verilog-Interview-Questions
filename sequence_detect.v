/*
Alexander Yazdani
2 December 2024
Sequence Detector with Serial Input
*/

module sequence_detect #(parameter [7:0] SEQUENCE = 8'b01010101)(
    input clk,
    input reset,
    input d_in,
    output match
);

reg [7:0] memory;

always @(posedge clk) begin
    if (reset) memory <= 8'b0;
    else begin
        memory <= {d_in, memory[6:0]};
    end
end

assign match = (memory == SEQUENCE);

endmodule