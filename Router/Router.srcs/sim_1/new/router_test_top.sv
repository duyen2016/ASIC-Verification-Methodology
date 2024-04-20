`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 11:37:44 PM
// Design Name: 
// Module Name: router_test_top
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


module router_test_top();

    parameter simulation_cycle = 100;
    bit SystemClock;
    router_io top_io(SystemClock);
    testwithclass router_test(top_io);
    router dut(.din(top_io.din), 
                .valid_n(top_io.valid_n), 
                .frame_n(top_io.frame_n), 
                .busy_n(top_io.busy_n),
                .reset_n(top_io.reset_n), 
                .clk(top_io.SystemClock),
                .dout(top_io.dout), 
                .valido_n(top_io.valido_n), 
                .frameo_n(top_io.frameo_n)); 
    initial begin
        SystemClock = 0;
        forever begin
            #(simulation_cycle/2)
            SystemClock = ~SystemClock;
            end
    end            
endmodule
