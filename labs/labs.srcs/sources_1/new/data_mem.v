module data_mem(
  input         clk,
  input         WE,
  input  [31:0] addr,
  input  [31:0] write_data,
  output [31:0] read_data
);

reg[7:0] RAM[0:1023];


always @(posedge clk) begin
    if(WE) begin
        {RAM[addr+3],RAM[addr+2],RAM[addr+1],RAM[addr]} <= write_data;
    end


end

assign read_data = {RAM[addr+3],RAM[addr+2],RAM[addr+1],RAM[addr]};


endmodule