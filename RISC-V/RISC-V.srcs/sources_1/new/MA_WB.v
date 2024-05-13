`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 02:44:49 AM
// Design Name: 
// Module Name: MA_WB
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


module MA_WB(
    input [31:0] ALU_res_MA, PCadd4_MA, mem_MA, inst_MA,
    input [2:0] type_MA,
    input BrEq_MA, BrLT_MA, clk, rst,
    output reg [2:0] type_WB,
    output reg [31:0] ALU_res_WB, PCadd4_WB, mem_WB, inst_WB,
    output reg BrEq_WB, BrLT_WB,
    output wire RegWEn,
    output [1:0] WBSel,
    output [4:0] AddrD
    );
    `include "parameter.vh"
    wire [6:0] opcode;
    wire [2:0] funct3;
    assign AddrD = inst_WB[11:7];
    always @(posedge clk) begin
        if (rst) begin
            ALU_res_WB <= 0;
            PCadd4_WB <= 0;
            mem_WB <= 0;
            inst_WB <= 0;
            BrEq_WB <= 0;
            BrLT_WB <= 0;
            type_WB <= 0;
        end
        else begin
            ALU_res_WB <= ALU_res_MA;
            PCadd4_WB <= PCadd4_MA;
            mem_WB <= mem_MA;
            inst_WB <= inst_MA;
            BrEq_WB <= BrEq_MA;
            BrLT_WB <= BrLT_MA;
            type_WB <= type_MA;
        end
    end
    assign funct3 = inst_WB[14:12];
    assign opcode = inst_WB[6:0];
    assign WBSel = getWBSel(opcode);
//    assign PCSel = getPCsel(type_WB, funct3, BrEq_WB, BrLT_WB);
    assign RegWEn = getRegWEn(type_WB);
    function [1:0] getWBSel (input [6:0] opcode);
        begin
            if (opcode == 7'b1101111) getWBSel = 2'b10;
            else if (opcode == 7'b1100111) getWBSel = 2'b10;
            else if (opcode == 7'b0000011) getWBSel = 2'b00;
            else getWBSel = 2'b01;
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
endmodule
