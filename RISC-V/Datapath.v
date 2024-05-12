module datapath(PC, inst, clk, ImmSel, RegWEn, Bsel, ALUSel, MemRW, WBSel, pcadd4);
  input [31:0] inst;
  input RegWEn, Bsel, ASel, MemRW, clk;
  input [1:0] ImmSel, WBSel;
  input [3:0] ALUSel;
  //ImmSel = 00 ~ I
  //ImmSel = 01 ~ S
  //ImmSel = 10 ~ U
  

endmodule


