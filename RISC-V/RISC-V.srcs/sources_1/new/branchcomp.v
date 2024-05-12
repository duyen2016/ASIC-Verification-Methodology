`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2024 06:17:32 PM
// Design Name: 
// Module Name: branchcomp
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


module branchcomp(
    input [31:0] a, b,
    input BrUn,
    output reg BrEq, BrLT
    );
    wire signed[31:0] sa, sb;
    assign sa = a;
    assign sb = b;
    always @(*) begin
        if (BrUn) begin
            if (a == b) BrEq = 1'b1;
            else BrEq = 1'b0;
            if (a < b) BrLT = 1'b1;
            else BrLT = 1'b0;
        end 
        else begin
            if (sa == sb) BrEq = 1'b1;
            else BrEq = 1'b0;
            if (sa < sb) BrLT = 1'b1;
            else BrLT = 1'b0;
        end
    end
endmodule
