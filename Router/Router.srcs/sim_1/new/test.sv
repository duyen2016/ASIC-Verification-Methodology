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
        #10 routing();
        #10 arbiter();
    end
    initial forever begin
        #1 rtr_io.clk = 1'b0;
        #1 rtr_io.clk = 1'b1;
    end
    task reset();
        rtr_io.reset_n = 1'b0;
        rtr_io.cb.din <= $random;
        rtr_io.cb.frame_n <=16'hffff;
        rtr_io.cb.valid_n <= ~('b0);
        ##2 rtr_io.cb.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask
    task routing();
        repeat (15) begin
            rtr_io.cb.din <= $urandom;
            rtr_io.cb.valid_n <= ($urandom)|(~rtr_io.cb.busy_n);
            rtr_io.cb.frame_n <= 16'hffef;
            @(posedge rtr_io.clk);
        end
        ##2 rtr_io.cb.frame_n <= 16'hffff;
        ##10 rtr_io.cb.frame_n <= 16'h0000;
        repeat (15) @(rtr_io.cb);
        ##2 rtr_io.cb.frame_n <= 16'hffff;
    endtask
    task arbiter();
        repeat (15) begin
            rtr_io.cb.din <= $urandom;
            rtr_io.cb.valid_n <= ($urandom)|(~rtr_io.cb.busy_n);
            rtr_io.cb.frame_n <= 16'h0000;
            @(posedge rtr_io.clk);
        end
        rtr_io.cb.frame_n <= $urandom;
        ##10 rtr_io.cb.frame_n <= 16'h0000;
        repeat (15) @(rtr_io.cb);
        ##10 rtr_io.cb.frame_n <= 16'hffff;
    endtask
endprogram
