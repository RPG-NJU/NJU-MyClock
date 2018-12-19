/*
 * 以此作为顶层模块，全部依据本模块进行链接
 * 将所有的其余组件尽量的放在各个文件中，便于维护和完善
 * MyClock  ->  Top level
 */


module MyClock(
	input CLK_50, 
	input reset_en,
	input run_en,
	
	//output wire test_clk//用于测试输出，输出一个每秒频闪的LED作为测试
	output wire clock_clk
	);
	
	//wire clock_clk;
	//assign clock_clk = 0;
	//reg old_clock;
	
	initial
	begin
		//old_clock = 1'b0;
	end
	FrequencyDivision change_clk50_to_one_second(
		//用这种长命名来打破记忆障碍
		//采用驼峰命名函数名
		//将50MHz的频率转变为1s的周期
		.en(run_en),
		.clk_input(CLK_50),
		.clk_output(clock_clk)
		//.old_clk(old_clock)
		//.clk_test(test_clk)
	);
	
	// always @ (clock_clk)//不知道为何，如果在此处写的是CLK_50就会导致灯居然有明暗两种亮法
	// begin
	// 	old_clock = clock_clk;
	// end
	
	
	
endmodule
