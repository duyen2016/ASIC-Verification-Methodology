`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 09:25:59 PM
// Design Name: 
// Module Name: arbiter
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


module arbiter(
    input [4:0] header [0:15],
    input [0:15] frame_n,
    inout [15:0] frameo_n,
    input reset_n, 
    output reg [15:0] wait_n
    );
    
    wire getheader_n[0:15];
    wire [3:0]address[0:15];
    assign {getheader_n,address} = header;  
    always @(*) begin
        wait_n[0] = (frameo_n[address[0]] == 1'b0 && (!getheader_n[0]))? 0:1;
        frameo_n[address[0]] = (getheader_n)? 1 : frame_n;
        busy[1] = (frameo_n[address[3:0][1]] == 1'b0 && (address[4][1] == 1'b1))? 0:1;
        if (busy[1] == 1'b0) frameo_n[address[3:0][1]] = 1'b0;
        busy[2] = (frameo_n[address[3:0][2]] == 1'b0 && (address[4][2] == 1'b1))? 0:1;
        if (busy[2] == 1'b0) frameo_n[address[3:0][2]] = 1'b0;
        busy[3] = (frameo_n[address[3:0][3]] == 1'b0 && (address[4][3] == 1'b1))? 0:1;
        if (busy[3] == 1'b0) frameo_n[address[3:0][3]] = 1'b0;
        busy[4] = (frameo_n[address[3:0][4]] == 1'b0 && (address[4][4] == 1'b1))? 0:1;
        if (busy[4] == 1'b0) frameo_n[address[3:0][4]] = 1'b0;
        busy[5] = (frameo_n[address[3:0][5]] == 1'b0 && (address[4][5] == 1'b1))? 0:1;
        if (busy[5] == 1'b0) frameo_n[address[3:0][5]] = 1'b0;
        busy[6] = (frameo_n[address[3:0][6]] == 1'b0 && (address[4][6] == 1'b1))? 0:1;
        if (busy[6] == 1'b0) frameo_n[address[3:0][6]] = 1'b0;
        busy[7] = (frameo_n[address[3:0][7]] == 1'b0 && (address[4][7] == 1'b1))? 0:1;
        if (busy[7] == 1'b0) frameo_n[address[3:0][7]] = 1'b0;
        busy[8] = (frameo_n[address[3:0][8]] == 1'b0 && (address[4][8] == 1'b1))? 0:1;
        if (busy[8] == 1'b0) frameo_n[address[3:0][8]] = 1'b0;
        busy[9] = (frameo_n[address[3:0][9]] == 1'b0 && (address[4][9] == 1'b1))? 0:1;
        if (busy[9] == 1'b0) frameo_n[address[3:0][9]] = 1'b0;
        busy[10] = (frameo_n[address[3:0][10]] == 1'b0 && (address[4][10] == 1'b1))? 0:1;
        if (busy[10] == 1'b0) frameo_n[address[3:0][10]] = 1'b0;
        busy[11] = (frameo_n[address[3:0][11]] == 1'b0 && (address[4][11] == 1'b1))? 0:1;
        if (busy[11] == 1'b0) frameo_n[address[3:0][11]] = 1'b0;
        busy[12] = (frameo_n[address[3:0][12]] == 1'b0 && (address[4][12] == 1'b1))? 0:1;
        if (busy[12] == 1'b0) frameo_n[address[3:0][12]] = 1'b0;
        busy[13] = (frameo_n[address[3:0][13]] == 1'b0 && (address[4][13] == 1'b1))? 0:1;
        if (busy[13] == 1'b0) frameo_n[address[3:0][13]] = 1'b0;
        busy[14] = (frameo_n[address[3:0][14]] == 1'b0 && (address[4][14] == 1'b1))? 0:1;
        if (busy[14] == 1'b0) frameo_n[address[3:0][14]] = 1'b0;
        busy[15] = (frameo_n[address[3:0][15]] == 1'b0 && (address[4][15] == 1'b1))? 0:1;
        if (busy[15] == 1'b0) frameo_n[address[3:0][15]] = 1'b0;
        
    end
endmodule
