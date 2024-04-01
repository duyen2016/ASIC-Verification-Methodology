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
    logic [7:0] payload_out[16][$];
    logic [3:0] da [$];
    logic [15:0] valid_n; 
    logic [15:0] frame_n;
    logic [15:0] last_bit;
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
        frame_n = 16'hffff;
        rtr_io.cb.frame_n <= frame_n;
        valid_n = ~('b0);
        rtr_io.cb.valid_n <= valid_n;
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
        begin
            sendaddress();
            $display("%p",da);
            fork
                sendpadding();
                sendpayload();
                getpayload();
                #7000;
            join_any
            disable fork;
            self_check();
        end
    endtask
    
    task sendaddress();
        logic [3:0] local_da[$];
        local_da = da;
        repeat(4) begin
            foreach (local_da[i]) begin
                rtr_io.cb.din[i] <= local_da[i][0];
                local_da[i] = local_da[i]>>1;
                end
            frame_n = 16'h0000;
            rtr_io.cb.frame_n <= frame_n;
            @(rtr_io.cb);
        end
        valid_n = 16'hffff;
        rtr_io.cb.valid_n <= valid_n; 
        repeat (2) @(rtr_io.cb);   
    endtask
    task sendpadding();
        int y;
        while (1) begin
            foreach (valid_n[x]) begin
                y = da[x];
                valid_n[x] = (((rtr_io.cb.busy_n[x] === 1'b0)|| (frame_n[x] !== 1'b0))) ? 1 : 0;
                if (last_bit[x] === 1) valid_n[x] = 0;
                //valid_n[i] = (rtr_io.cb.frameo_n[da[i]] === 1'b1)? 1
                //$display("%p", da[i]);
                $display("%b", last_bit);
                last_bit[x] = 0;
            end
            @(rtr_io.cb);
        end
    endtask
    
    task sendpayload();
        logic [7:0] local_payload [$];
        int counter[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        local_payload = payload;
        while (1) begin
            last_bit = 0;
            foreach (payload[i]) begin           
                $display("%b, %d", local_payload[i], i);
                if (counter[i] < 7 ) begin
                    if (~valid_n[i])
                        begin
                            rtr_io.cb.din[i] <= local_payload[i][0];
                            local_payload[i] = local_payload[i]>>1; 
                            counter[i] = counter[i] + 1;
                            //if ((local_payload[i] == 8'h01) || (local_payload[i] == 8'h00)) last_bit[i] = 1;   
                        end
                    else rtr_io.cb.din[i] <= 1'bx;
                    rtr_io.cb.valid_n[i] <= valid_n[i];
                    end
                else begin
                    last_bit[i] = 1;
                    frame_n[i] = 1'b1;
                    rtr_io.cb.frame_n[i] <= frame_n[i];
                    rtr_io.cb.din[i] <= local_payload[i][0];
                    local_payload[i] = 8'bxx;    
                    counter[i] = 0;
                    //@(rtr_io.cb);
                    //valid_n[i] = 1'b1;
                    //rtr_io.cb.valid_n[i] <= valid_n[i];
                end
                end
            @(rtr_io.cb);
        end
     endtask
     
     task getpayload();
        int dest;
        logic [7:0] temp[15:0] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 0, 0};
        logic [15:0] getting = 0;
        while (1) begin
            foreach (payload_out[i]) begin
                if (rtr_io.cb.frameo_n[i] === 1) begin
                    if ((getting[i] == 1) && (rtr_io.cb.valido_n[i] === 0)) begin
                        temp[i] = {rtr_io.cb.dout[i],temp[i][7:1]};
                        payload_out[i].push_back(temp[i]);
                        temp[i] = 0;
                        getting[i] = 0;
                        $display("push");
                        $display("%t, dout %d, %b , %h",$time, i, rtr_io.cb.dout[i], temp[i]);
                    end
                    else continue;
                    end
                else if ((rtr_io.cb.valido_n[i] === 0) && (rtr_io.cb.frameo_n[i] === 0)) begin
                    temp[i] = {rtr_io.cb.dout[i],temp[i][7:1]};
                    getting[i] = 1;
                    $display("%t, dout %d, %b, %h ",$time, i, rtr_io.cb.dout[i], temp[i]);
                end
                
            end
            @(rtr_io.cb);
        end
     endtask
    task self_check();
        int acc = 0;
        int dest;
        foreach(payload[i]) begin
            dest = da[i];
            if (compare(payload[i], payload_out[dest].pop_front())) acc = acc +1;
        end
        $display("Accuracy: %d/16", acc);
    endtask
    
    function bit compare(logic [7:0]a, logic [7:0] b);
        if (a == b) return 1;
        else return 0;
    endfunction
endprogram








