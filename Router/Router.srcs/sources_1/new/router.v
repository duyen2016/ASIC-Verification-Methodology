`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 02:38:34 PM
// Design Name: 
// Module Name: router
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


module router(
    input [15:0] din, valid_n, frame_n,
    input reset_n, clk,
    output [15:0] dout, valido_n, frameo_n, busy_n
    );
    wire [15:0] getheader_n;
    wire [63:0] address;
    arbiter arbiter (
        .address_t(address),
        .getheader_n(getheader_n),
        .frame_n(frame_n),
        .frameo_n(frameo_n),
        .reset_n(reset_n), .clk(clk),
        .wait_n(busy_n)
    ); 
    switch switch (
        .din(din), .valid_n(valid_n), .frame_n(frame_n), .wait_n(busy_n), .frameo_n(frameo_n),
        .reset_n(reset_n), .clk(clk), 
        .dout(dout), .valido_n(valido_n), 
        .address(address),
        .getheader_n(getheader_n)    
    );
endmodule
