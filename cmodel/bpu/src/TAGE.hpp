#ifndef _TAGE_HPP_
#define _TAGE_HPP_
#endif

#include "systemc.h"
#define CNT_WIDTH 2
#define MXLEN 32
#define BASE_DEPTH 512
#define HIST_LEN 64
#define GHR_WIDTH 64 
#define GHR_L1 4
#define GHR_L2 8
#define GHR_L3 16
#define GHR_L4 32
#define T1_DEPTH 32
#define T2_DEPTH 64
#define T3_DEPTH 128


SC_MODULE(Tage_Predictor)
{
    sc_in<sc_uint<MXLEN>> pc;
    sc_in<sc_uint<MXLEN>> update_pc;
    sc_in_clk clk;
    sc_in<bool> rstn;
    sc_in<bool> last_taken;
    sc_out<bool> next_taken;


    sc_uint<GHR_WIDTH> ghr;
    void predict();
    void update();
    void initial();
    void hash();
    uint32_t base_hash(uint32_t pc);
    uint32_t alt_hash(uint32_t pc);

    sc_uint<CNT_WIDTH> base_table[BASE_DEPTH];
    struct Tage_Entry
    {
        sc_uint<3> counter;
        sc_uint<8> tag;
        sc_uint<2> useful;
    };

    Tage_Entry T1_table[T1_DEPTH];
    Tage_Entry T2_table[T2_DEPTH];
    Tage_Entry T3_table[T3_DEPTH];

    SC_CTOR(Tage_Predictor)
    {   
        initial();
        SC_METHOD(hash);
        sensitive<< clk.pos();
        SC_METHOD(predict);
        sensitive << clk.pos();
        SC_METHOD(update);
        sensitive << clk.pos();
    }


};
