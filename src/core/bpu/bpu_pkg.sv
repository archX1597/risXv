package bpu_pkg;
`ifndef BPU_PKG
    `define BPU_PKG
    import risXv_macro::*;
    `define HIST_LEN 64
    `define SAT_TABLE_SIZE 1024
    `define L0_BHR_LEN 10
    `define BASE_DEPTH
    `define T0_DEPTH
    `define T1_DEPTH
    `define T2_DEPTH
    `define NO_UVM
        `ifdef UVM
            `define ERROR `uvm_error
        `else
            `define ERROR $error
        `endif
    `define uINST_OFFSETLEN
    `define uBTB_DEPTH 512 
    `define uBTB_INDEX_LEN 9
    `define uHASH_LEN 10
    `define uTAG_LEN `uHASH_LEN
    typedef struct packed {
        logic valid;
        logic [`uTAG_LEN - 1 : 0] tag;
    } ubtb_tagEntry_t;

    typedef struct packed {
        logic [`uINST_OFFSETLEN - 1 : 0] inst_offset;
    } ubtb_instEntry_t;

    typedef struct packed {
        logic valid;
        logic [1:0] sat_counter;
    } usat_entry_t;

    typedef struct packed {
        logic [`uTAG_LEN - 1 : 0]  pc_Part0,pc_Part1;
        logic [`uBTB_INDEX_LEN -1 : 0] pc_index;
        logic [`MXLEN - `uTAG_LEN - `uTAG_LEN -`uBTB_INDEX_LEN - 1 : 0] pc_ignore;
    } pc_uPrehash_t;

    typedef struct packed {
        logic [`uTAG_LEN - 1 : 0]  pc_hashTag ;
        logic [`uBTB_INDEX_LEN -1 : 0] pc_index;
    } pc_uAfthash_t;

`endif
endpackage;