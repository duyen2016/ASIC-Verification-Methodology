`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 07:41:03 AM
// Design Name: 
// Module Name: yourcpu_test_top
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


module yourcpu_test_top;
    parameter simulation_cycle = 100;
    bit SystemClock;
    yourcpu_io cpu_io(SystemClock);
    test t(cpu_io);
    processor dut (
        .clk(cpu_io.clock), 
        .rst(cpu_io.reset), 
        .loadIM(cpu_io.loadIM), 
        .addr(cpu_io.addr), 
        .data(cpu_io.data)
        );
    initial begin
        SystemClock = 0;
        forever begin
            #(simulation_cycle/2)
            SystemClock=~SystemClock;
        end
    end
endmodule
