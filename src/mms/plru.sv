module plru_4
(
    input        [1 :0] addr_hit,
    input        rst_n,clk,
    output logic [1 :0] addr_repl
);

    logic [2 : 0] node;
    logic [2 : 0] next_node;

	always_ff @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			node <= '0;
		else
			node <= next_node;
	end
    //decode Sel

    always_comb begin
        next_node[0] = ~addr_hit[0];
        if(addr_hit[1] == 0)
            next_node [2:1] = {node[2],~addr_hit[0]};
        else
            next_node [2:1] = {~addr_hit[0],node[1]};
    end

    always_comb begin
        addr_repl[0] = node[0];
        addr_repl[1] = node[0] == 1'b0 ? node[1] : node[2];
    end

endmodule
