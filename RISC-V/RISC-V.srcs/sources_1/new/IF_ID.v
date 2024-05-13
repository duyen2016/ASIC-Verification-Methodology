`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 01:09:07 AM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk, stall, rst,
    input [31:0] inst_IF, PC_IF, PCadd4_IF,
    output [4:0]i1, i2, 
    output [24:0] i3,
    output reg [31:0] inst_ID, PC_ID, PCadd4_ID, 
    output [2:0] type, ImmSel
    );
    `include "parameter.vh"
    wire [6:0] opcode;
    assign i1 = inst_ID[19:15];
    assign i2 = inst_ID[24:20];
    assign i3 = inst_ID[31:7];
    assign opcode = inst_ID[6:0];
    assign type = gettype(opcode);
    assign ImmSel = getImmSel(type);
    wire [31:0] next_inst;
    assign next_inst = (stall)? 32'h00008093: inst_IF;
    always @(posedge clk) begin
        if (rst) begin
            inst_ID <= 32'h0;       
            PC_ID <=  -4;
            PCadd4_ID <= 0;            
        end
        else begin
            inst_ID <= next_inst;
            PC_ID <= PC_IF;
            PCadd4_ID <= PCadd4_IF;         
        end
    end
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
