package register_pkg;
    import risXv_macro::*;
    typedef struct packed{
        logic [`MODE_WD - 1 : 0]  mode;
        logic [`ASID_WD - 1 : 0]  aisd;
        logic [`PPN_WD  - 1 : 0]  ppn ;
    } satp_t;


    //CSR register Group


    //misa :
    // Definition of misa CSR in SystemVerilog
    // XLEN = 32
    typedef struct packed {
        logic [`MXLEN - 1 : `MXLEN -2 ]  mxl = 2'b01; //Machine XLEN
        logic [`MXLEN - 3 : 26       ]  zero;
        logic [25        : 0        ]  extensions;
    } misa_t;

    //mvendorid: Machine Vendor ID Register mvendorid
    typedef struct packed {
        logic [31 : 7] bank;
        logic [6  : 0] offset;
    } mvendorid_t;

    //marchid: Machine Architecture ID Register marchid
    typedef struct packed{
        logic [`MXLEN - 1 : 0 ] arch_id;
    } marchid_t;

    //mimpid: Machine Implementation ID Register mimpid
    // Definition of mimpid CSR in SystemVerilog
    typedef struct packed {
        logic [`MXLEN - 1 : 0] imp_id;
    } mimpid_t;

    //mhartid: Machine Hart ID Register mhartid
    typedef struct packed {
        logic [`MXLEN - 1 : 0] hart_id;
    } mhartid_t;
    //mstatus :Machine Status:
    // Definition of mstatus CSR in SystemVerilog
    // Definition of mstatus CSR with lowercase variable names
    typedef struct packed {
        logic sd;                   // Bit 31: SD
        logic [29:22] wpri_1;       // Bits 30-23: Reserved (WPRI)
        logic tsr;                  // Bit 22: TSR
        logic tw;                   // Bit 21: TW
        logic tvm;                  // Bit 20: TVM
        logic mxr;                  // Bit 19: MXR
        logic sum;                  // Bit 18: SUM
        logic mprv;                 // Bit 17: MPRV
        logic [1:0] xs;             // Bits 16-15: XS[1:0]
        logic [1:0] fs;             // Bits 14-13: FS[1:0]
        logic [1:0] mpp;            // Bits 12-11: MPP[1:0]
        logic [1:0] vs;             // Bits 10-9: VS[1:0]
        logic spp;                  // Bit 8: SPP
        logic mpie;                 // Bit 7: MPIE
        logic ube;                  // Bit 6: UBE
        logic spie;                 // Bit 5: SPIE
        logic wpri_2;               // Bit 4: Reserved (WPRI)
        logic mie;                  // Bit 3: MIE
        logic wpri_3;               // Bit 2: Reserved (WPRI)
        logic sie;                  // Bit 1: SIE
        logic wpri_4;               // Bit 0: Reserved (WPRI)
    } mstatus_t;


    //mtvec:The mtvec register is an MXLEN-bit WARL read/write register that holds trap vector configuration,
    //a pointer to the base address of an exception handler.
    typedef struct packed {
        logic [`MXLEN - 1 : 2] base; // Base address of the trap vector
        logic [1:0] mode;            // Mode field
    } mtvec_t;

    //medeleg: Machine trap Exception Delegation Register medeleg
    typedef struct packed {
        logic [31:0] sync_exceptions;
    } medeleg_t;

    //mideleg: Machine trap Interrupt Delegation Register mideleg
    typedef struct packed {
        logic [31:0] async_interrupts;
    } mideleg_t;

    //mip: Machine Interrupt Pending Register mip
    typedef struct packed {
        logic [31:0] interrupts;
    } mip_t;

    //mie: Machine Interrupt Enable Register mie
    typedef struct packed {
        logic [31:0] interrupts;
    } mie_t;
    
endpackage