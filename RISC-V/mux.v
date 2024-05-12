module mux(sel, in0, in1, s);
  input sel;
  input [31:0] in0, in1;
  output [31:0] s;
    assign s = (sel) ? in1 : in0;
endmodule
