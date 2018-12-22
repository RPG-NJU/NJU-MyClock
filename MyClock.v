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
	output wire clock_clk,
	output wire [41:0] all_HEX   //此处是所有需要输出的七段数码管的信息
								 //便于使用所以没有进行区分0~5号HEX
								 /*
								  * [6:0]
								  * [13:7]
								  * [20:14]
								  * [27:21]
								  * [34:28]
								  * [41:35]
								  * 分割如上
								  */
	);

	wire [5:0] clock_hour;
	wire [5:0] clock_minute;
	wire [5:0] clock_second;
	//需要用来传递时间的wire变量


	wire set_time_en; // 用于进行时间设定的使能端

	wire [5:0] hour_trans;
	wire [5:0] minute_trans;
	wire [5:0] second_trans;
	// 用于传递时间的参数，不仅仅是时间设定的，还可以是闹钟设定的
	
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
	
	ClockRun MainClock(
		//这是主要的时钟程序实例化
		.one_second_clk(clock_clk),
		.hour(clock_hour),
		.minute(clock_minute),
		.second(clock_second),
		//上面是主要的时钟驱动的部分，还需要有能够设定时间的部分
		
		.set_en(set_time_en),
		.hour_set(hour_trans),
		.minute_set(minute_trans),
		.second_set(second_trans)
	);

	TimeShow HEXShowTime(
		.hour(clock_hour),
		.minute(clock_minute),
		.second(clock_second),

		.all_hex(all_HEX)
	);

endmodule
