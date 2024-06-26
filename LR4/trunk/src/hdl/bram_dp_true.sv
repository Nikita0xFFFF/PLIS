module bram_dp_true
  #(
  parameter RAM_WIDTH     = 8,
  parameter RAM_ADDR_BITS = 10
)(
  input  logic                     clk_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_a_i,
  input  logic [RAM_ADDR_BITS-1:0] addr_b_i,
  input  logic [RAM_WIDTH-1:0]     data_a_i,
  input  logic [RAM_WIDTH-1:0]     data_b_i,
  input  logic                     we_a_i,
  input  logic                     we_b_i,
  input  logic                     en_a_i,
  input  logic                     en_b_i,
  input  logic                     rst_i,
  output logic [RAM_WIDTH-1:0]     data_a_o,
  output logic [RAM_WIDTH-1:0]     data_b_o
);

  localparam RAM_DEPTH = 2**RAM_ADDR_BITS;

  logic [RAM_WIDTH-1:0] bram [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data_a_ff;
  logic [RAM_WIDTH-1:0] ram_data_b_ff;
  logic [RAM_WIDTH-1:0] data_a_reg_ff;

  always_ff @(posedge clk_i) begin
    if (rst_i)
      data_a_reg_ff <= {RAM_WIDTH{1'b0}};
    else if (en_a_i)
      data_a_reg_ff <= data_a_i;
  end

  always_ff @(posedge clk_i) begin
    if (en_a_i) begin
      if (we_a_i)
        bram[addr_a_i] <= data_a_reg_ff;
      else
        ram_data_a_ff <= bram[addr_a_i];
    end
  end

  always_ff @(posedge clk_i) begin
    if (en_b_i) begin
      if (we_b_i)
        bram[addr_b_i] <= data_b_i;
      else
        ram_data_b_ff <= bram[addr_b_i];
    end
  end

  assign data_a_o = ram_data_a_ff;
  assign data_b_o = ram_data_b_ff;

endmodule : bram_dp_true
