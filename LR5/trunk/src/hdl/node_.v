module node_
#(
  parameter W_WIDTH  = 8,
  parameter X_WIDTH  = 8,
  parameter SI_WIDTH = 8,
  parameter SO_WIDTH = 17
)
(
  input                  clk_i,
  input                  rst_i,
  input   [W_WIDTH -1:0] weight_i,
  input   [SI_WIDTH-1:0] psumm_i,
  input   [X_WIDTH -1:0] x_i,
  output  [SO_WIDTH-1:0] psumm_o,
  output  [X_WIDTH -1:0] x_o
);
syst_node #(
  .W_WIDTH(W_WIDTH),
  .X_WIDTH(X_WIDTH),
  .SI_WIDTH(SI_WIDTH),
  .SO_WIDTH(SO_WIDTH)
) syst_node_instance(
  .clk_i(clk_i),
  .rst_i(rst_i),
  .weight_i(weight_i),
  .psumm_i(psumm_i),
  .x_i(x_i),
  .psumm_o(psumm_o),
  .x_o(x_o)
);
endmodule : wrapper_sys_node_11
