`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2024 01:04:11 AM
// Design Name: 
// Module Name: stall
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


module stall(
    input [2:0] type,
    input [31:0] inst, 
    input BrEq, BrLT,
    output stall
    );
    `include "parameter.vh"
    wire [2:0]funct3;
    assign funct3 = inst[14:12];
    assign stall = getPCsel(type, funct3, BrEq, BrLT);
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
