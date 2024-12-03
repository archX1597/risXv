package mms_pkg;
    `include "risXv.svh"
    `define CACHE_LINE 256
    `define CACHE_WAY   4
    `define CACHE_INDEX 8
    `define CACHE_TAG 20
    `define CACHE_OFFSET 4 // 2**4 Byte = 16 Byte ,1 word = 4 Bytes, Data = 4 Words
    `define PAGE_OFFSET 12
    `define VPN1   10
    `define VPN0   10

    typedef struct packed {
        logic [`CACHE_TAG  - 1 : 0] tag;
        logic [`CACHE_INDEX - 1 : 0] index;
        logic [`CACHE_OFFSET - 1 : 0] offset;
    } cache_a_t;

    typedef struct packed {
        logic valid,dirty;
        logic [`DATA_WD - 1   : 0] cc_data;
        logic [`CACHE_TAG - 1 : 0] cc_tag;
    } cache_line_t;

    typedef struct packed {
        logic [`VPN1   - 1  : 0]      vpn1 ;
        logic [`VPN0   - 1  : 0]      vpn0 ;
        logic [`PAGE_OFFSET - 1 : 0] pg_offset ;
    } va_t;

    typedef struct packed {
        logic i;
    } pa_t;

    typedef struct packed {
        logic [3:0] [31:0] inst ;
    } inst_set_t ;
endpackage
