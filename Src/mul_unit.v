module mul_unit (
    a,
    b,
    out
);

    input [31:0] a;
    input [31:0] b;
    output [31:0] out;
    wire [7:0] am1, am2, am3, am4, am5, am6, am7, am8;
    wire [31:0] addtemp1, addtemp2, addtemp3, addtemp4, addtemp5;
    wire [31:0] l1, l2, l3, l4, l5, l6, l7, l8, l9, l10;
    wire [15:0] li1, li2, li3, li4, li5, li6, li7, li8, li9, li10;
    wire [31:0] w1, w2, w3;
    assign am1[7:0] = a[7:0];
    assign am2[7:0] = a[15:8];
    assign am3[7:0] = a[23:16];
    assign am4[7:0] = a[31:24];

    assign am5[7:0] = b[7:0];
    assign am6[7:0] = b[15:8];
    assign am7[7:0] = b[23:16];
    assign am8[7:0] = b[31:24];

    wallace_tree_multiplier bc1 (am1[7:0], am5[7:0], li1);
    wallace_tree_multiplier bc2 (am1, am6, li2);
    wallace_tree_multiplier bc3 (am1, am7, li3);
    wallace_tree_multiplier bc4 (am1, am8, li4);
    wallace_tree_multiplier bc5 (am2, am5, li5);
    wallace_tree_multiplier bc6 (am2, am6, li6);
    wallace_tree_multiplier bc7 (am2, am7, li7);
    wallace_tree_multiplier bc9 (am3, am5, li9);
    wallace_tree_multiplier bc10 (am3, am6, li10);
    wallace_tree_multiplier bc13 (am4, am5, li8);



    assign l1 = {16'b0, li1[15:0]};
    assign l2 = {8'b0, li2[15:0], 8'b0};
    assign l5 = {8'b0, li5[15:0], 8'b0};
    assign l6 = {li6[15:0], 16'b0};
    assign l9 = {li9[15:0], 16'b0};
    assign l3 = {li3[15:0], 16'b0};
    assign l4 = {li4[7:0], 24'b0};
    assign l7 = {li7[7:0], 24'b0};
    assign l10 = {li10[7:0], 24'b0};
    assign l8 = {li8[7:0], 24'b0};

    assign addtemp1 = l1 + l2;
    assign addtemp2 = l3 + l4;
    assign addtemp3 = l5 + l6;
    assign addtemp4 = l7 + l8;
    assign addtemp5 = l9 + l10;

    assign w1 = addtemp1 + addtemp2;
    assign w2 = addtemp3 + addtemp4;
    assign w3 = w1 + w2;
    assign out = w3 + addtemp5;
endmodule

module full_adder (
    input  a,
    b,
    cin,
    output sum,
    cout
);
    wire temp1, temp2, temp3;

    assign temp1 = a ^ b;  
    assign temp2 = a & b; 
    assign temp3 = cin & temp1; 
    assign sum   = cin ^ temp1;  
    assign cout  = temp2 | temp3; 
endmodule


module half_adder (
    input  a,
    b,
    output sum,
    carry
);
    assign sum   = a ^ b; 
    assign carry = a & b;
endmodule

module wallace_tree_multiplier(a1,b1,result);
input [7:0]a1;
input [7:0]b1;
output [15:0] result;

wire [7:0] p1,p2,p3,p4,p5,p6,p7,p8; 
wire [15:0] carry1,carry2,carry3,carry4,carry5,carry6;
wire [15:0] sum1,sum2,sum3,sum4,sum5,sum6;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12;


assign p1[0] = a1[0]&b1[0];
assign p1[1] = a1[1]&b1[0];
assign p1[2] = a1[2]&b1[0];
assign p1[3] = a1[3]&b1[0];
assign p1[4] = a1[4]&b1[0];
assign p1[5] = a1[5]&b1[0];
assign p1[6] = a1[6]&b1[0];
assign p1[7] = a1[7]&b1[0];

assign p2[0] = a1[0]&b1[1];
assign p2[1] = a1[1]&b1[1];
assign p2[2] = a1[2]&b1[1];
assign p2[3] = a1[3]&b1[1];
assign p2[4] = a1[4]&b1[1];
assign p2[5] = a1[5]&b1[1];
assign p2[6] = a1[6]&b1[1];
assign p2[7] = a1[7]&b1[1];

assign p3[0] = a1[0]&b1[2];
assign p3[1] = a1[1]&b1[2];
assign p3[2] = a1[2]&b1[2];
assign p3[3] = a1[3]&b1[2];
assign p3[4] = a1[4]&b1[2];
assign p3[5] = a1[5]&b1[2];
assign p3[6] = a1[6]&b1[2];
assign p3[7] = a1[7]&b1[2];

assign p4[0] = a1[0]&b1[3];
assign p4[1] = a1[1]&b1[3];
assign p4[2] = a1[2]&b1[3];
assign p4[3] = a1[3]&b1[3];
assign p4[4] = a1[4]&b1[3];
assign p4[5] = a1[5]&b1[3];
assign p4[6] = a1[6]&b1[3];
assign p4[7] = a1[7]&b1[3];

assign p5[0] = a1[0]&b1[4];
assign p5[1] = a1[1]&b1[4];
assign p5[2] = a1[2]&b1[4];
assign p5[3] = a1[3]&b1[4];
assign p5[4] = a1[4]&b1[4];
assign p5[5] = a1[5]&b1[4];
assign p5[6] = a1[6]&b1[4];
assign p5[7] = a1[7]&b1[4];

assign p6[0] = a1[0]&b1[5];
assign p6[1] = a1[1]&b1[5];
assign p6[2] = a1[2]&b1[5];
assign p6[3] = a1[3]&b1[5];
assign p6[4] = a1[4]&b1[5];
assign p6[5] = a1[5]&b1[5];
assign p6[6] = a1[6]&b1[5];
assign p6[7] = a1[7]&b1[5];

assign p7[0] = a1[0]&b1[6];
assign p7[1] = a1[1]&b1[6];
assign p7[2] = a1[2]&b1[6];
assign p7[3] = a1[3]&b1[6];
assign p7[4] = a1[4]&b1[6];
assign p7[5] = a1[5]&b1[6];
assign p7[6] = a1[6]&b1[6];
assign p7[7] = a1[7]&b1[6];

assign p8[0] = a1[0]&b1[7];
assign p8[1] = a1[1]&b1[7];
assign p8[2] = a1[2]&b1[7];
assign p8[3] = a1[3]&b1[7];
assign p8[4] = a1[4]&b1[7];
assign p8[5] = a1[5]&b1[7];
assign p8[6] = a1[6]&b1[7];
assign p8[7] = a1[7]&b1[7];

assign sum1[0] = p1[0];
half_adder h0( p1[1],p2[0],sum1[1],carry1[0] );

full_adder h1(p1[2],p2[1],p3[0],sum1[2],carry1[1]);
full_adder h2(p1[3],p2[2],p3[1],sum1[3],carry1[2]);
full_adder h3(p1[4],p2[3],p3[2],sum1[4],carry1[3]);
full_adder h4(p1[5],p2[4],p3[3],sum1[5],carry1[4]);
full_adder h5(p1[6],p2[5],p3[4],sum1[6],carry1[5]);
full_adder h6(p1[7],p2[6],p3[5],sum1[7],carry1[6]);

half_adder h7(p2[7],p3[6],sum1[8],carry1[7]);
assign sum1[9] = p3[7];

assign sum2[0] = p4[0];
half_adder h9( p4[1],p5[0],sum2[1],carry2[0] );

full_adder h10(p4[2],p5[1],p6[0],sum2[2],carry2[1]);
full_adder h11(p4[3],p5[2],p6[1],sum2[3],carry2[2]);
full_adder h12(p4[4],p5[3],p6[2],sum2[4],carry2[3]);
full_adder h13(p4[5],p5[4],p6[3],sum2[5],carry2[4]);
full_adder h14(p4[6],p5[5],p6[4],sum2[6],carry2[5]);
full_adder h15(p4[7],p5[6],p6[5],sum2[7],carry2[6]);

half_adder h16(p5[7],p6[6],sum2[8],carry2[7]);
assign sum2[9] = p6[7];

assign sum3[0] = sum1[0];
assign sum3[1] = sum1[1];
half_adder h17(sum1[2],carry1[0],sum3[2],carry3[0]);
full_adder h18(sum1[3],carry1[1],sum2[0],sum3[3],carry3[1]);
full_adder h19(sum1[4],carry1[2],sum2[1],sum3[4],carry3[2]);
full_adder h20(sum1[5],carry1[3],sum2[2],sum3[5],carry3[3]);
full_adder h21(sum1[6],carry1[4],sum2[3],sum3[6],carry3[4]);
full_adder h22(sum1[7],carry1[5],sum2[4],sum3[7],carry3[5]);
full_adder h23(sum1[8],carry1[6],sum2[5],sum3[8],carry3[6]);
full_adder h24(sum1[9],carry1[7],sum2[6],sum3[9],carry3[7]);

assign sum3[10] = sum2[7];
assign sum3[11] = sum2[8];
assign sum3[12] = sum2[9];

assign sum4[0] = carry2[0];
half_adder h25(carry2[1],p7[0],sum4[1],carry4[0]);
full_adder h26(carry2[2],p7[1],p8[0],sum4[2],carry4[1]);
full_adder h27(carry2[3],p7[2],p8[1],sum4[3],carry4[2]);
full_adder h28(carry2[4],p7[3],p8[2],sum4[4],carry4[3]);
full_adder h29(carry2[5],p7[4],p8[3],sum4[5],carry4[4]);
full_adder h30(carry2[6],p7[5],p8[4],sum4[6],carry4[5]);
full_adder h31(carry2[7],p7[6],p8[5],sum4[7],carry4[6]);

half_adder h32(p7[7],p8[6],sum4[8],carry4[7]);
assign sum4[9] = p8[7];

assign sum5[0] = sum3[0];
assign sum5[1] = sum3[1];
assign sum5[2] = sum3[2];
half_adder h33(sum3[3],carry3[0],sum5[3],carry5[0]);

half_adder h41(sum3[4],carry3[1],sum5[4],carry5[1]);
full_adder h34(sum3[5],carry3[2],sum4[0],sum5[5],carry5[2]);
full_adder h35(sum3[6],carry3[3],sum4[1],sum5[6],carry5[3]);
full_adder h36(sum3[7],carry3[4],sum4[2],sum5[7],carry5[4]);
full_adder h37(sum3[8],carry3[5],sum4[3],sum5[8],carry5[5]);
full_adder h38(sum3[9],carry3[6],sum4[4],sum5[9],carry5[6]);
full_adder h39(sum3[10],carry3[7],sum4[5],sum5[10],carry5[7]);

half_adder h40(sum3[11],sum4[6],sum5[11],carry5[8]);
half_adder h42(sum3[12],sum4[7],sum5[12],carry5[9]);
assign sum5[13] = sum4[8];
assign sum5[14] = sum4[9];

assign sum6[0] = sum5[0];
assign sum6[1] = sum5[1];
assign sum6[2] = sum5[2];
assign sum6[3] = sum5[3];
half_adder h43(sum5[4],carry5[0],sum6[4],carry6[0]);
half_adder h44(sum5[5],carry5[1],sum6[5],carry6[1]);
half_adder h45(sum5[6],carry5[2],sum6[6],carry6[2]);

full_adder f1(sum5[7],carry5[3],carry4[0],sum6[7],carry6[3]);
full_adder f2(sum5[8],carry5[4],carry4[1],sum6[8],carry6[4]);
full_adder f3(sum5[9],carry5[5],carry4[2],sum6[9],carry6[5]);
full_adder f4(sum5[10],carry5[6],carry4[3],sum6[10],carry6[6]);
full_adder f5(sum5[11],carry5[7],carry4[4],sum6[11],carry6[7]);
full_adder f6(sum5[12],carry5[8],carry4[5],sum6[12],carry6[8]);
full_adder f7(sum5[13],carry5[9],carry4[6],sum6[13],carry6[9]);

half_adder h46(sum5[14],carry4[7],sum6[14],carry6[10]);

assign result[0] = sum6[0];
assign result[1] = sum6[1];
assign result[2] = sum6[2];
assign result[3] = sum6[3];
assign result[4] = sum6[4];
half_adder h47(sum6[5],carry6[0],result[5],c1);
full_adder h48(sum6[6],carry6[1],c1,result[6],c2);
full_adder h49(sum6[7],carry6[2],c2,result[7],c3);
full_adder h50(sum6[8],carry6[3],c3,result[8],c4);
full_adder h51(sum6[9],carry6[4],c4,result[9],c5);

full_adder h52(sum6[10],carry6[5],c5,result[10],c6);
full_adder h53(sum6[11],carry6[6],c6,result[11],c7);
full_adder h54(sum6[12],carry6[7],c7,result[12],c8);
full_adder h55(sum6[13],carry6[8],c8,result[13],c9);
full_adder h56(sum6[14],carry6[9],c9,result[14],c10);

half_adder h57(carry6[10],c10,result[15],c11);

endmodule
