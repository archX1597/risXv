import mms_pkg::*;

module itlb(
        //input port
        input  logic clk_i,
        input  logic rstn_i,
        input  logic flush_i,
        input  logic fu_access_i,
        input  logic [`VADDR_WD - 1 :0 ] vaddr_i,
        input  logic asid_flush_i,
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
    
    itlb_entry_t itlb_entry_cam [`ITLB_ENTRY_NUM - 1 : 0];
    logic [`ITLB_ENTRY_NUM - 1 : 0] itlb_entry_hit; 
    pte_t pte;
    va_t va;
    pa_t pa;
    logic [`PADDR_WD - 1 : 0] paddr;
    logic [`ITLB_ENTRY_NUM - 1 : 0] itlb_hit;
    logic page_fault, access_except, misalign_access;

    assign va = vaddr_i;


    always_comb begin
        for (int i = 0 ; i < `ITLB_ENTRY_NUM ; i++) begin
            if (itlb_entry_cam[i].tag_vpn == {va.vpn1,va.vpn0}) begin
                itlb_entry_hit[i] = 1'b1;
            end
            else begin
                itlb_entry_hit[i] = 1'b0;
            end
        end
    end

endmodule