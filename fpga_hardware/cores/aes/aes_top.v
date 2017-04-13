module aes_top(
		 wb_adr_i, wb_bte_i, wb_cti_i, wb_cyc_i, wb_dat_i, wb_sel_i,
		 wb_stb_i, wb_we_i,
		 wb_ack_o, wb_err_o, wb_rty_o, wb_dat_o,
		 wb_clk_i, wb_rst_i
);

   parameter dw = 32;
   parameter aw = 32;

   input [aw-1:0]	wb_adr_i;
   input [1:0] 		wb_bte_i;
   input [2:0] 		wb_cti_i;
   input 		wb_cyc_i;
   input [dw-1:0] 	wb_dat_i;
   input [3:0] 		wb_sel_i;
   input 		wb_stb_i;
   input 		wb_we_i;
   
   output 		wb_ack_o;
   output 		wb_err_o;
   output 		wb_rty_o;
   output [dw-1:0] 	wb_dat_o;
   
   input 		wb_clk_i;
   input 		wb_rst_i;


   assign wb_ack_o = 1'b1;
   assign wb_err_o = 1'b0;
   assign wb_rty_o = 1'b0;

   // Internal registers
   reg start;
   reg [31:0] pt [0:3];
   reg [31:0] key [0:3];

   // Implement MD5 I/O memory map interface
   always @(posedge wb_clk_i) begin
     if(wb_rst_i) begin
       start <= 0;
       pt[0] <= 0;
       pt[1] <= 0;
       pt[2] <= 0;
       pt[3] <= 0;
       key[0] <= 0;
       key[1] <= 0;
       key[2] <= 0;
       key[3] <= 0;
     end
     else if(wb_stb_i & wb_we_i)
       case(wb_adr_i[4:0])
         0: start <= wb_dat_i[0];
         1: pt[3] <= wb_dat_i;
         2: pt[2] <= wb_dat_i;
         3: pt[1] <= wb_dat_i;
         4: pt[0] <= wb_dat_i;
         5: key[3] <= wb_dat_i;
         6: key[2] <= wb_dat_i;
         7: key[1] <= wb_dat_i;
         8: key[0] <= wb_dat_i;
         default: ;
       endcase
     else if(wb_stb_i & ~wb_we_i)
       case(wb_adr_i[4:0])
         0: wb_dat_o <= {31'b0, start};
         1: wb_dat_o <= pt[3];
         2: wb_dat_o <= pt[2];
         3: wb_dat_o <= pt[1];
         4: wb_dat_o <= pt[0];
         5: wb_dat_o <= key[3];
         6: wb_dat_o <= key[2];
         7: wb_dat_o <= key[1];
         8: wb_dat_o <= key[0];
         9: wb_dat_o <= {31'b0, ct_valid};
         10: wb_dat_o <= ct[127:96];
         11: wb_dat_o <= ct[95:64];
         12: wb_dat_o <= ct[63:32];
         13: wb_dat_o <= ct[31:0];
         default: ;
       endcase
   end

  wire [127:0] pt_big = {pt[0], pt[1], pt[2], pt[3]};
  wire [127:0] key_big = {key[0], key[1], key[2], key[3]};
  wire [127:0] ct;
  wire ct_valid;

  aes_128 aes(
    .clk(wb_clk_i),
    .state(pt_big),
    .key(key_big),
    .start(start),
    .out(ct),
    .out_valid(ct_valid)
  );

endmodule