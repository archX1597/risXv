`define PRIVILEGE_ARCH
import mms_pkg::*;
import register_pkg::*;
module itlb_control (
        input logic [`MXLEN - 1 : 0] satp_i,
        input logic [`MXLEN - 1 : 0] pte_i,
        input logic  entry_hit_i,
        input logic clk_i,rstn_i,
        input logic rd_access_i,
        input logic wr_access_i,
        input logic  tag_hit_i,
        output logic vm_exception_o,
        output logic tlb_miss_o,
        output logic tlb_hit_o
    );

    satp_t satp         ;
    pte_t  pte          ;
    logic tlb_miss      ;
    logic tlb_hit       ;
    logic tlb_access    ;
    logic rsw_valid     ;
    logic vir_mem_en    ;
    logic sv32_en       ;
    logic page_dirty    ;
    logic entry_miss    ;
    logic rd_valid      ;
    logic wr_valid      ;
    logic xc_valid      ;
    logic page_Invalid  ;

    assign entry_miss   = ~entry_hit_i;
    assign tlb_access   = rd_access_i | wr_access_i;
    assign satp         = satp_i;
    assign pte          = pte_i  ;
    assign vir_mem_en   = (satp.mode == 2'b00);
    assign sv32_en      = (satp.mode == 2'b01);
    assign rsw_valid    = (pte.rsw == 2'b00);
    assign rd_valid     = pte.read;
    assign wr_valid     = pte.write;
    assign xc_valid     = pte.xcute;


    assign vm_exception_o = vir_mem_en & ~sv32_en;//Only support Sv32 Mode

    assign page_Invalid  = ~pte.valid               |
                           rd_access_i & ~rd_valid  |
                           wr_valid & ~wr_access_i  |
                           rd_access_i & entry_miss |
                           wr_access_i & entry_miss |
                           ~vir_mem_en              |
                           ~sv32_en                 ;
    
    assign page_dirty    = pte.dirty;

    //exception:
    //1. page fault
    //2. page table entry invalid
    //3. page table entry not found
    //4. page table entry not valid
    //5. page table entry not readable
    //6. page table entry not writable
    //7. page table entry not executable
    






endmodule