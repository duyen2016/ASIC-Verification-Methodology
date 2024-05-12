`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2024 05:36:57 PM
// Design Name: 
// Module Name: mux3
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


module mux3(
    input [1:0] sel,
    input [31:0] in0, in1, in2,
    output reg [31:0] s
    );
    always @(*) begin
        case (sel)
            2'b00: s = in0;
            2'b01: s = in1;
            2'b10: s = in2;
            default: s = 32'b0;
        endcase
    end
endmodule
