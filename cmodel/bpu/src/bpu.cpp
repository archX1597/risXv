#include <systemc.h>

// 定义固定大小
#define BHT_SIZE 16    // 分支历史表的大小
#define BTB_SIZE 16    // 分支目标缓冲器的大小

// 分支历史表（BHT）模块
SC_MODULE(BHT) {
    int history_table[BHT_SIZE]; // 使用数组代替动态结构

    SC_CTOR(BHT) {
        // 初始化为弱跳转状态（2）
        for (int i = 0; i < BHT_SIZE; ++i) {
            history_table[i] = 2;
        }
    }

    // 计算索引（基于 PC 地址）
    int index(uint32_t pc) {
        return pc % BHT_SIZE; // 对 PC 取模
    }

    // 读取预测结果
    bool predict(uint32_t pc) {
        return history_table[index(pc)] > 1; // 大于 1 表示跳转
    }

    // 更新预测结果
    void update(uint32_t pc, bool actual_outcome) {
        int idx = index(pc);
        if (actual_outcome) { // 实际跳转
            if (history_table[idx] < 3) history_table[idx]++;
        } else { // 实际未跳转
            if (history_table[idx] > 0) history_table[idx]--;
        }
    }
};

// 分支目标缓冲器（BTB）模块
SC_MODULE(BTB) {
    uint32_t target_table[BTB_SIZE]; // 使用数组代替动态结构

    SC_CTOR(BTB) {
        // 初始化目标地址为 0
        for (int i = 0; i < BTB_SIZE; ++i) {
            target_table[i] = 0;
        }
    }

    // 计算索引（基于 PC 地址）
    int index(uint32_t pc) {
        return pc % BTB_SIZE; // 对 PC 取模
    }

    // 获取目标地址
    uint32_t get_target(uint32_t pc) {
        return target_table[index(pc)];
    }

    // 更新目标地址
    void update(uint32_t pc, uint32_t target) {
        target_table[index(pc)] = target;
    }
};

// 顶层仿真模块
SC_MODULE(BranchPredictor) {
    sc_signal<uint32_t> pc;           // 当前指令地址
    sc_signal<bool> actual_outcome;  // 实际跳转结果
    sc_signal<uint32_t> target;      // 实际目标地址
    sc_in<bool> clk;                 // 时钟信号输入

    BHT* bht;
    BTB* btb;

    SC_CTOR(BranchPredictor) {
        bht = new BHT("BHT");
        btb = new BTB("BTB");

        SC_METHOD(simulate_step);    // 注册对时钟敏感的模拟过程
        sensitive << clk.pos();     // 对时钟的上升沿敏感
    }

    // 仿真测试数据
    const int TEST_SIZE = 16;
    uint32_t test_pcs[16] = {
        0x100, 0x104, 0x108, 0x10C,
        0x200, 0x204, 0x200, 0x204,
        0x300, 0x304, 0x308, 0x30C,
        0x400, 0x404, 0x408, 0x40C
    };

    bool outcomes[16] = {
        true, false, true, true,
        false, true, false, true,
        true, true, false, false,
        false, true, true, false
    };

    uint32_t targets[16] = {
        0x200, 0x300, 0x400, 0x500,
        0x600, 0x700, 0x600, 0x700,
        0x800, 0x900, 0xA00, 0xB00,
        0xC00, 0xD00, 0xE00, 0xF00
    };

    int current_step = 0; // 当前仿真步骤

    // 模拟过程：每个时钟周期处理一条指令
    void simulate_step() {
        if (current_step >= TEST_SIZE) {
            sc_stop(); // 测试完成后停止仿真
            return;
        }

        pc.write(test_pcs[current_step]);
        actual_outcome.write(outcomes[current_step]);
        target.write(targets[current_step]);

        // 获取预测结果
        bool prediction = bht->predict(pc.read());
        uint32_t predicted_target = btb->get_target(pc.read());

        // 打印预测结果
        std::cout << "PC: 0x" << std::hex << pc.read()
                  << " Prediction: " << (prediction ? "Taken" : "Not Taken")
                  << " Predicted Target: 0x" << predicted_target
                  << " Actual Outcome: " << (actual_outcome.read() ? "Taken" : "Not Taken")
                  << " Actual Target: 0x" << target.read()
                  << std::endl;

        // 更新 BHT 和 BTB
        bht->update(pc.read(), actual_outcome.read());
        btb->update(pc.read(), target.read());

        current_step++; // 移动到下一步
    }
};

int sc_main(int argc, char* argv[]) {
    sc_clock clk("clk", 10, SC_NS); // 定义时钟，周期为 10 纳秒
    BranchPredictor predictor("BranchPredictor");

    predictor.clk(clk); // 连接时钟信号

    sc_start(); // 开始仿真
    return 0;
}
