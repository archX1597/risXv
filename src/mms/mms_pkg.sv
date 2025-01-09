package mms_pkg;
//Cache
    import risXv_macro::*;
    import mms_macro::*;  
    typedef struct packed {
        logic [`CACHE_TAG_WD   - 1 : 0] tag;
        logic [`CACHE_INDEX_WD - 1 : 0] index;
        logic [`CACHE_OFFSET   - 1 : 0] offset;
    } cache_a_t;

    typedef struct packed {
        logic valid,dirty;
        logic [`DATA_WD - 1      : 0] cc_data;
        logic [`CACHE_TAG_WD - 1 : 0] cc_tag;
    } cache_line_t;

`ifdef PRIVILEGE_ARCH
    typedef struct packed {
        logic i;
    } pa_t;

    typedef struct packed {
        logic [3:0] [31:0] inst ;
    } inst_set_t ;
//TLB

    typedef struct packed {
        logic [`VPN1_WD     - 1 : 0]      vpn1 ;
        logic [`VPN0_WD     - 1 : 0]      vpn0 ;
        logic [`PAGE_OFFSET - 1 : 0]      pg_offset ;
    } va_t;
//MMU
    typedef struct packed {
        logic [`PPN1_WD - 1 : 0] ppn1;
        logic [`PPN0_WD - 1 : 0] ppn0;
    } ppn_t;
    
    typedef struct packed {
        ppn_t ppn;
        logic [1:0] rsw;
        logic dirty;
        logic accessed;
        logic global_v;
        logic user;
        logic read,write,xcute;
        logic valid;
    } pte_t;

    typedef struct packed {
        logic [`VPN1_WD - 1 : 0] vpn1;
        logic [`VPN0_WD - 1 : 0] vpn0;
    } vpn_t;

    typedef struct packed {
        pte_t pg_entry;
        vpn_t vpn;
        logic [`PAGE_OFFSET - 1 : 0] pg_offset;
        logic [`ASID_WD - 1:0] asid;
        logic [`MODE_WD - 1:0] mode;
    } itlb_entry_t;
`endif
endpackage
