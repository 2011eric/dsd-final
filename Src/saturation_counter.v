//2-bit saturation counter
//under development by Hans Gao
module saturation_counter(
    input clk,
    input rst_n,
    input prediction_correct,
    output take_branch
);
    reg [1: 0] satcnt_r, satcnt_w;

    assign take_branch = satcnt_r[1];
    //the first two stages predicts branch not taken
    //while the last two predicts branch taken

    always @(*) begin
        //default 
        satcnt_w = 0;
        case(satcnt_r)
        2'b00: satcnt_w = (prediction_correct)? 2'b00: 2'b01;
        2'b01: satcnt_w = (prediction_correct)? 2'b00: 2'b10;
        2'b10: satcnt_w = (prediction_correct)? 2'b11: 2'b01;
        2'b11: satcnt_w = (prediction_correct)? 2'b11: 2'b10;
        endcase
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            satcnt_r <= 2'b00;
        end
        else begin
            satcnt_r <= satcnt_w;
        end
    end
endmodule
