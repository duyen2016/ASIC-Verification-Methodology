`timescale 1ns/1ps
module alu(reg1, reg2, ALUsel, ALUresult);
  input [31:0] reg1, reg2;
  input [3:0] ALUsel;
  output reg [31:0] ALUresult;
  `include "parameter.vh"
  wire signed [31:0] signed_reg1, signed_reg2;
  assign signed_reg1 = reg1;
  assign signed_reg2 = reg2;
  always @(*) begin
  case (ALUsel)
    AND:
      ALUresult = reg1 & reg2;
    OR: 
      ALUresult = reg1 | reg2;
    ADD:
      ALUresult = reg1 + reg2;
    ADD0:
      ALUresult = reg2 + 0;
    SLL://sll & i
        begin
            if (reg2[4:0] == 5'b0) ALUresult = reg1;
            else ALUresult = reg1 << reg2[4:0];
        end
    SRL: //srl & i
        begin
            if (reg2[4:0] == 5'b0) ALUresult = reg1;
            else ALUresult = reg1 >> reg2[4:0];
 
        end 
    SUB:
      ALUresult = reg1 - reg2;
    unsigned_SLT:
      ALUresult = (reg1 < reg2)? 32'h1 : 32'h0;
    signed_SLT:
      ALUresult = (signed_reg1 < signed_reg2)? 32'h1 : 32'h0; 
    SRA: //sra & i 
        begin
            if (signed_reg2[4:0] == 5'b0) ALUresult = signed_reg1;
            else ALUresult = signed_reg1 >>> signed_reg2[4:0]; 
        end
    JALR: 
      ALUresult = (reg1 + reg2) & 32'hfffe;
    XOR:
      ALUresult = reg1 ^ reg2;
  endcase
  end
endmodule

