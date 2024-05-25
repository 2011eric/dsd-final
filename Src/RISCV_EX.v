//under development by Gao HengSiang

module EX_STAGE #(
    parameter BIT_W = 32
    )(
    input clk,
    input rst_n,
    //PIPELINE INPUT FROM ID/EX REGISTER
    input [BIT_W-1: 0] PC_in,
    input [BIT_W-1: 0] rs1_dat_in,
    input [BIT_W-1: 0] rs2_dat_in,
    input [BIT_W-1: 0] imm,
        //various control signals input
    input alusrc_in,
    input [3: 0] aluctrl_in,
    input jal_in,

    //transparent for this stage
    input [4: 0] rd_in,
    input memrd_in,
    input memwr_in,
    input mem2reg_in,
    input regwr_in,


    //PIPELINE OUTPUT TO EX/MEM REGISTER
    output [BIT_W-1: 0] alu_result,
    output [BIT_W-1: 0] second_opr,
    output [4: 0] rd_out,
    output [BIT_W-1: 0] nx_PC,
        //various control signals output
    output memrd_out,
    output memwr_out,
    output mem2reg_out,
    output regwr_out
    //INPUT FROM STANDALONE MODULES SUCH AS FORWARDING, HAZARD_DETECTION
    //maybe no need because forwarding is already done in ID stage
);
    //Reg and Wire declaration
    reg [BIT_W-1: 0] alu_result_r, alu_result_w;
    reg [BIT_W-1: 0] second_opr_r, second_opr_w;
    reg [4: 0] rd_out_r, rd_out_w;
    reg memrd_out_r, memwr_out_r, mem2reg_out_r, regwr_out_r;
    reg [BIT_W-1: 0] alu_opA, alu_opB;
    //Continuous assignments
    assign nx_PC = PC_in + 4;
    
    //module instantiation
    ALU #(.BIT_W(BIT_W)) alu_inst(
        .aluctrl(aluctrl_in),
        .opA(alu_opA),
        .opB(alu_opB),
        .out(alu_result_w)
    );
    //Combinational
    always @(*) begin
        alu_opA = jal_in? PC_in: rs1_dat_in;
        alu_opB = alusrc_in? imm: rs2_dat_in;
    end
    //Sequential
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            alu_result_r    <= 0;
            second_opr_r    <= 0;
            rd_out_r        <= 0;
            memrd_out_r     <= 0;
            memwr_out_r     <= 0;
            mem2reg_out_r   <= 0;
            regwr_out_r     <= 0;
        end
        else begin
            alu_result_r    <= alu_result_w;
            second_opr_r    <= rs2_dat_in;
            rd_out_r        <= rd_in;
            memrd_out_r     <= memrd_in;
            memwr_out_r     <= memwr_in;
            mem2reg_out_r   <= mem2reg_in;
            regwr_out_r     <= regwr_in;
        end
    end
endmodule