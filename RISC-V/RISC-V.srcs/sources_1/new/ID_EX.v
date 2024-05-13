`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 01:29:52 AM
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(
    input clk, stall, rst,
    input [31:0] PC_ID, PCadd4_ID, DA_ID, DB_ID, imm_ID, inst_ID,
    input [2:0] type_ID,
    output reg [31:0] PC_EX, PCadd4_EX, DA_EX, DB_EX, imm_EX, inst_EX,
    output [2:0] type_EX, 
    output BrUn, BSel, ASel, 
    output [3:0] ALUSel
    );
    `include "parameter.vh"
    wire [31:0] next_inst;
    assign next_inst = (stall)? 32'h00008093: inst_ID;
    always @(posedge clk) begin
        if (rst) begin
            PC_EX <= -4;
            PCadd4_EX <= 0;
            DA_EX <= 32'b0;
            DB_EX <= 32'b0;
            imm_EX <= 32'b0;
            inst_EX <= 32'h0;
        end
        else begin
            PC_EX <= PC_ID;
            PCadd4_EX <= PCadd4_ID;
            DA_EX <= DA_ID;
            DB_EX <= DB_ID;
            imm_EX <= imm_ID;
            inst_EX <= next_inst;
        end
        end
    
    wire [2:0] funct3;
    wire [6:0] opcode;
    wire [6:0] funct7;
    assign type_EX = gettype(opcode);
    assign funct3 = inst_EX[14:12];
    assign opcode = inst_EX[6:0];
    assign funct7 = inst_EX[31:25];
    assign BrUn = getBrUn(type_EX, funct3);
    assign BSel = getBSel(type_EX);
    assign ASel = getASel(type_EX, opcode);
    assign ALUSel = getALUSel(opcode, funct3, funct7);
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
