module branch_predictor(
    input clk,
    input rst_n,
    input [31:0] branch_pc, // BTB will use branch_pc to index the saturation counter
    input prediction_correct,
    input [31: 0] correct_destination,
    input feedback_valid,//if the instruction in EX is not a branch, or if it is stalling, 
    //the saturation counter should not take this feedback
    output take_branch,
    output [31: 0] predicted_destination
);

`ifndef USE_BTB
    saturation_counter u_saturation_counter (
        .clk                   (clk),
        .rst_n                 (rst_n),
        .prediction_correct    (prediction_correct),
        .feedback_valid        (feedback_valid),
        .take_branch           (take_branch)
    );
    assign predicted_destination = 0;
`else
    parameter BTB_SIZE = 4;
    BHT u_bhb (
        .clk                    (clk),
        .rst_n                  (rst_n),
        .branch_pc_i            (branch_pc),
        .prediction_correct_i   (prediction_correct),
        .feedback_valid_i       (feedback_valid),
        .take_branch_o          (take_branch)
    );
    BTB u_btb (

    );
`endif
endmodule