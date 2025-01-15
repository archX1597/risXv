#include <TAGE.hpp>

void Tage_Predictor::initial(){
    ghr = 0;
    for(int i = 0; i < BASE_DEPTH; i++){
        base_table[i] = 0;
    }
    for(int i = 0; i < T1_DEPTH; i++){
        T1_table[i].counter = 0;
        T1_table[i].tag = 0;
        T1_table[i].useful = 0;
    }
    for(int i = 0; i < T2_DEPTH; i++){
        T2_table[i].counter = 0;
        T2_table[i].tag = 0;
        T2_table[i].useful = 0;
    }
    for(int i = 0; i < T3_DEPTH; i++){
        T3_table[i].counter = 0;
        T3_table[i].tag = 0;
        T3_table[i].useful = 0;
    }
} 

void Tage_Predictor::hash(){
    uint32_t pc_hash = base_hash(pc.read());
    ghr = ghr << 1;
    ghr[0] = last_taken.read();
    if(ghr[0] == 1){
        ghr = ghr ^ 0x1;
    }
}