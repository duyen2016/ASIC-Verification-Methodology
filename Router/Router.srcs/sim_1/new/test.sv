`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 11:29:18 PM
// Design Name: 
// Module Name: test
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


program automatic test (router_io.TB rtr_io);
    initial begin
        reset();
    end
    initial forever begin
        #1 rtr_io.clk = 1'b0;
        #1 rtr_io.clk = 1'b1;
    end
    task reset();
        rtr_io.reset_n = 1'b0;
        rtr_io.cb.frame_n <=16'hffff;
        rtr_io.cb.valid_n <= ~('b0);
        ##2 rtr_io.cb.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask
endprogram
