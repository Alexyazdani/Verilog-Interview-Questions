/*
Alexander Yazdani
2 December 2024
Frequency Divider (supports multiples of 0.5)
*/

module frequency_divider #(parameter MULTIPLIER = 2)(
    input clk_in,
    input reset,
    output reg clk_out
);

integer counter;

always @(posedge clk_in or negedge clk_in) begin
    if (reset) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        if (counter >= (MULTIPLIER*2)-1) begin
            counter <= 0;
            clk_out <= ~ clk_out;
        end else counter <= counter + 1;
    end
end 

endmodule

// Testbench:
module tb_frequency_divider;

    reg clk_in;
    reg reset;
    wire clk_out;

    // Instantiate the frequency divider with a fractional multiplier
    frequency_divider #(3.5) uut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Generate the input clock (50 MHz -> 20ns period)
    initial begin
        clk_in = 0;
        forever #10 clk_in = ~clk_in; // Toggle every 10ns
    end

    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        #25;
        reset = 0;

        // Run simulation for a few cycles
        #500;

        // End simulation
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | clk_in: %b | clk_out: %b | reset: %b",
                 $time, clk_in, clk_out, reset);
    end

endmodule
