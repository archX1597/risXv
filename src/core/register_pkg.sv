package register_pkg;
    `include "risXv.svh"
    typedef struct packed{
        logic [`MODE_WD - 1 : 0]  mode;
        logic [`ASID_WD - 1 : 0]  aisd;
        logic [`PPN_WD  - 1 : 0]  ppn ;
    } satp_t;
endpackage