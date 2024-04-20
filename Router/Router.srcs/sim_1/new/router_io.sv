`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 11:07:20 PM
// Design Name: 
// Module Name: router_io
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


interface router_io(input bit SystemClock);
    logic reset_n;
    logic [15:0] din;
    logic [15:0] frame_n;
    logic [15:0] valid_n;
    logic [15:0] dout;
    logic [15:0] busy_n;
    logic [15:0] valido_n;
    logic [15:0] frameo_n;
    clocking cb @(posedge SystemClock);
        default input #1ns output #1ns;
        output reset_n;
        output din;
        output frame_n;
        output valid_n;
        input dout;
        input busy_n;
        input valido_n;
        input frameo_n;
    endclocking
    clocking cb_dut @(posedge SystemClock);
        default input #1ns output #1ns;
        input reset_n;
        input din;
        input frame_n;
        input valid_n;
        output dout;
        output busy_n;
        output valido_n;
        output frameo_n;
    endclocking
    modport TB(clocking cb, output reset_n, input SystemClock);
    modport dut(clocking cb_dut, input reset_n, input SystemClock);
endinterface
