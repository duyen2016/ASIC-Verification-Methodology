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
    input [63:0] address_t,
    input [15:0] getheader_n,
    input [0:15] frame_n,
    input reset_n, clk, 
    output [15:0] frameo_n,
    output reg [15:0] wait_n
    );
    reg [0:15] frameo_nt;
    wire [3:0] address [15:0];
    assign {address[15],address[14], address[13], address[12], address[11], address[10], address[9], address[8], address[7], address[6], address[5], address[4], address[3], address[2], address[1], address[0]} = address_t;
    assign frameo_n = frameo_nt;      
    always @(posedge clk) begin
        if (!reset_n) begin
            wait_n = 16'hffff;
            frameo_nt = 16'hffff;
        end
        else begin
        wait_n[0] = (frameo_n[address[0]] == 1'b0 && (!getheader_n[0]))? 0:1;
        frameo_nt[address[0]] = (getheader_n[0])? 1 : frame_n;
        wait_n[1] = (frameo_n[address[1]] == 1'b0 && (!getheader_n[1]))? 0:1;
        frameo_nt[address[1]] = (getheader_n[1])? 1 : frame_n;
        wait_n[2] = (frameo_n[address[2]] == 1'b0 && (!getheader_n[2]))? 0:1;
        frameo_nt[address[2]] = (getheader_n[2])? 1 : frame_n;
        wait_n[3] = (frameo_n[address[3]] == 1'b0 && (!getheader_n[3]))? 0:1;
        frameo_nt[address[3]] = (getheader_n[3])? 1 : frame_n;
        wait_n[4] = (frameo_n[address[4]] == 1'b0 && (!getheader_n[4]))? 0:1;
        frameo_nt[address[4]] = (getheader_n[4])? 1 : frame_n;
        wait_n[5] = (frameo_n[address[5]] == 1'b0 && (!getheader_n[5]))? 0:1;
        frameo_nt[address[5]] = (getheader_n[5])? 1 : frame_n;
        wait_n[6] = (frameo_n[address[6]] == 1'b0 && (!getheader_n[6]))? 0:1;
        frameo_nt[address[6]] = (getheader_n[6])? 1 : frame_n;
        wait_n[7] = (frameo_n[address[7]] == 1'b0 && (!getheader_n[7]))? 0:1;
        frameo_nt[address[7]] = (getheader_n[7])? 1 : frame_n;
        wait_n[8] = (frameo_n[address[8]] == 1'b0 && (!getheader_n[8]))? 0:1;
        frameo_nt[address[8]] = (getheader_n[8])? 1 : frame_n;
        wait_n[9] = (frameo_n[address[9]] == 1'b0 && (!getheader_n[9]))? 0:1;
        frameo_nt[address[9]] = (getheader_n[9])? 1 : frame_n;
        wait_n[10] = (frameo_n[address[10]] == 1'b0 && (!getheader_n[10]))? 0:1;
        frameo_nt[address[10]] = (getheader_n[10])? 1 : frame_n;
        wait_n[11] = (frameo_n[address[11]] == 1'b0 && (!getheader_n[11]))? 0:1;
        frameo_nt[address[11]] = (getheader_n[11])? 1 : frame_n;
        wait_n[12] = (frameo_n[address[12]] == 1'b0 && (!getheader_n[12]))? 0:1;
        frameo_nt[address[12]] = (getheader_n[12])? 1 : frame_n;
        wait_n[13] = (frameo_n[address[13]] == 1'b0 && (!getheader_n[13]))? 0:1;
        frameo_nt[address[13]] = (getheader_n[13])? 1 : frame_n;
        wait_n[14] = (frameo_n[address[14]] == 1'b0 && (!getheader_n[14]))? 0:1;
        frameo_nt[address[14]] = (getheader_n[14])? 1 : frame_n;
        wait_n[15] = (frameo_n[address[15]] == 1'b0 && (!getheader_n[15]))? 0:1;
        frameo_nt[address[15]] = (getheader_n[15])? 1 : frame_n;
        end
        
    end
endmodule
