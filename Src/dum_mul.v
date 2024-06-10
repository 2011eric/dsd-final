//simulates a 2-stage pipelined multiplier
module dum_mul (
    input clk,
    input rst_n,
    input stall,//should support stalling
    input [31: 0] opA,
    input [31: 0] opB,
    output [31: 0] result
);
    reg [31: 0] a_stage1_r, b_stage1_r, a_stage1_w, b_stage1_w;
    assign result = a_stage1_r * b_stage1_r;
    always @(*) begin
        a_stage1_w = stall? a_stage1_r: opA;
        b_stage1_w = stall? b_stage1_r: opB;
    end


    always @(posedge clk) begin
        if(!rst_n) begin
            a_stage1_r <= 0;
            b_stage1_r <= 0;
        end
        else begin
            a_stage1_r <= a_stage1_w;
            b_stage1_r <= b_stage1_w;
        end
    end

endmodule