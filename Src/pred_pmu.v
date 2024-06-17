module pred_pmu (
    input         clk,
    input         rst_n,
    input         ID_EX_branch,
    input         EX_feedback_valid,
    input         EX_prediction_incorrect,
    input         is_jal,
    output [31:0] prediction_cnt,
    output [31:0] prediction_wrong_cnt,
    output [31:0] jal_cnt,
    output [31:0] jal_wrong_cnt
);

    reg [31:0] prediction_cnt_r, prediction_cnt_w;
    reg [31:0] prediction_wrong_cnt_r, prediction_wrong_cnt_w;

    reg [31:0] jal_cnt_r, jal_cnt_w;
    reg [31:0] jalr_wrong_cnt_r, jalr_wrong_cnt_w;

    assign prediction_cnt = prediction_cnt_r;
    assign prediction_wrong_cnt = prediction_wrong_cnt_r;

    assign jal_cnt = jal_cnt_r;
    assign jal_wrong_cnt = jalr_wrong_cnt_r;

    wire br_valid;
    assign br_valid = ID_EX_branch & EX_feedback_valid;

    wire jal_valid;
    assign jal_valid = is_jal & EX_feedback_valid;

    always @(*) begin
        prediction_cnt_w = br_valid ? prediction_cnt_r + 1 : prediction_cnt_r;
        prediction_wrong_cnt_w =(br_valid && EX_prediction_incorrect) ? prediction_wrong_cnt_r + 1 : prediction_wrong_cnt_r;
        jal_cnt_w = jal_valid ? jal_cnt_r + 1 : jal_cnt_r;
        jalr_wrong_cnt_w = (jal_valid && EX_prediction_incorrect) ? jalr_wrong_cnt_r + 1 : jalr_wrong_cnt_r;
    end
    always @(posedge clk) begin
        if (!rst_n) begin
            prediction_cnt_r <= 0;
            prediction_wrong_cnt_r <= 0;
            jal_cnt_r <= 0;
            jalr_wrong_cnt_r <= 0;
        end else begin
            prediction_cnt_r <= prediction_cnt_w;
            prediction_wrong_cnt_r <= prediction_wrong_cnt_w;
            jal_cnt_r <= jal_cnt_w;
            jalr_wrong_cnt_r <= jalr_wrong_cnt_w;

        end
    end

endmodule
