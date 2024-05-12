module controller(PCSel, inst, ImmSel, RegWEn, BrUn, BrEq, BrLT, Bsel, ASel, ALUSel, MemRW, WBSel, funct3);
  input [31:0] inst;
  input BrEq, BrLT;
  output [2:0] ImmSel;
  output RegWEn, Bsel, MemRW, PCSel, BrUn, ASel;
  output [3:0] ALUSel;
  output [2:0] funct3;
  output [1:0] WBSel;
  `include "parameter.vh"
  wire [6:0] opcode, funct7;
  wire [2:0] type;
  assign opcode = inst[6:0];
  assign funct7 = inst[31:25];
  assign funct3 = inst[14:12];
  assign type = gettype(opcode);
  assign ImmSel = getImmSel(type);
  assign RegWEn = getRegWEn(type);
  assign BrUn = getBrUn(type, funct3);
  assign Bsel = getBSel(type);
  assign ASel = getASel(type, opcode);
  assign ALUSel = getALUSel(opcode, funct3, funct7);
  assign MemRW = getMemRW(opcode);
  assign WBSel = getWBSel(opcode);
  assign PCSel = getPCsel(type, funct3, BrEq, BrLT);
  function getPCsel(input [2:0] type, input [2:0] funct3, input BrEq, input BrLT);
      begin
        case (type)
            J_Type: getPCsel = 1'b1;
            B_Type: begin
                case (funct3)
                    3'b000: if (BrEq) getPCsel = 1'b1;
                                else getPCsel = 1'b0;
                    3'b001: if (!BrEq) getPCsel = 1'b1;
                                else getPCsel = 1'b0; 
                    3'b100: if (BrLT) getPCsel = 1'b1;
                                else getPCsel = 1'b0;
                    3'b101: if (!BrLT) getPCsel = 1'b1;
                                else getPCsel = 1'b0;
                    3'b110: if (BrLT) getPCsel = 1'b1;
                                else getPCsel = 1'b0;
                    3'b111: if (BrEq) getPCsel = 1'b1;
                                else getPCsel = 1'b0;
                    default: getPCsel = 1'b0;
                endcase
            end
            I_Type_JALR: getPCsel = 1'b1;
            default: getPCsel = 1'b0;
        endcase
      end
  endfunction  
  //ImmSel = 000 ~ I
  //ImmSel = 001 ~ S
  //ImmSel = 010 ~ B
  //ImmSel = 011 ~ U
  //ImmSel = 100 ~ J
  function [2:0] getImmSel(input [2:0] type);
    begin
        case(type)
            I_Type: getImmSel = 3'b000;
            S_Type: getImmSel = 3'b001;
            B_Type: getImmSel = 3'b010;
            U_Type: getImmSel = 3'b011;
            J_Type: getImmSel = 3'b100;
            I_Type_JALR: getImmSel = 3'b000;
            default: getImmSel = 3'b111;
        endcase
    end
  endfunction
  function getRegWEn(input [2:0]type);
    begin
        case (type)
            B_Type: getRegWEn = 1'b0;
            S_Type: getRegWEn = 1'b0;
            default: getRegWEn = 1'b1;
        endcase
    end
  endfunction
  function getBrUn (input [2:0] type, input [2:0] funct3);
    begin
        if (type == B_Type && ((funct3 == 3'b110) || (funct3 == 3'b111)))
            getBrUn = 1'b1;
        else getBrUn = 1'b0;
    end
  endfunction
  function getBSel(input [2:0] type);
    begin
        if (type == R_Type) getBSel = 1'b0;
        else getBSel = 1'b1;
    end
  endfunction
  
  function getASel (input [2:0] type, input [6:0] opcode);
      begin
        case (type)
            B_Type: getASel = 1'b1;
            J_Type: getASel = 1'b1;
            I_Type_JALR: getASel = 1'b1;
            default: begin
                if (opcode == 7'b0010111) getASel = 1'b1;
                else getASel = 1'b0;
            end
        endcase
      end
  endfunction
  
  function [3:0] getALUSel (input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
    begin
        if ((opcode == 7'b1100111) && (funct3 == 3'b000)) getALUSel = JALR;
        else if ((opcode == 7'b0110111)) getALUSel = ADD0;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b010)) getALUSel = signed_SLT;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b011)) getALUSel = unsigned_SLT;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b100)) getALUSel = XOR;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b110)) getALUSel = OR;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b111)) getALUSel = AND;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b001)) getALUSel = SLL;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b101) && (funct7 == 7'b0000000)) getALUSel = SRL;
        else if (((opcode == 7'b0010011) || (opcode == 7'b0110011)) && (funct3 == 3'b101) && (funct7 == 7'b0100000)) getALUSel = SRA;
        else if ((opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) getALUSel = SUB;
        else getALUSel = ADD;
    end
  endfunction 
  function getMemRW (input [6:0] opcode);
    begin
        if (opcode == 7'b0100011) getMemRW = 1'b0;
        else getMemRW = 1'b1;
    end
  endfunction
  function [1:0] getWBSel (input [6:0] opcode);
    begin
        if (opcode == 7'b1101111) getWBSel = 2'b10;
        else if (opcode == 7'b1100111) getWBSel = 2'b10;
        else if (opcode == 7'b0000011) getWBSel = 2'b00;
        else getWBSel = 2'b01;
    end
  endfunction
  function [2:0] gettype (input [6:0] opcode);
    begin
        if (opcode == 7'b0110011) gettype = R_Type;
        else if (opcode == 7'b0000011) gettype = I_Type;
        else if (opcode == 7'b0010011) gettype = I_Type;
        else if (opcode == 7'b0100011) gettype = S_Type;
        else if (opcode == 7'b1100011) gettype = B_Type;
        else if (opcode == 7'b0110111) gettype = U_Type;
        else if (opcode == 7'b0010111) gettype = U_Type;
        else if (opcode == 7'b1101111) gettype = J_Type;
        else if (opcode == 7'b1100111) gettype = I_Type_JALR;    
        else gettype = 3'b111;   
    end
  endfunction
endmodule
