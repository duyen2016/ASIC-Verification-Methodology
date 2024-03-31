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
    logic [7:0] payload[$];
    logic [3:0] da [$];
    initial begin
        reset();
        //#100 routing();
        //#100 arbiter();
        gen();
        send();
    end
    task reset();
        rtr_io.reset_n = 1'b0;
        rtr_io.cb.din <= $random;
        rtr_io.cb.frame_n <=16'hffff;
        rtr_io.cb.valid_n <= ~('b0);
        ##10 rtr_io.cb.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask
    task routing();
        repeat (15) begin
            rtr_io.cb.din <= $urandom;
            rtr_io.cb.valid_n <= ($urandom)|(~rtr_io.cb.busy_n);
            rtr_io.cb.frame_n <= 16'hffef;
            @(posedge rtr_io.SystemClock);
        end
        ##200 rtr_io.cb.frame_n <= 16'hffff;
        ##100 rtr_io.cb.frame_n <= 16'h0000;
        repeat (15) @(rtr_io.cb);
        ##200 rtr_io.cb.frame_n <= 16'hffff;
    endtask
    task arbiter();
        repeat (15) begin
            rtr_io.cb.din <= $urandom;
            rtr_io.cb.valid_n <= ($urandom)|(~rtr_io.cb.busy_n);
            rtr_io.cb.frame_n <= 16'h0000;
            @(posedge rtr_io.SystemClock);
        end
        rtr_io.cb.frame_n <= $urandom;
        ##100 rtr_io.cb.frame_n <= 16'h0000;
        repeat (15) @(rtr_io.cb);
        ##100 rtr_io.cb.frame_n <= 16'hffff;
    endtask
    
    task gen();
        payload.delete();
        da.delete();
        repeat (16) begin
            payload.push_back($urandom);
            da.push_back($urandom);
        end
    endtask
    task send();
        fork
            sendaddress();
            $display("%p",da);
        join
    endtask
    
    task sendaddress();
        logic [3:0] local_da[$];
        local_da = da;
        repeat(4) begin
            foreach (local_da[i]) begin
                rtr_io.cb.din[i] <= local_da[i][0];
                local_da[i] = local_da[i]>>1;
                end
            rtr_io.cb.frame_n <= 16'h0000;
            @(rtr_io.cb);
        end    
    endtask
    task sendpadding();
    endtask
endprogram








