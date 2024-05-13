`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2024 11:52:24 PM
// Design Name: 
// Module Name: yourcpu_io
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


interface yourcpu_io( input bit clock);
    logic reset;
    logic loadIM;
    logic [31:0] addr;
    logic [31:0] data;
    clocking cb @(posedge clock);
        default input #1ns output #1ns;
        output loadIM;
        output addr;
        output data;
    endclocking
    modport TB(clocking cb, output reset);
endinterface
