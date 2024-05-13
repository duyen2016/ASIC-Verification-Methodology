`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 02:00:31 AM
// Design Name: 
// Module Name: EX_MA
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


module EX_MA(
    input [31:0] ALU_res_EX, DB_EX, PCadd4_EX,  inst_EX,
    input [2:0] type_EX,
    input BrEq_EX, BrLT_EX, clk, rst,
    output [2:0] type_MA,
    output reg [31:0] ALU_res_MA, DB_MA, PCadd4_MA, inst_MA,
    output MemRW, PCSel,
    output reg BrEq_MA, BrLT_MA,
    output [2:0] funct3
    );
    `include "parameter.vh"
    assign funct3 = inst_MA[14:12];
    wire [31:0]next_inst;
//    assign next_inst = (stall)? 32'h00008093: inst_EX;
    always @(posedge clk) begin
//        if (!PCSel) begin
        if (rst) begin
            ALU_res_MA <= 0;
            DB_MA <= 0;
            PCadd4_MA <= 0;
            BrEq_MA <= 0;
            BrLT_MA <= 0; 
            inst_MA <= 0;
        end
        else begin
            ALU_res_MA <= ALU_res_EX;
            DB_MA <= DB_EX;
            PCadd4_MA <= PCadd4_EX;
            BrEq_MA <= BrEq_EX;
            BrLT_MA <= BrLT_EX; 
            inst_MA <= inst_EX;
        end
//        else begin
//            type_MA <= type_MA;
//            ALU_res_MA <= 32'b0;
//            DB_MA <= 32'b0;
//            PCadd4_MA <= PCadd4_MA;
//            BrEq_MA <= BrEq_MA;
//            BrLT_MA <= BrLT_MA; 
//            inst_MA <= 32'h00008093;
//        end
    end
    wire [6:0] opcode;
    assign opcode = inst_MA[6:0];
    assign MemRW = getMemRW(opcode); 
    assign PCSel = getPCsel(type_MA, funct3, BrEq_MA, BrLT_MA);
    assign type_MA = gettype(opcode);
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
    function getMemRW (input [6:0] opcode);
        begin
            if (opcode == 7'b0100011) getMemRW = 1'b0;
            else getMemRW = 1'b1;
        end
    endfunction
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
    
endmodule
