import mms_pkg::*;

module itlb(
        //input port
        input  logic clk_i,
        input  logic rstn_i,
        input  logic tlb_flush_i,
        input  logic tlb_write_i,
        input  logic fu_access_i,
        input  logic [`ASID_WD - 1 :0] asid_i,
        input  logic [`VADDR_WD - 1 :0 ] vaddr_i,
        //output port
        output logic [`PADDR_WD - 1 : 0] paddr_o,
        output logic itlb_hit_o,
        //exception outport
        output logic page_fault_o,
        output logic access_except_o,
        output logic misalign_access_o
    );

 // Virtual Address in Sv32 Mode (32 bits)
// ---------------------------------------------------------------
//| 31        22 | 21        12 | 11             0 |
//|     VPN[1]   |    VPN[0]    |    Page Offset   |
// ---------------------------------------------------------------
// - VPN[1]: 10 bits (Level 1 Page Table Index)
// - VPN[0]: 10 bits (Level 2 Page Table Index)
// - Page Offset: 12 bits (Byte Offset within a Page)

// Physical Address in Sv32 Mode (34 bits)
// ---------------------------------------------------------------
// 33        22 | 21        12 | 11             0 |
//     PPN[1]   |    PPN[0]    |    Page Offset   |
// ---------------------------------------------------------------
// - PPN[1]: 12 bits (Physical Page Number for Level 1)
// - PPN[0]: 10 bits (Physical Page Number for Level 2)
// - Page Offset: 12 bits (Byte Offset within a Page)

// Page Table Entry (PTE) in Sv32 Mode (32 bits)
// ---------------------------------------------------------------
// 31        20 | 19        10 | 9      8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
 //   PPN[1]   |    PPN[0]    |   RSW    | D | A | G | U | X | W | R | V |
// ---------------------------------------------------------------
// - PPN[1]: 12 bits (Physical Page Number for Level 1)
// - PPN[0]: 10 bits (Physical Page Number for Level 2)
// - RSW: 2 bits (Reserved for Software)
// - D: 1 bit (Dirty Bit, indicates if the page has been written)
// - A: 1 bit (Accessed Bit, indicates if the page has been accessed)
// - G: 1 bit (Global Bit, indicates if the page is global)
// - U: 1 bit (User Bit, indicates if the page is accessible in user mode)
// - X: 1 bit (Execute Bit, indicates if the page is executable)
// - W: 1 bit (Write Bit, indicates if the page is writable)
// - R: 1 bit (Read Bit, indicates if the page is readable)
// - V: 1 bit (Valid Bit, indicates if the PTE is valid)
    
    itlb_entry_t itlb [`ITLB_ENTRY_NUM - 1 : 0];
    logic [`ITLB_ENTRY_NUM - 1 : 0] itlb_entry_hit; 
    pte_t pte;
    va_t va;
    pa_t pa;
    logic [`PADDR_WD - 1 : 0] paddr;
    logic [`ITLB_ENTRY_NUM - 1 : 0] itlb_entry_hit;
    logic itlb_miss;
    logic page_fault, access_except, misalign_access;
    //TLB Hit
    //instance the 32 itlb_camline
    logic [`VPN0_WD + `VPN1_WD - 1 : 0] tag_vpn_i;
    logic pte_g;
    logic write_en_i;
    logic hit_o;


    assign va = vaddr_i;
    assign itlb_miss = ~(|itlb_entry_hit);


    logic read_en_i;
    logic [`TLB_ENTRY_NUM - 1 : 0] pte_wr_i;
    logic [`TLB_ENTRY_NUM - 1 : 0] pte_rd_array [`MXLEN - 1 :0] ;
    logic [`MXLEN - 1 : 0] pte_rd_o;


    assign read_en_i  = itlb_hit_o;

    generate
    //instance Ram line
     for (i = 0; i < `ITLB_ENTRY_NUM; i++) begin : gen_itlb_ramline
            itlb_ramline u_itlb_ramline (
                // Inputs
                .clk_i     (clk_i),
                .pte_wr_i  (pte_wr_i),
                .read_en_i (read_en_i),
                .rstn_i    (rstn_i),
                .write_en_i(write_en_i),
                // Outputs
                .pte_rd_o  (pte_rd_array[i])
            );
     end
    endgenerate


    always_comb begin
        pte_rd_o = '0;
        for (int i = 0 ; i < `ITLB_ENTRY_NUM; i++) begin
            pte_rd_o = pte_rd_o | pte_rd_array[i];
        end
    end


    //ITLB_Control_logic
    assign access_except_o = itlb_miss | pte.read == 'b0 | pte.valid == 'b0;

endmodule