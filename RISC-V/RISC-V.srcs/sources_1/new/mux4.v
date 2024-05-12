`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 07:33:25 PM
// Design Name: 
// Module Name: mux4
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


module mux4(
    input [1:0] sel,
    input [31:0] in0, in1, in2, in3,
    output reg [31:0] s
    );
    always @(*) begin
        case (sel)
            2'b00: s = in0;
            2'b01: s = in1;
            2'b10: s = in2;
            2'b11: s = in3;
        endcase
    end
endmodule
