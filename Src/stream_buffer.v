/*
 * Stream buffer is a FIFO buffer that can be written to and read from simultaneously.
 */


module stream_buffer #(
    parameter PACKET_WIDTH = 157,
    parameter FIFO_DEPTH   = 1,
    parameter PTR_MSB      = 1,
    parameter ADDR_MSB     = 0
) (
    input                         clk_i,
    input                         rst_i,
    input                         flush_i,
    input                         read_i,
    input                         write_i,
    input      [PACKET_WIDTH-1:0] packet_i,
    output     [PACKET_WIDTH-1:0] packet_o,
    output reg                    full_o,
    output reg                    empty_o
);

    reg [PACKET_WIDTH-1:0] memory_r[0:FIFO_DEPTH-1];
    reg [PACKET_WIDTH-1:0] memory_w[0:FIFO_DEPTH-1];
    reg [PTR_MSB:0] read_ptr_r, write_ptr_r;
    reg [PTR_MSB:0] read_ptr_w, write_ptr_w;
    wire [ADDR_MSB:0] write_addr = write_ptr_r[ADDR_MSB:0];
    wire [ADDR_MSB:0] read_addr = read_ptr_r[ADDR_MSB:0];

    integer i;

    always @(*) begin
        write_ptr_w = write_ptr_r;
        read_ptr_w  = read_ptr_r;
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            memory_w[i] = memory_r[i];
        end
        if (write_i && ~full_o) begin
            memory_w[write_addr] = packet_i;
            write_ptr_w          = write_ptr_r + 1;
        end
        if (read_i && ~empty_o) begin
            read_ptr_w = read_ptr_r + 1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i || flush_i) begin
            for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
                memory_r[i] <= 0;
            end
            read_ptr_r  <= '0;
            write_ptr_r <= '0;
        end else begin
            for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
                memory_r[i] <= memory_w[i];
            end
            read_ptr_r  <= read_ptr_w;
            write_ptr_r <= write_ptr_w;
        end
    end

    assign packet_o = memory_r[read_addr];
    assign empty_o = (write_ptr_r == read_ptr_r) ? 1'b1 : 1'b0;
    assign full_o  = ((write_ptr_r[ADDR_MSB:0] == read_ptr_r[ADDR_MSB:0])&(write_ptr_r[PTR_MSB] != read_ptr_r[PTR_MSB])) ? 1'b1 : 1'b0;

endmodule
