import mms_pkg::*;
module plru_32(
        input logic rstn_i,clk_i,
        input logic [`TLB_ENTRY_SIZE - 1 : 0] entry_valid_i,
        input logic [`TLB_ENTRY_SIZE - 1 : 0] itlb_rd_hit_i,
        input logic itlb_hit_vld_i,
        input logic itlb_refill_rq_i,//request to the update the Refill location
        input logic itlb_refill_vld_i,
        output logic [`TLB_ENTRY_SIZE - 1 : 0] itlb_refill_onehot_o
    );//for tlb

    /*@WAVEDROM_START
     { signal: [
     { name: "clk_i",  wave: "p.......p"},
     { name: "itlb_refill_rq_i", wave: "0100000",
     data: ["q", "b", "c", "d"],
     },
     { name:"itlb_refill_one_hot_o",wave:"234...",
     data:["NA","NA","S"]
     }

     ]
     }
     @WAVEDROM_END */

    struct packed {
        logic p0;
        logic [1:0] p1;
        logic [3:0] p2;
        logic [7:0] p3;
        logic [15:0] p4;
    } plru_q,plru_d_refill,plru_d_hit;

    logic [$clog2(`TLB_ENTRY_SIZE) - 1 : 0 ] write_index,hit_index_d,hit_index_q,refill_index,plru_index;
    logic hit_updt_en;
    logic wr_updt_en;


    assign wr_updt_en = itlb_refill_vld_i;

    always_comb  begin:init_refill_write_update
        unique casez(entry_valid_i)
            32'b???????????????????????????????0: write_index[4:0] = 5'b00000;
            32'b??????????????????????????????01: write_index[4:0] = 5'b00001;
            32'b?????????????????????????????011: write_index[4:0] = 5'b00010;
            32'b????????????????????????????0111: write_index[4:0] = 5'b00011;
            32'b???????????????????????????01111: write_index[4:0] = 5'b00100;
            32'b??????????????????????????011111: write_index[4:0] = 5'b00101;
            32'b?????????????????????????0111111: write_index[4:0] = 5'b00110;
            32'b????????????????????????01111111: write_index[4:0] = 5'b00111;
            32'b???????????????????????011111111: write_index[4:0] = 5'b01000;
            32'b??????????????????????0111111111: write_index[4:0] = 5'b01001;
            32'b?????????????????????01111111111: write_index[4:0] = 5'b01010;
            32'b????????????????????011111111111: write_index[4:0] = 5'b01011;
            32'b???????????????????0111111111111: write_index[4:0] = 5'b01100;
            32'b??????????????????01111111111111: write_index[4:0] = 5'b01101;
            32'b?????????????????011111111111111: write_index[4:0] = 5'b01110;
            32'b????????????????0111111111111111: write_index[4:0] = 5'b01111;
            32'b???????????????01111111111111111: write_index[4:0] = 5'b10000;
            32'b??????????????011111111111111111: write_index[4:0] = 5'b10001;
            32'b?????????????0111111111111111111: write_index[4:0] = 5'b10010;
            32'b????????????01111111111111111111: write_index[4:0] = 5'b10011;
            32'b???????????011111111111111111111: write_index[4:0] = 5'b10100;
            32'b??????????0111111111111111111111: write_index[4:0] = 5'b10101;
            32'b?????????01111111111111111111111: write_index[4:0] = 5'b10110;
            32'b????????011111111111111111111111: write_index[4:0] = 5'b10111;
            32'b???????0111111111111111111111111: write_index[4:0] = 5'b11000;
            32'b??????01111111111111111111111111: write_index[4:0] = 5'b11001;
            32'b?????011111111111111111111111111: write_index[4:0] = 5'b11010;
            32'b????0111111111111111111111111111: write_index[4:0] = 5'b11011;
            32'b???01111111111111111111111111111: write_index[4:0] = 5'b11100;
            32'b??011111111111111111111111111111: write_index[4:0] = 5'b11101;
            32'b?0111111111111111111111111111111: write_index[4:0] = 5'b11110;
            32'b01111111111111111111111111111111: write_index[4:0] = 5'b11111;
            32'b11111111111111111111111111111111: write_index[4:0] = plru_index[4:0];
            default:                              write_index[4:0] = 5'b0;
        endcase
    end

// @DVT_EXPAND_MACRO_INLINE_START
// `D_FLIP_FLOP (refill_Index_Register, clk_i, rstn_i, write_index, refill_index,itlb_refill_rq_i);
// @DVT_EXPAND_MACRO_INLINE_ORIGINAL

    always_ff @(posedge clk_i or negedge rstn_i) begin:refill_Index_Register
        if (!rstn_i) begin
            refill_index <= 'b0;
        end else if(itlb_refill_rq_i) begin
            refill_index <= write_index;
        end
    end;
// @DVT_EXPAND_MACRO_INLINE_END

    // decode the index to Onhe hot signal
    always_comb begin:refill_index2onehot
        unique case(refill_index[4:0])
            5'h00: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000000001;
            5'h01: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000000010;
            5'h02: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000000100;
            5'h03: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000001000;
            5'h04: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000010000;
            5'h05: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000000100000;
            5'h06: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000001000000;
            5'h07: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000010000000;
            5'h08: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000000100000000;
            5'h09: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000001000000000;
            5'h0a: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000010000000000;
            5'h0b: itlb_refill_onehot_o[31:0] = 32'b00000000000000000000100000000000;
            5'h0c: itlb_refill_onehot_o[31:0] = 32'b00000000000000000001000000000000;
            5'h0d: itlb_refill_onehot_o[31:0] = 32'b00000000000000000010000000000000;
            5'h0e: itlb_refill_onehot_o[31:0] = 32'b00000000000000000100000000000000;
            5'h0f: itlb_refill_onehot_o[31:0] = 32'b00000000000000001000000000000000;
            5'h10: itlb_refill_onehot_o[31:0] = 32'b00000000000000010000000000000000;
            5'h11: itlb_refill_onehot_o[31:0] = 32'b00000000000000100000000000000000;
            5'h12: itlb_refill_onehot_o[31:0] = 32'b00000000000001000000000000000000;
            5'h13: itlb_refill_onehot_o[31:0] = 32'b00000000000010000000000000000000;
            5'h14: itlb_refill_onehot_o[31:0] = 32'b00000000000100000000000000000000;
            5'h15: itlb_refill_onehot_o[31:0] = 32'b00000000001000000000000000000000;
            5'h16: itlb_refill_onehot_o[31:0] = 32'b00000000010000000000000000000000;
            5'h17: itlb_refill_onehot_o[31:0] = 32'b00000000100000000000000000000000;
            5'h18: itlb_refill_onehot_o[31:0] = 32'b00000001000000000000000000000000;
            5'h19: itlb_refill_onehot_o[31:0] = 32'b00000010000000000000000000000000;
            5'h1a: itlb_refill_onehot_o[31:0] = 32'b00000100000000000000000000000000;
            5'h1b: itlb_refill_onehot_o[31:0] = 32'b00001000000000000000000000000000;
            5'h1c: itlb_refill_onehot_o[31:0] = 32'b00010000000000000000000000000000;
            5'h1d: itlb_refill_onehot_o[31:0] = 32'b00100000000000000000000000000000;
            5'h1e: itlb_refill_onehot_o[31:0] = 32'b01000000000000000000000000000000;
            5'h1f: itlb_refill_onehot_o[31:0] = 32'b10000000000000000000000000000000;
        endcase
    end
    //**************init or write stage update */

    //start: hit stage

    always_comb begin:hit_onehot2bin
        unique case(itlb_rd_hit_i)
            32'b00000000000000000000000000000001: hit_index_d[4:0] = 5'b00000;
            32'b00000000000000000000000000000010: hit_index_d[4:0] = 5'b00001;
            32'b00000000000000000000000000000100: hit_index_d[4:0] = 5'b00010;
            32'b00000000000000000000000000001000: hit_index_d[4:0] = 5'b00011;
            32'b00000000000000000000000000010000: hit_index_d[4:0] = 5'b00100;
            32'b00000000000000000000000000100000: hit_index_d[4:0] = 5'b00101;
            32'b00000000000000000000000001000000: hit_index_d[4:0] = 5'b00110;
            32'b00000000000000000000000010000000: hit_index_d[4:0] = 5'b00111;
            32'b00000000000000000000000100000000: hit_index_d[4:0] = 5'b01000;
            32'b00000000000000000000001000000000: hit_index_d[4:0] = 5'b01001;
            32'b00000000000000000000010000000000: hit_index_d[4:0] = 5'b01010;
            32'b00000000000000000000100000000000: hit_index_d[4:0] = 5'b01011;
            32'b00000000000000000001000000000000: hit_index_d[4:0] = 5'b01100;
            32'b00000000000000000010000000000000: hit_index_d[4:0] = 5'b01101;
            32'b00000000000000000100000000000000: hit_index_d[4:0] = 5'b01110;
            32'b00000000000000001000000000000000: hit_index_d[4:0] = 5'b01111;
            32'b00000000000000010000000000000000: hit_index_d[4:0] = 5'b10000;
            32'b00000000000000100000000000000000: hit_index_d[4:0] = 5'b10001;
            32'b00000000000001000000000000000000: hit_index_d[4:0] = 5'b10010;
            32'b00000000000010000000000000000000: hit_index_d[4:0] = 5'b10011;
            32'b00000000000100000000000000000000: hit_index_d[4:0] = 5'b10100;
            32'b00000000001000000000000000000000: hit_index_d[4:0] = 5'b10101;
            32'b00000000010000000000000000000000: hit_index_d[4:0] = 5'b10110;
            32'b00000000100000000000000000000000: hit_index_d[4:0] = 5'b10111;
            32'b00000001000000000000000000000000: hit_index_d[4:0] = 5'b11000;
            32'b00000010000000000000000000000000: hit_index_d[4:0] = 5'b11001;
            32'b00000100000000000000000000000000: hit_index_d[4:0] = 5'b11010;
            32'b00001000000000000000000000000000: hit_index_d[4:0] = 5'b11011;
            32'b00010000000000000000000000000000: hit_index_d[4:0] = 5'b11100;
            32'b00100000000000000000000000000000: hit_index_d[4:0] = 5'b11101;
            32'b01000000000000000000000000000000: hit_index_d[4:0] = 5'b11110;
            32'b10000000000000000000000000000000: hit_index_d[4:0] = 5'b11111;
            default                             : hit_index_d[4:0] = 5'b10000;
        endcase
    end



// @DVT_EXPAND_MACRO_INLINE_START
// `D_FLIP_FLOP(hit_index_register, clk_i, rstn_i, hit_index_d, hit_index_q, itlb_hit_vld_i)
// @DVT_EXPAND_MACRO_INLINE_ORIGINAL

    always_ff @(posedge clk_i or negedge rstn_i) begin:hit_index_register
        if (!rstn_i) begin
            hit_index_q <= 'b0;
        end else if(itlb_hit_vld_i) begin
            hit_index_q <= hit_index_d;
        end
    end
// @DVT_EXPAND_MACRO_INLINE_END



    always_comb begin
        for ( int i = 0 ; i < $clog2(`TLB_ENTRY_SIZE) ; i++)
            for (int j = 0 ; j < 2**i ; j++) begin
                if      (i == 0) begin
                    plru_d_refill.p0 = wr_updt_en  ? !refill_index [4] : plru_q.p0;
                    plru_d_hit.p0    = hit_updt_en ? !hit_index_d  [4] : plru_q.p0;

                end
                else if (i == 1) begin
                    plru_d_refill.p1[j] = (j == (refill_index >> (5-i)))&&wr_updt_en  ? 
                                         j*2 == (refill_index >> (4-i))               :
                                         plru_q.p1[j] ;
                    plru_d_hit.p1   [j] = (j == (hit_index_d >> (5-i)))&&hit_updt_en  ? 
                                         j*2 == (hit_index_d >> (4-i))                :
                                         plru_q.p1[j];
                end
                else if (i == 2) begin
                    plru_d_refill.p2[j] = (j == (refill_index >> (5-i)))&&wr_updt_en  ?  
                                          j*2 == (refill_index >> (4-i)) :
                                          plru_q.p2[j] ;
                    plru_d_hit.p2   [j] = (j == (hit_index_d>> (5-i)))&&hit_updt_en ?  
                                          j*2 == (hit_index_d >> (4-i)) :plru_q.p2[j] ;
                end
                else if (i == 3) begin
                    plru_d_refill.p3[j] = (j == (refill_index >> (5-i)))&&wr_updt_en  ? 
                                          j*2 == (refill_index >> (4-i)) : plru_q.p3[j];
                    plru_d_hit.p3   [j] =  (j == (hit_index_d >> (5-i)))&&hit_updt_en ?  
                                            j*2 == (hit_index_d >> (4-i)) :plru_q.p3[j];
                end
                else begin
                    plru_d_refill.p4[j] = (j == (refill_index >> (5-i)))&&wr_updt_en  ?  
                                          j*2 == (refill_index >> (4-i)) : plru_q.p4[j];
                    plru_d_hit.p4  [j]  = (j == (hit_index_d >> (5-i)))&&hit_updt_en ?  
                                          j*2 == (hit_index_d >> (4-i)) : plru_q.p4[j];
                end
            end
    end


    assign hit_updt_en = (hit_index_d != hit_index_q) ;
// @DVT_EXPAND_MACRO_INLINE_START
// `D_FLIP_FLOP(plru_register, clk_i, rstn_i, plru_d, plru_q, wr_updt_en||hit_updt_en)
// @DVT_EXPAND_MACRO_INLINE_ORIGINAL

    always_ff @(posedge clk_i or negedge rstn_i) begin:plru_register
        if (!rstn_i) begin
            plru_q <= 'b0;
        end else if(wr_updt_en) begin
            plru_q <= plru_d_refill;
        end else if(hit_updt_en)
            plru_q <= plru_d_hit;

    end
// @DVT_EXPAND_MACRO_INLINE_END


    //update the plru_index
    always_comb begin
        plru_index[4] = plru_q.p0;

        plru_index[3] = plru_q.p0 ? plru_q.p1[1] : plru_q.p1[0];

        plru_index[2] = plru_q.p0
            ? (plru_q.p1[1] ? plru_q.p2[3] : plru_q.p2[2])
            : (plru_q.p1[0] ? plru_q.p2[1] : plru_q.p2[0]);

        plru_index[1] = plru_q.p0
            ? (plru_q.p1[1]
                ? (plru_q.p2[3] ? plru_q.p3[7] : plru_q.p3[6])
                : (plru_q.p2[2] ? plru_q.p3[5] : plru_q.p3[4]))
            : (plru_q.p1[0]
                ? (plru_q.p2[1] ? plru_q.p3[3] : plru_q.p3[2])
                : (plru_q.p2[0] ? plru_q.p3[1] : plru_q.p3[0]));

        plru_index[0] = plru_q.p0
            ? (plru_q.p1[1]
                ? (plru_q.p2[3]
                    ? (plru_q.p3[7] ? plru_q.p4[15] : plru_q.p4[14])
                    : (plru_q.p3[6] ? plru_q.p4[13] : plru_q.p4[12]))
                : (plru_q.p2[2]
                    ? (plru_q.p3[5] ? plru_q.p4[11] : plru_q.p4[10])
                    : (plru_q.p3[4] ? plru_q.p4[9] : plru_q.p4[8])))
            : (plru_q.p1[0]
                ? (plru_q.p2[1]
                    ? (plru_q.p3[3] ? plru_q.p4[7] : plru_q.p4[6])
                    : (plru_q.p3[2] ? plru_q.p4[5] : plru_q.p4[4]))
                : (plru_q.p2[0]
                    ? (plru_q.p3[1] ? plru_q.p4[3] : plru_q.p4[2])
                    : (plru_q.p3[0] ? plru_q.p4[1] : plru_q.p4[0])));
    end



endmodule
