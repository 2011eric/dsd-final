module HAZARD_DETECTION (
    input ID_EX_MemRead, 
    input [4:0]ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2,
    output load_use_hazard

);
assign load_use_hazard = ID_EX_MemRead && ((ID_EX_RegisterRd == IF_ID_RegisterRs1) || (ID_EX_RegisterRd == IF_ID_RegisterRs2));
    
endmodule

