package mms_pkg;

//Cache
    import risXv_macro::*;   
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

    typedef struct packed {
        logic [`VPN1_WD     - 1 : 0]      vpn1 ;
        logic [`VPN0_WD     - 1 : 0]      vpn0 ;
        logic [`PAGE_OFFSET - 1 : 0]      pg_offset ;
    } va_t;

    typedef struct packed {
        logic i;
    } pa_t;

    typedef struct packed {
        logic [3:0] [31:0] inst ;
    } inst_set_t ;
//TLB


//MMU
    typedef struct packed {
        va_t va;

    } page_entry;
endpackage
