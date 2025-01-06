package mms_macro;
    `define TLB_ENTRY_NUM 32
    `define ITLB_ENTRY_NUM 32
    //Memory Manage System
    `define PADDR_WD 34
    `define VADDR_WD 32
    
    `define CACHE_SET 256
    `define CACHE_WAY   4
    `define CACHE_INDEX_WD 8
    `define CACHE_TAG_WD 22
    `define CACHE_OFFSET 4 // 2**4 Byte = 16 Byte ,1 word = 4 Bytes, Data = 4 Words
    `define MODE_WD 2
    `define ASID_WD 9
    `define PPN_WD 22
    `define PPN1_WD 12
    `define PPN0_WD 10
    `define PAGE_OFFSET 12
    `define VPN1_WD   10
    `define VPN0_WD   10
    `define TLB_ENTRY_SIZE 32
endpackage