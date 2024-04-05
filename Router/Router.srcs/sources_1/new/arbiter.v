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
    input [15:0] frame_n,
    input reset_n, clk, 
    output reg [15:0] frameo_nt,
    output reg [15:0] wait_n
    );
    reg [15:0] frameo_n, running;
    wire [3:0] address [15:0];
    assign {address[15],address[14], address[13], address[12], address[11], address[10], address[9], address[8], address[7], address[6], address[5], address[4], address[3], address[2], address[1], address[0]} = address_t;
    //assign frameo_n = frameo_nt;      
    always @(posedge clk) begin
        frameo_n <= frameo_nt;
    end
    always @(*) begin
        if (!reset_n) begin
            wait_n = 16'hffff;
            frameo_nt = 16'hffff;
            running = 16'hffff;
        end
        else begin
        wait_n[0] = ((frameo_nt[address[0]] & frameo_n[address[0]]) | getheader_n[0] | wait_n[0] | !running[0])&(!wait_n[0] | frameo_nt[address[0]] | getheader_n[0] | !running[0]);
        frameo_nt[address[0]] = ((wait_n[0] & ~(frameo_n[address[0]] ^ frameo_nt[address[0]])) & (!getheader_n[0]))? frame_n[0]: frameo_nt[address[0]];
        running[0] = (((~wait_n[0]) | (frameo_nt[address[0]])) === 1'b0) ? 1'b0 : 1'b1 ;
        wait_n[1] = ((frameo_nt[address[1]] & frameo_n[address[1]]) | getheader_n[1] | wait_n[1] | !running[1])&(!wait_n[1] | frameo_nt[address[1]] | getheader_n[1] | !running[1]);
        frameo_nt[address[1]] = ((wait_n[1] & ~(frameo_n[address[1]] ^ frameo_nt[address[1]])) & (!getheader_n[1]))? frame_n[1]: frameo_nt[address[1]];
        running[1] = (((~wait_n[1]) | (frameo_nt[address[1]])) === 1'b0) ? 0:1;
        wait_n[2] = ((frameo_nt[address[2]] & frameo_n[address[2]]) | getheader_n[2] | wait_n[2] | !running[2])&(!wait_n[2] | frameo_nt[address[2]] | getheader_n[2] | !running[2]);
        frameo_nt[address[2]] = ((wait_n[2] & ~(frameo_n[address[2]] ^ frameo_nt[address[2]]))& (!getheader_n[2]))? frame_n[2]: frameo_nt[address[2]];
        running[2] = (((~wait_n[2]) | (frameo_nt[address[2]])) === 1'b0) ? 0:1;
        wait_n[3] = ((frameo_nt[address[3]] & frameo_n[address[3]]) | getheader_n[3] | wait_n[3] | !running[3])&(!wait_n[3] | frameo_nt[address[3]] | getheader_n[3] | !running[3]);
        frameo_nt[address[3]] = ((wait_n[3] & ~(frameo_n[address[3]] ^ frameo_nt[address[3]])) & (!getheader_n[3]))? frame_n[3]: frameo_nt[address[3]];
        running[3] = (((~wait_n[3]) | (frameo_nt[address[3]])) === 1'b0) ? 0:1;
        wait_n[4] = ((frameo_nt[address[4]] & frameo_n[address[4]]) | getheader_n[4] | wait_n[4] | !running[4])&(!wait_n[4] | frameo_nt[address[4]] | getheader_n[4] | !running[4]);
        frameo_nt[address[4]] = ((wait_n[4] & ~(frameo_n[address[4]] ^ frameo_nt[address[4]])) & (!getheader_n[4]))? frame_n[4]: frameo_nt[address[4]];
        running[4] = (((~wait_n[4]) | (frameo_nt[address[4]])) === 1'b0)  ? 0:1;
        wait_n[5] = ((frameo_nt[address[5]] & frameo_n[address[5]]) | getheader_n[5] | wait_n[5] | !running[5])&(!wait_n[5] | frameo_nt[address[5]] | getheader_n[5] | !running[5]);
        frameo_nt[address[5]] = ((wait_n[5] & ~(frameo_n[address[5]] ^ frameo_nt[address[5]])) & (!getheader_n[5]))? frame_n[5]: frameo_nt[address[5]];
        running[5] = (((~wait_n[5]) | (frameo_nt[address[5]])) === 1'b0) ? 0:1;
        wait_n[6] = ((frameo_nt[address[6]] & frameo_n[address[6]]) | getheader_n[6] | wait_n[6] | !running[6])&(!wait_n[6] | frameo_nt[address[6]] | getheader_n[6] | !running[6]);
        frameo_nt[address[6]] = ((wait_n[6] & ~(frameo_n[address[6]] ^ frameo_nt[address[6]])) & (!getheader_n[6]))? frame_n[6]: frameo_nt[address[6]];
        running[6] = (((~wait_n[6]) | (frameo_nt[address[6]])) === 1'b0) ? 0:1;
        wait_n[7] = ((frameo_nt[address[7]] & frameo_n[address[7]]) | getheader_n[7] | wait_n[7] | !running[7])&(!wait_n[7] | frameo_nt[address[7]] | getheader_n[7] | !running[7]);
        frameo_nt[address[7]] = ((wait_n[7] & ~(frameo_n[address[7]] ^ frameo_nt[address[7]])) & (!getheader_n[7]))? frame_n[7]: frameo_nt[address[7]];
        running[7] = (((~wait_n[7]) | (frameo_nt[address[7]])) === 1'b0) ? 0:1;
        wait_n[8] = ((frameo_nt[address[8]] & frameo_n[address[8]]) | getheader_n[8] | wait_n[8] | !running[8])&(!wait_n[8] | frameo_nt[address[8]] | getheader_n[8] | !running[8]);
        frameo_nt[address[8]] = ((wait_n[8] & ~(frameo_n[address[8]] ^ frameo_nt[address[8]])) & (!getheader_n[8]))? frame_n[8]: frameo_nt[address[8]];
        running[8] = (((~wait_n[8]) | (frameo_nt[address[8]])) === 1'b0) ? 0:1;
        wait_n[9] = ((frameo_nt[address[9]] & frameo_n[address[9]]) | getheader_n[9] | wait_n[9] | !running[9])&(!wait_n[9] | frameo_nt[address[9]] | getheader_n[9] | !running[9]);
        frameo_nt[address[9]] = ((wait_n[9] & ~(frameo_n[address[9]] ^ frameo_nt[address[9]])) & (!getheader_n[9]))? frame_n[9]: frameo_nt[address[9]];
        running[9] = (((~wait_n[9]) | (frameo_nt[address[9]])) === 1'b0) ? 0:1;
        wait_n[10] = ((frameo_nt[address[10]] & frameo_n[address[10]]) | getheader_n[10] | wait_n[10] | !running[10])&(!wait_n[10] | frameo_nt[address[10]] | getheader_n[10] | !running[10]);
        frameo_nt[address[10]] = ((wait_n[10] & ~(frameo_n[address[10]] ^ frameo_nt[address[10]])) & (!getheader_n[10]))? frame_n[10]: frameo_nt[address[10]];
        running[10] = (((~wait_n[10]) | (frameo_nt[address[10]])) === 1'b0) ? 0:1;
        wait_n[11] = ((frameo_nt[address[11]] & frameo_n[address[11]]) | getheader_n[11] | wait_n[11] | !running[11])&(!wait_n[11] | frameo_nt[address[11]] | getheader_n[11] | !running[11]);
        frameo_nt[address[11]] = ((wait_n[11] & ~(frameo_n[address[11]] ^ frameo_nt[address[11]])) & (!getheader_n[11]))? frame_n[11]: frameo_nt[address[11]];
        running[11] = (((~wait_n[11]) | (frameo_nt[address[11]])) === 1'b0) ? 0:1;
        wait_n[12] = ((frameo_nt[address[12]] & frameo_n[address[12]]) | getheader_n[12] | wait_n[12] | !running[12])&(!wait_n[12] | frameo_nt[address[12]] | getheader_n[12] | !running[12]);
        frameo_nt[address[12]] = ((wait_n[12] & ~(frameo_n[address[12]] ^ frameo_nt[address[12]])) & (!getheader_n[12]))? frame_n[12]: frameo_nt[address[12]];
        running[12] = (((~wait_n[12]) | (frameo_nt[address[12]])) === 1'b0) ? 0:1;
        wait_n[13] = ((frameo_nt[address[13]] & frameo_n[address[13]]) | getheader_n[13] | wait_n[13] | !running[13])&(!wait_n[13] | frameo_nt[address[13]] | getheader_n[13] | !running[13]);
        frameo_nt[address[13]] = ((wait_n[13] & ~(frameo_n[address[13]] ^ frameo_nt[address[13]])) & (!getheader_n[13]))? frame_n[13]: frameo_nt[address[13]];
        running[13] = (((~wait_n[13]) | (frameo_nt[address[13]])) === 1'b0) ? 0:1;
        wait_n[14] = ((frameo_nt[address[14]] & frameo_n[address[14]]) | getheader_n[14] | wait_n[14] | !running[14])&(!wait_n[14] | frameo_nt[address[14]] | getheader_n[14] | !running[14]);
        frameo_nt[address[14]] = ((wait_n[14] & ~(frameo_n[address[14]] ^ frameo_nt[address[14]])) & (!getheader_n[14]))? frame_n[14]: frameo_nt[address[14]];
        running[14] = (((~wait_n[14]) | (frameo_nt[address[14]])) === 1'b0) ? 0:1;
        wait_n[15] = ((frameo_nt[address[15]] & frameo_n[address[15]]) | getheader_n[15] | wait_n[15] | !running[15])&(!wait_n[15] | frameo_nt[address[15]] | getheader_n[15] | !running[15]);
        frameo_nt[address[15]] = ((wait_n[15] & ~(frameo_n[address[15]] ^ frameo_nt[address[15]])) & (!getheader_n[15]))? frame_n[15]: frameo_nt[address[15]];
        running[15] = (((~wait_n[15]) | (frameo_nt[address[15]])) === 1'b0) ? 0:1;
        end
        
    end
endmodule
