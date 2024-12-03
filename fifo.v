/*
Alexander Yazdani
2 December 2024
Synchronous and Asynchronous FIFO Implementations
*/


// Synchronous Parameterized FIFO
module fifo_synch #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [DATA_WIDTH-1:0] d_in,
    output reg [DATA_WIDTH-1:0] d_out,
    output full,
    output empty
);

reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
reg [$clog2(DEPTH)-1:0] write_ptr;
reg [$clog2(DEPTH)-1:0] read_ptr;
reg [$clog2(DEPTH):0] count;


always @(posedge clk) begin
    if (reset) begin
        write_ptr <= 0;
        read_ptr <= 0;
        d_out <= 0;
        count <= 0;
    end else begin
        if (write_en && !full) begin
            memory[write_ptr] <= d_in;
            write_ptr <= (write_ptr + 1) % DEPTH;
            count <= count + 1;
        end else if (read_en && !empty) begin
            d_out <= memory[read_ptr];
            read_ptr <= (read_ptr + 1) % DEPTH;
            count <= count - 1;
        end
    end
end

assign full = (count == DEPTH);
assign empty = (count == 0);

endmodule


// Synchronous FIFO of Depth 1
module fifo_synch_1 #(parameter DATA_WIDTH = 8) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] d_in,
    input read_en,
    input write_en,
    output reg [DATA_WIDTH-1:0] d_out,
    output full,
    output empty
);

reg [DATA_WIDTH-1:0] memory;
reg counter;

always @(posedge clk) begin
    if (reset) begin
        d_out <= 0;
        memory <= 0;
        counter <= 0;
    end else begin
        if (write_en && !full) begin
            memory <= d_in;
            counter <= 1;
        end else if (read_en && !empty) begin
            d_out <= memory;
            counter <= 0;
        end
    end
end

assign full = counter;
assign empty = !counter;

endmodule