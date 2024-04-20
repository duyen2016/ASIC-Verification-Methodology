`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 09:16:50 PM
// Design Name: 
// Module Name: testwithclass
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

class packet;
    randc logic [7:0] payload;
    rand logic [3:0] da;
    bit d;
    bit valid;
    bit frame;
    bit busy_n;
    bit last_bit;
    function new ();
        this.valid = 1'b1;
        this.frame = 1'b1;
        this.last_bit = 1'b0;
        this.d = 1'bx;
        this.busy_n = 1'b1;
    endfunction: new
    task display();
        $display("payload: %h", payload);
        $display("da: %h", da);
    endtask: display
endclass: packet

class gen;
    packet pkt;
    function new();
        pkt = new();
    endfunction:new
    task gen_plda();
        pkt = new();
        pkt.randomize();
        $display("This packet generated with values: ");
        pkt.display();
    endtask:gen_plda
endclass: gen
class driver;
    packet pkt;
//    static router_io rtr_io;
    logic [3:0] da;
    logic [7:0] payload;
    task setrtrio(virtual router_io.TB rtr_io);
        pkt.busy_n = rtr_io.cb.busy_n;
    endtask: setrtrio
    function new();
        pkt = new();
    endfunction:new
    task setpacket(packet pkt);
        this.pkt = pkt;
    endtask: setpacket
    task sendaddress(int i, virtual router_io rtr_io);
        this.da = pkt.da;
        pkt.frame = 1'b0;
        rtr_io.frame_n[i] = pkt.frame;
        repeat(4) begin
            rtr_io.din[i] = this.da[0];
            this.da = {1'b0, this.da[3:1]};
            @(posedge rtr_io.SystemClock);
        end
        pkt.valid = 1'b1;
        rtr_io.valid_n[i] <= pkt.valid; 
        repeat (2) @(posedge rtr_io.SystemClock);   
    endtask: sendaddress
    task sendpadding(int i, virtual router_io rtr_io);
        while (pkt.valid) begin
            pkt.valid = (((rtr_io.busy_n[i] === 1'b0)|| (pkt.frame !== 1'b0))) ? 1 : 0;
            rtr_io.valid_n[i] = pkt.valid;
            @(posedge rtr_io.SystemClock);
        end
    endtask: sendpadding  
    task sendpayload(int i, virtual router_io rtr_io);
        int counter = 0;
        this.payload = pkt.payload;
        while (counter <= 7) begin
            pkt.last_bit = 0;   
            pkt.valid = 1'b0;
            rtr_io.valid_n[i] = pkt.valid;
            if (counter < 7 ) begin
                pkt.frame = 1'b0;
                if (~pkt.valid)
                    begin
                        rtr_io.din[i] = this.payload[0];
                        this.payload = this.payload>>1; 
                        counter = counter + 1;
                    end
                else rtr_io.din[i] = 1'bx;
                end
            else if (counter == 7)begin
                pkt.last_bit = 1;
                pkt.frame = 1'b1;
                rtr_io.din[i] = this.payload[0];
                this.payload = 8'bxx;    
                counter = counter + 1;

            end
            rtr_io.frame_n[i] = pkt.frame;
            @(posedge rtr_io.SystemClock);
        end
        pkt.valid = 1'b1;
        rtr_io.valid_n[i] = pkt.valid;
    endtask: sendpayload
    task reset(virtual router_io rtr_io);
        rtr_io.reset_n = 1'b0;
        rtr_io.din = $random;
        rtr_io.frame_n = 16'hffff;
        rtr_io.valid_n = 16'hffff;
        @(posedge rtr_io.SystemClock)
        rtr_io.reset_n = 1'b1;
        repeat(15) @(posedge rtr_io.SystemClock);
    endtask: reset
endclass: driver
class monitor;
    logic [7:0] payload_out[16][$];
    task getpayload(virtual router_io rtr_io);
        logic [7:0] temp[15:0] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0, 0, 0};
        logic [15:0] getting = 0;
        while (1) begin
            foreach (payload_out[i]) begin
                if (rtr_io.frameo_n[i] === 1) begin
                    if ((getting[i] == 1) && (rtr_io.valido_n[i] === 0)) begin
                        temp[i] = {rtr_io.dout[i],temp[i][7:1]};
                        payload_out[i].push_back(temp[i]);
                        temp[i] = 0;
                        getting[i] = 0;
                    end
                    else continue;
                    end
                else if ((rtr_io.valido_n[i] === 0) && (rtr_io.frameo_n[i] === 0)) begin
                    temp[i] = {rtr_io.dout[i],temp[i][7:1]};
                    getting[i] = 1;
                end
                
            end
            @(negedge rtr_io.SystemClock);
        end
     endtask
endclass:monitor

class transactor;
    driver drv[16];
    monitor mnt;
    function new();
        foreach (drv[i])
            drv[i] = new();
        mnt = new();
    endfunction:new
    task sendpacket(int i, virtual router_io rtr_io);
        begin
            drv[i].sendaddress(i, rtr_io);
            drv[i].sendpadding(i, rtr_io);
            drv[i].sendpayload(i, rtr_io);
        end
    endtask: sendpacket
    task send(virtual router_io rtr_io);
        fork
            sendpacket(0, rtr_io);
            sendpacket(1, rtr_io);
            sendpacket(2, rtr_io);
            sendpacket(3, rtr_io);
            sendpacket(4, rtr_io);
            sendpacket(5, rtr_io);
            sendpacket(6, rtr_io);
            sendpacket(7, rtr_io);
            sendpacket(8, rtr_io);
            sendpacket(9, rtr_io);
            sendpacket(10, rtr_io);
            sendpacket(11, rtr_io);
            sendpacket(12, rtr_io);
            sendpacket(13, rtr_io);
            sendpacket(14, rtr_io);
            sendpacket(15, rtr_io);
        join
    endtask
    task receive(virtual router_io rtr_io);
        mnt.getpayload(rtr_io);
    endtask: receive
endclass: transactor


class scoreboard;
    transactor trst;
    function new();
        trst = new();
    endfunction:new
    function int check();
        int acc = 0;
        int dest;
        int plout;
        foreach(trst.drv[i]) begin
            dest = trst.drv[i].pkt.da;
            plout = trst.mnt.payload_out[dest].pop_front();
            if (compare(trst.drv[i].pkt.payload, plout)) begin
                $display("PASS: Got packet, packet in %d, packet out %d!", trst.drv[i].pkt.payload, plout);
                acc = acc + 1;       
                end
            else begin
                $display("FAIL: Missed packet, packet in %d, packet out %d!", trst.drv[i].pkt.payload, plout);
                end
        end
        return acc;
    endfunction: check
    function bit compare(logic [7:0]a, logic [7:0] b);
        if (a == b) return 1;
        else return 0;
    endfunction
endclass:scoreboard


program automatic testwithclass(
    router_io rtr_io
    );
    driver drv = new();
    gen g[16];
    scoreboard check = new();
    int score;
    initial begin
        foreach (g[i]) g[i] = new();
        drv.reset(rtr_io);
        foreach(g[i]) begin
            $display("%d", i);
            g[i].gen_plda();
            check.trst.drv[i].setpacket(g[i].pkt);
        end
        fork
            check.trst.send(rtr_io);
            check.trst.receive(rtr_io);
        join_any 
        score = check.check();
        $display("Score: %d", score);
    end
        
    
endprogram 
