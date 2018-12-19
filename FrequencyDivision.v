/*
 * 分频模块
 * 将这个模块作为本实验中最重要的一秒时钟周期生成模块
 * 将输入的开发板上的时钟信号分频，变为输出
 */


module FrequencyDivision(
	input en,//分频的使能端，高电平有效，低电平停止输出
	input clk_input,
	//input old_clk,//传入的老旧时钟信号

	//inout reg clk_output,

	output reg clk_output//用于在测试的时候输出一个LED信号，确定是否完成了分频
	);

	//reg now_clk;//= clk_output;
	reg [31:0] count;//位宽显然是大于所需要的，但是为求稳妥以及偷懒，此足矣
	
	initial
	begin
		clk_output = 1'b0;
	end
	always @ (posedge clk_input)
	begin
		//now_clk = clk_output;
		if (count >= 25000000)
		begin
			count <= 0;
			//clk_output <= ~old_clk;
			clk_output <= ~clk_output;
		end
		else if (en)//此时计数是有效的
		begin
			count <= count + 1;
			//clk_output <= old_clk;
			clk_output = clk_output;
		end
		else
		begin
			clk_output = clk_output;
		end
	end

	// always @ (*)
	// begin
	// 	if (count == 50000000)
	// 	begin
	// 		count = 0;
	// 		clk_output = ~now_clk;//如果计数达到了一定大小，则进行反向
	// 	end
	// end
	
endmodule
