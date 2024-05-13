module imem(clk, loadIM, Address, data, InstCode);
  input clk, loadIM;
  input [31:0]Address, data;
  output reg [31:0]InstCode;
  parameter [31:0]range = 32'h07ffffff;
  reg [7:0] imem_cell [range:0];
  always @(posedge clk) begin
    if (loadIM) begin
        imem_cell[Address] = data[31:24];
        imem_cell[Address+1] = data[23:16];
        imem_cell[Address+2] = data[15:8];
        imem_cell[Address+3] = data[7:0];
        end 
  end
  always @(Address or imem_cell[ Address]) begin
      InstCode[7:0] = imem_cell[Address+3];
      InstCode[15:8] = imem_cell[Address+2];
      InstCode[23:16] = imem_cell[Address+1]; 
      InstCode[31:24] = imem_cell[Address]; 
    end
endmodule

