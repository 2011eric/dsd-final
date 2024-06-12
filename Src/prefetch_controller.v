module prefetch_controller(
    // cache interface
    input clk, 
    input rst,
    input cache_mem_read,
    input [27:0] cache_mem_addr,
    output [127:0] cache_mem_rdata,
    output         cache_mem_ready,
    // memory interface
    input          mem_ready,
    input  [127:0] mem_rdata,
    output         mem_read,
    output [ 27:0] mem_addr
);

    reg mem_ready_r, mem_ready_w;
    reg mem_read_r, mem_read_w;
    reg [27:0] mem_addr_r, mem_addr_w;
    reg [127:0] mem_rdata_r, mem_rdata_w;


    localparam S_IDLE = 0, S_CACHE_FETCH = 1;
    reg [2:0] state_r, state_w;


    assign mem_read = mem_read_r;
    assign mem_addr = mem_addr_r;
    assign cache_mem_rdata = mem_rdata_r;
    assign cache_mem_ready = mem_ready_r;

    always @(*) begin: memory_signal
        //input from memory
        mem_ready_w = mem_ready;
        mem_rdata_w = mem_ready? mem_rdata : mem_rdata_r;
        // output to memory
        mem_read_w = mem_ready? 0: cache_mem_read;
        mem_addr_w = cache_mem_addr;
    end


    always @(*) begin: state_logic
        state_w = state_r;
        mem_ready_w = mem_ready_r;
        mem_rdata_w = mem_rdata_r;
        mem_read_w = mem_read_r;
        case(state_r) 
            S_IDLE: begin
                mem_ready_w = 0; // clear ready signal
                if (cache_mem_read) begin
                    state_w = S_CACHE_FETCH;
                    mem_read_w = 1;
                end
            end
            S_CACHE_FETCH: begin
                if (mem_ready) begin
                    state_w = S_IDLE;
                    mem_ready_w = 1;
                    mem_read_w = 0; // remember to pull down mem_read
                    mem_rdata_w = mem_rdata;
                end else begin
                    mem_ready_w = 0;
                    mem_read_w = 1;
                end
            end
        endcase

    end
    always @(posedge clk) begin
        if (rst) begin
            mem_ready_r <= 1'b0;
            mem_read_r <= 1'b0;
            mem_addr_r <= 28'b0;
            mem_rdata_r <= 128'b0;
            state_r <= S_IDLE;
        end else begin
            mem_ready_r <= mem_ready_w;
            mem_read_r <= mem_read_w;
            mem_addr_r <= mem_addr_w;
            mem_rdata_r <= mem_rdata_w;
            state_r     <= state_w;
        end
    end
endmodule
