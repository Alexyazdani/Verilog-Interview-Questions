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


module fifo_async_1 #(
    parameter DATA_WIDTH = 8  // Width of the data stored in the FIFO
)(
    input write_clk,          // Write clock
    input read_clk,           // Read clock
    input reset,              // Reset signal
    input write_en,           // Write enable
    input read_en,            // Read enable
    input [DATA_WIDTH-1:0] d_in, // Data input
    output reg [DATA_WIDTH-1:0] d_out, // Data output
    output full,              // Full flag
    output empty              // Empty flag
);

    // Internal register to hold the data
    reg [DATA_WIDTH-1:0] memory;
    reg fifo_full;            // Internal full flag
    reg fifo_empty;           // Internal empty flag

    // Synchronization registers for flags
    reg fifo_full_sync1, fifo_full_sync2;   // Sync full flag to read clock
    reg fifo_empty_sync1, fifo_empty_sync2; // Sync empty flag to write clock

    // Full and empty assignments
    assign full = fifo_full;
    assign empty = fifo_empty;

    // Write logic (write clock domain)
    always @(posedge write_clk or posedge reset) begin
        if (reset) begin
            fifo_full <= 0;
        end else if (write_en && !fifo_full) begin
            memory <= d_in;       // Store data
            fifo_full <= 1;       // Mark as full
            fifo_empty <= 0;      // Not empty anymore
        end
    end

    // Read logic (read clock domain)
    always @(posedge read_clk or posedge reset) begin
        if (reset) begin
            fifo_empty <= 1;
            d_out <= 0;
        end else if (read_en && !fifo_empty) begin
            d_out <= memory;      // Output data
            fifo_empty <= 1;      // Mark as empty
            fifo_full <= 0;       // Not full anymore
        end
    end

    // Synchronize full flag to read clock domain
    always @(posedge read_clk or posedge reset) begin
        if (reset) begin
            fifo_full_sync1 <= 0;
            fifo_full_sync2 <= 0;
        end else begin
            fifo_full_sync1 <= fifo_full;
            fifo_full_sync2 <= fifo_full_sync1; // Second stage sync
        end
    end

    // Synchronize empty flag to write clock domain
    always @(posedge write_clk or posedge reset) begin
        if (reset) begin
            fifo_empty_sync1 <= 1;
            fifo_empty_sync2 <= 1;
        end else begin
            fifo_empty_sync1 <= fifo_empty;
            fifo_empty_sync2 <= fifo_empty_sync1; // Second stage sync
        end
    end

endmodule
