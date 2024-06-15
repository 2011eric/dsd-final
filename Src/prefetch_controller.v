module prefetch_controller(
    // cache interface
    input clk, 
    input rst,
    input cache_mem_read,
    input [27:0] cache_mem_addr,
    output  [127:0] cache_mem_rdata,
    output      cache_mem_ready,
    // memory interface
    input          mem_ready,
    input  [127:0] mem_rdata,
    output         mem_read,
    output [ 27:0] mem_addr
    // buffer interface
// `ifdef PREFETCH
//     ,
//     input          buf_empty,
//     input          buf_full,
//     input  [27:0]  buf_addr,
//     output [PACKET_WIDTH-1:0] buf_rdata,
//     output         buf_flush,
//     output         buf_read,
//     output         buf_write,
//     output [PACKET_WIDTH-1:0]  buf_waddr,
// `endif
);
    
    
    localparam S_IDLE = 0, S_CACHE_FETCH = 1, S_READY = 2;
    localparam S_BUF_FETCH = 3;
    reg [2:0] state_r, state_w;
    
    
    reg         mem_read_r, mem_read_w;
    reg [27:0]  mem_addr_r, mem_addr_w;
    
    wire        buf_hit;
    reg         prefetch_r, prefetch_w;
    reg [27:0]  buf_addr_r, buf_addr_w;
    reg [127:0] buf_data_r, buf_data_w;
    reg         buf_valid_r, buf_valid_w;

    reg         cache_mem_ready_r, cache_mem_ready_w;
    reg [127:0] cache_mem_rdata_r, cache_mem_rdata_w;

    wire [27:0] next_addr;

    assign mem_read = mem_read_r;
    assign mem_addr = mem_addr_r;
    assign buf_hit = (cache_mem_addr == buf_addr_r);
    assign next_addr = cache_mem_addr + 1;
    assign cache_mem_rdata = cache_mem_rdata_r;
    assign cache_mem_ready = cache_mem_ready_r;

    always @(*) begin: state_logic
        state_w = state_r;
        mem_read_w = mem_read_r;
        mem_addr_w = mem_addr_r;
        prefetch_w = prefetch_r;
        buf_addr_w = buf_addr_r;
        buf_data_w = buf_data_r;
        buf_valid_w = buf_valid_r;

        cache_mem_ready_w = 0;
        cache_mem_rdata_w = 0;
        
        case(state_r) 
            S_IDLE: begin
                if (cache_mem_read) begin
                // here we encounter cache read miss
                    prefetch_w = 1; // prefetch after read miss, no matter buf hit or not
                    buf_addr_w = next_addr; // store prefetch addr to buf
                    if (buf_hit && buf_valid_r) begin
                        cache_mem_ready_w = 1;
                        cache_mem_rdata_w = buf_data_r;
                        state_w = S_IDLE;
                        mem_read_w = 0;
                        buf_valid_w = 0;
                    end else begin
                        // buf miss, read from slow memory
                        cache_mem_ready_w = 0;
                        buf_valid_w = 0; // flush buf
                        mem_addr_w = cache_mem_addr;
                        state_w = S_CACHE_FETCH; // handle read miss first
                        mem_read_w = 1;
                    end
                end else if(prefetch_r) begin
                    // start prefetching
                    cache_mem_ready_w = 0;
                    mem_addr_w = buf_addr_r;
                    state_w = S_BUF_FETCH;
                    mem_read_w = 1;
                end else begin

                end
            end
            S_CACHE_FETCH: begin 
                if (mem_ready) begin
                    state_w = S_READY;
                    cache_mem_ready_w = 1;
                    cache_mem_rdata_w = mem_rdata;
                    mem_read_w = 0; // remember to pull down mem_read
                end else begin
                    mem_read_w = 1;
                end
            end
            S_BUF_FETCH: begin
                if (mem_ready) begin
                    state_w = S_IDLE;
                    mem_read_w = 0; // remember to pull down mem_read
                    buf_data_w = mem_rdata;
                    prefetch_w = 0;
                    buf_valid_w = 1;
                end else begin
                    mem_read_w = 1;
                end
            end
            S_READY: begin
                state_w = S_IDLE;
                cache_mem_ready_w = 0;
                mem_read_w = 0;
            end
        endcase

    end
    always @(posedge clk) begin
        if (rst) begin
            mem_read_r <= 1'b0;
            mem_addr_r <= 28'b0;
            state_r <= S_IDLE;
            prefetch_r <= 0;
            buf_addr_r <= 0;
            buf_data_r <= 0;
            buf_valid_r <= 0;
            cache_mem_ready_r <= 0;
            cache_mem_rdata_r <= 0;
        end else begin
            mem_read_r <= mem_read_w;
            mem_addr_r <= mem_addr_w;
            state_r     <= state_w;
            prefetch_r <= prefetch_w;
            buf_addr_r <= buf_addr_w;
            buf_data_r <= buf_data_w;
            buf_valid_r <= buf_valid_w;
            cache_mem_ready_r <= cache_mem_ready_w;
            cache_mem_rdata_r <= cache_mem_rdata_w;
        end
    end
endmodule
