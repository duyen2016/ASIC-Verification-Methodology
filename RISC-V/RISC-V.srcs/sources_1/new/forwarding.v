`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 09:50:29 AM
// Design Name: 
// Module Name: forwarding
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


module forwarding(
    input [31:0] inst_EX, inst_MA, inst_WB,
    input [2:0] type_EX,
    output reg [1:0] AForwarding, BForwarding
    );
    `include "parameter.vh"
    wire [5:0] rs1_EX, rs2_EX, rd_MA, rd_WB;
    wire [6:0] opcode_EX, opcode_MA;
    assign rs1_EX = inst_EX[19:15];
    assign rs2_EX = inst_EX[24:20];
    assign rd_WB = inst_WB[11:7];
    assign rd_MA = inst_MA[11:7];
//    assign rd_WB = inst_WB[11:7]; 
    wire [1:0] WBSel_EX, WBSel_MA;
    assign opcode_MA = inst_MA[6:0];
    assign WBSel_MA = getWBSel(opcode_MA);
    always @(*) begin
        case (type_EX)
            R_Type: begin
                if (rs1_EX == rd_MA) AForwarding = WBSel_MA;
                else if (rs1_EX == rd_WB) AForwarding = 2'b11;
//                else if (rs1_ID == rd_WB) AForwarding = 2'b11;
                else AForwarding = 2'b10;
                if (rs2_EX == rd_MA) BForwarding = WBSel_MA;
                else if (rs2_EX == rd_WB) BForwarding = 2'b11;
//                else if (rs2_ID == rd_WB) BForwarding = 2'b11;
                else BForwarding = 2'b10;
            end
            I_Type: begin
                if (rs1_EX == rd_MA) AForwarding = WBSel_MA;
                else if (rs1_EX == rd_WB) AForwarding = 2'b11;
//                else if (rs1_ID == rd_WB) AForwarding = 2'b11;
                else AForwarding = 2'b10;
            end
            I_Type_JALR: begin
                if (rs1_EX == rd_MA) AForwarding = WBSel_MA;
                else if (rs1_EX == rd_WB) AForwarding = 2'b11;
//                else if (rs1_ID == rd_WB) AForwarding = 2'b11;
                else AForwarding = 2'b10;
            end
            S_Type: begin
                if (rs1_EX == rd_MA) AForwarding = WBSel_MA;
                else if (rs1_EX == rd_WB) AForwarding = 2'b11;
//                else if (rs1_ID == rd_WB) AForwarding = 2'b11;
                else AForwarding = 2'b10;
                if (rs2_EX == rd_MA) BForwarding = WBSel_MA;
                else if (rs2_EX == rd_WB) BForwarding = 2'b11;
//                else if (rs2_ID == rd_WB) BForwarding = 2'b11;
                else BForwarding = 2'b10;
            end
            B_Type: begin
                if (rs1_EX == rd_MA) AForwarding = WBSel_MA;
                else if (rs1_EX == rd_WB) AForwarding = 2'b11;
//                else if (rs1_ID == rd_WB) AForwarding = 2'b11;
                else AForwarding = 2'b10;
                if (rs2_EX == rd_MA) BForwarding = WBSel_MA;
                else if (rs2_EX == rd_WB) BForwarding = 2'b11;
//                else if (rs2_ID == rd_WB) BForwarding = 2'b11;
                else BForwarding = 2'b10;
            end
            default: begin
                AForwarding = 2'b10;
                BForwarding = 2'b10;
           end
        endcase
    end
function [1:0] getWBSel (input [6:0] opcode);
    begin
        if (opcode == 7'b1101111) getWBSel = 2'b10;
        else if (opcode == 7'b1100111) getWBSel = 2'b10;
        else if (opcode == 7'b0000011) getWBSel = 2'b00;
        else getWBSel = 2'b01;
    end
endfunction
endmodule
