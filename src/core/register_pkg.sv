package register_pkg;

    typedef struct packed{
        logic mode ;
        logic [8:0] asid;
        logic [21:0] ppn ;
    } satp_t;

endpackage