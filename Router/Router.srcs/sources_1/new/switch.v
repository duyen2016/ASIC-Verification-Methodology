`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 11:31:22 PM
// Design Name: 
// Module Name: switch
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


module switch(
    input [15:0]din, valid_n, frame_n, wait_n,
    input reset_n, clk, 
    output reg [15:0] dout, valido_n, 
    output [63:0] address,
    output reg [15:0] getheader_n    
    );
    reg [4:0] header [15:0];
    reg [3:0] counter = 15;
    wire [3:0] address_t[15:0];
    assign address = {address_t[15],address_t[14], address_t[13], address_t[12], address_t[11], address_t[10], address_t[9], address_t[8], address_t[7], address_t[6], address_t[5], address_t[4], address_t[3], address_t[2], address_t[1], address_t[0]};
    assign address_t[0] = (!getheader_n[0])? header[0][3:0]:4'bz;
    assign address_t[1] = (!getheader_n[1])? header[1][3:0]:4'bz;
    assign address_t[2] = (!getheader_n[2])? header[2][3:0]:4'bz;
    assign address_t[3] = (!getheader_n[3])? header[3][3:0]:4'bz;
    assign address_t[4] = (!getheader_n[4])? header[4][3:0]:4'bz;
    assign address_t[5] = (!getheader_n[5])? header[5][3:0]:4'bz;
    assign address_t[6] = (!getheader_n[6])? header[6][3:0]:4'bz;
    assign address_t[7] = (!getheader_n[7])? header[7][3:0]:4'bz;
    assign address_t[8] = (!getheader_n[8])? header[8][3:0]:4'bz;
    assign address_t[9] = (!getheader_n[9])? header[9][3:0]:4'bz;
    assign address_t[10] = (!getheader_n[10])? header[10][3:0]:4'bz;
    assign address_t[11] = (!getheader_n[11])? header[11][3:0]:4'bz;
    assign address_t[12] = (!getheader_n[12])? header[12][3:0]:4'bz;
    assign address_t[13] = (!getheader_n[13])? header[13][3:0]:4'bz;
    assign address_t[14] = (!getheader_n[14])? header[14][3:0]:4'bz;
    assign address_t[15] = (!getheader_n[15])? header[15][3:0]:4'bz;
    always @(posedge clk) begin
        counter = counter + 1; 
        if (!reset_n) begin
            valido_n = 16'b1;
            {header[0],header[1],header[2],header[3],header[4],header[5],header[6],header[7],header[8],header[9],header[10],header[11],header[12],header[13],header[14],header[15]} = {16{5'b11110}};
            counter = 0;
        end
        else if (counter < 15) begin
            counter = counter + 1;
            valido_n = 16'b1;
            {header[0],header[1],header[2],header[3],header[4],header[5],header[6],header[7],header[8],header[9],header[10],header[11],header[12],header[13],header[14],header[15]} = {16{5'b11110}};
        end 
        else begin
            getheader_n[0] = header[4][0];
            header[0] = (getheader_n[0])? {header[0], din[0]}:header[0];
            getheader_n[1] = header[4][1];
            header[1] = (getheader_n[1])? {header[1][3:0], din[1]}:header[1];
            getheader_n[2] = header[4][2];
            header[2] = (getheader_n[2])? {header[2][3:0], din[2]}:header[2];
            getheader_n[3] = header[4][3];
            header[3] = (getheader_n[3])? {header[3][3:0], din[3]}:header[3];
            getheader_n[4] = header[4][4];
            header[4] = (getheader_n[4])? {header[4][3:0], din[4]}:header[4];
            getheader_n[5] = header[4][5];
            header[5] = (getheader_n[5])? {header[5][3:0], din[5]}:header[5];
            getheader_n[6] = header[4][6];
            header[6] = (getheader_n[6])? {header[6][3:0], din[6]}:header[6];
            getheader_n[7] = header[4][7];
            header[7] = (getheader_n[7])? {header[7][3:0], din[7]}:header[7];
            getheader_n[8] = header[4][8];
            header[8] = (getheader_n[8])? {header[8][3:0], din[8]}:header[8];
            getheader_n[9] = header[4][9];
            header[9] = (getheader_n[9])? {header[9][3:0], din[9]}:header[9];
            getheader_n[10] = header[4][10];
            header[10] = (getheader_n[10])? {header[10][3:0], din[10]}:header[10];
            getheader_n[11] = header[4][11];
            header[11] = (getheader_n[11])? {header[11][3:0], din[11]}:header[11];
            getheader_n[12] = header[4][12];
            header[12] = (getheader_n[12])? {header[12][3:0], din[12]}:header[12];
            getheader_n[13] = header[4][13];
            header[13] = (getheader_n[13])? {header[13][3:0], din[13]}:header[13];
            getheader_n[14] = header[4][14];
            header[14] = (getheader_n[14])? {header[14][3:0], din[14]}:header[14];
            getheader_n[15] = header[4][15];
            header[15] = (getheader_n[15])? {header[15][3:0], din[15]}:header[15];
            getheader_n[16] = header[4][16];
            header[16] = (getheader_n[16])? {header[16][3:0], din[16]}:header[16];
            if (!wait_n[0] && (!getheader_n[0])) begin
                valido_n[address_t[0]] = valid_n[0];
                dout[address_t[0]] = din[0];
            end
            if (!wait_n[1] && (!getheader_n[1])) begin
                valido_n[address_t[1]] = valid_n[1];
                dout[address_t[1]] = din[1];
            end
            if (!wait_n[2] && (!getheader_n[2])) begin
                valido_n[address_t[2]] = valid_n[2];
                dout[address_t[2]] = din[2];
            end
            if (!wait_n[3] && (!getheader_n[3])) begin
                valido_n[address_t[3]] = valid_n[3];
                dout[address_t[3]] = din[3];
            end
            if (!wait_n[4] && (!getheader_n[4])) begin
                valido_n[address_t[4]] = valid_n[4];
                dout[address_t[4]] = din[4];
            end
            if (!wait_n[5] && (!getheader_n[5])) begin
                valido_n[address_t[5]] = valid_n[5];
                dout[address_t[5]] = din[5];
            end
            if (!wait_n[6] && (!getheader_n[6])) begin
                valido_n[address_t[6]] = valid_n[6];
                dout[address_t[6]] = din[6];
            end
            if (!wait_n[7] && (!getheader_n[7])) begin
                valido_n[address_t[7]] = valid_n[7];
                dout[address_t[7]] = din[7];
            end
            if (!wait_n[8] && (!getheader_n[8])) begin
                valido_n[address_t[8]] = valid_n[8];
                dout[address_t[8]] = din[8];
            end
            if (!wait_n[9] && (!getheader_n[9])) begin
                valido_n[address_t[9]] = valid_n[9];
                dout[address_t[9]] = din[9];
            end
            if (!wait_n[10] && (!getheader_n[10])) begin
                valido_n[address_t[10]] = valid_n[10];
                dout[address_t[10]] = din[10];
            end
            if (!wait_n[11] && (!getheader_n[11])) begin
                valido_n[address_t[11]] = valid_n[11];
                dout[address_t[11]] = din[11];
            end
            if (!wait_n[12] && (!getheader_n[12])) begin
                valido_n[address_t[12]] = valid_n[12];
                dout[address_t[12]] = din[12];
            end
            if (!wait_n[13] && (!getheader_n[13])) begin
                valido_n[address_t[13]] = valid_n[13];
                dout[address_t[13]] = din[13];
            end
            if (!wait_n[14] && (!getheader_n[14])) begin
                valido_n[address_t[14]] = valid_n[14];
                dout[address_t[14]] = din[14];
            end
            if (!wait_n[15] && (!getheader_n[15])) begin
                valido_n[address_t[15]] = valid_n[15];
                dout[address_t[15]] = din[15];
            end
        end
    end
endmodule
