module immgen(in, immsel, out);
  //ImmSel = 000 ~ I
  //ImmSel = 001 ~ S
  //ImmSel = 010 ~ B
  //ImmSel = 011 ~ U
  //ImmSel = 100 ~ J
  input [24:0] in;
  input [2:0] immsel;
  output reg [31:0] out;
  wire [31:0] s, i, u, b, j;
  assign s = {{20{in[24]}}, {in[24:18], in[4:0]}};
  assign i = {{20{in[24]}}, {in[24:13]}};
  assign u = {in[24:5], {12{1'b0}}};
  assign b = {{18{in[24]}}, in[24], in[0], in[23:18], in[4:1], 1'b0};
  assign j = {{12{in[24]}}, in[24],in[12:5], in[13], in[23:14], 1'b0};
  always @(*) begin
      case (immsel)
        3'b000: out = i;
        3'b001: out = s;
        3'b010: out = b;
        3'b011: out = u;
        3'b100: out = j;
        default: out = 32'h0;
        endcase
    end
endmodule


