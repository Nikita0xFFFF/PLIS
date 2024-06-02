`timescale 1ns / 1ps
import crc_pkg::*;
module wrapper_crc8
(
  input  logic        p_clk_i,
  input  logic        p_rst_i,
  input  logic [31:0] p_dat_i,
  output logic [31:0] p_dat_o,
  input  logic        p_sel_i,
  input  logic        p_enable_i,
  input  logic        p_we_i,
  input  logic [31:0] p_adr_i,
  output logic        p_ready,
  output logic        p_slverr
);

  logic [7:0] din_i;
  logic [1:0] state;

  logic [7:0] crc8_o;
  logic       crc8_rd;
  logic       data_valid_crc8_i;

  logic [7:0] crc15_o;
  logic       crc15_rd;
  logic       data_valid_crc15_i;



  assign p_slverr = 1'b0;
  localparam IDLE = 2'b00;
  localparam CRC8 = 2'b01;
  localparam CRC15 = 2'b10;
  crc15 crc15_instance(
    .clk_i(p_clk_i),
    .rst_i(p_rst_i),
    .din_i(din_i),
    .data_valid_i(data_valid_crc15_i),
    .crc_rd(crc15_rd),
    .crc_o(crc15_o)
  );
  crc8 crc8_instance(
    .clk_i(p_clk_i),
    .rst_i(p_rst_i),
    .din_i(din_i),
    .data_valid_i(data_valid_crc8_i),
    .crc_rd(crc8_rd),
    .crc_o(crc8_o)
  );
  logic cs_1_ff;
  logic cs_2_ff;

  logic cs_ack1_ff;
  logic cs_ack2_ff;

  always_ff @ (posedge p_clk_i)
  begin
    cs_1_ff <= p_enable_i & p_sel_i;
    cs_2_ff <= cs_1_ff;
  end

  logic cs;
  assign cs = cs_1_ff & (~cs_2_ff);

  always_ff @ (posedge p_clk_i)
  begin
    cs_ack1_ff <= cs_2_ff;
    cs_ack2_ff <= cs_ack1_ff;
  end

  // Generating acknowledge signal
  logic p_ready_ff;

  always_ff @ (posedge p_clk_i)
  begin
    p_ready_ff <= (cs_ack1_ff & (~cs_ack2_ff));
  end

  assign p_ready = p_ready_ff;

  always_comb
  begin
    if(p_rst_i)begin //TODO
      p_dat_o = '0;
      state   = IDLE;
      din_i   = 0;
      data_valid_crc15_i = 0;
      data_valid_crc8_i  = 0;
      crc15_rd = 0;
      crc8_rd  = 0;
      crc8_o   = 0;
      crc15_o  = 0;
    end
    else begin
      case(state)
        IDLE:
        if (p_adr_i == write_crc8 || p_adr_i == read_crc8 ) begin
          state = CRC8;
        end
        else if (p_adr_i == write_crc15 || p_adr_i == read_crc15 ) begin
          state = CRC15;
        end
        else begin
          state = IDLE;
          end
        CRC8:
        begin
          data_valid_crc8_i = (cs & p_we_i & p_adr_i[3:0]  == write_crc8[3:0]);
          din_i        = (cs & p_we_i & p_adr_i[3:0]  == write_crc8[3:0]) ? p_dat_i[7:0]: 8'd0;
          crc8_rd       = (cs & ~p_we_i & p_adr_i[3:0] == read_crc8[3:0]);
          state        = IDLE;
        end
        CRC15:
        begin
          data_valid_crc15_i = (cs & p_we_i & p_adr_i[3:0]  == write_crc15[3:0]);
          din_i        = (cs & p_we_i & p_adr_i[3:0]  == write_crc15[3:0]) ? p_dat_i[7:0]: 8'd0;
          crc15_rd       = (cs & ~p_we_i & p_adr_i[3:0] == read_crc15[3:0]);
          state        = IDLE;
        end
      endcase
    end
    if (cs & (~p_we_i) & (p_adr_i[3:0] == read_crc8[3:0]))
      p_dat_o = {24'd0, crc8_o};
    else if (cs & (~p_we_i)& (p_adr_i[3:0] == read_crc15[3:0]))
      p_dat_o = {24'd0, crc15_o};
  end

  //  assign data_valid_i = (cs & p_we_i & p_adr_i[3:0]  == 4'd0);
  //  assign din_i        = (cs & p_we_i & p_adr_i[3:0]  == 4'd0) ? p_dat_i[7:0]: 8'd0;
  //  assign crc_rd       = (cs & ~p_we_i & p_adr_i[3:0] == 4'd4);

endmodule
