/*
 * 以此作为顶层模块，全部依据本模块进行链接
 * 将所有的其余组件尽量的放在各个文件中，便于维护和完善
 * MyClock  ->  Top level
 */


module MyClock(
	input CLK_50, 
	input reset_en,
	input run_en,

	input ps2_clk,
	input ps2_data,
	
	//output wire test_clk//用于测试输出，输出一个每秒频闪的LED作为测试
	output wire clock_clk,
	output wire set_time_en, // 用于进行时间设定的使能端
	output wire set_alarm_en, // 同理
	output wire DONE, // D的敲击显示
	output wire key_trans_en,
	output wire AlarmLED, // 用于测试输出Alarm信息

	output wire [3:0] LEDR, // 这个标准的四个输出是给移植而来的音频实验使用的，个人毫无意义
	//output wire [7:0] ASCII_show, // 用于DEBUG，马上就会删除

	output wire [41:0] all_HEX,   //此处是所有需要输出的七段数码管的信息
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

	//output wire keyboard_ready

	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK, // 音频实验所需要的大量引脚

	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT

	);

	wire [5:0] clock_hour;
	wire [5:0] clock_minute;
	wire [5:0] clock_second;
	//需要用来传递时间的wire变量


	

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
		.hour__(clock_hour),
		.minute__(clock_minute),
		.second__(clock_second),

		.hour_(hour_trans),
		.minute_(minute_trans),
		.second_(second_trans),

		.set_en(set_time_en),
		.alarm_en(set_alarm_en),

		.all_hex(all_HEX)
	);

	KeyTimeGet GetTime(
		.ps2_clk(ps2_clk),
		.ps2_data(ps2_data),
		.CLK_50(CLK_50),

		.set_en(set_time_en),
		.alarm_en(set_alarm_en),
		//.ready(keyboard_ready)

		.trans_en(key_trans_en),

		.hour(hour_trans),
		.minute(minute_trans),
		.second(second_trans),
		.all_ready(DONE)
		//.ASCII(ASCII_show)
	);

	AlarmRun Alarm(
		.hour_set(hour_trans),
		.minute_set(minute_trans),
		.second_set(second_trans),
		.hour(clock_hour),
		.minute(clock_minute),
		.second(clock_second),

		.alarm_set(set_alarm_en),
		.one_second_clk(clock_clk),

		.CLK_50(CLK_50),
		.LEDR(LEDR),

		.LEDAlarm(AlarmLED),
		.AUD_BCLK(AUD_BCLK),
		.AUD_DACDAT(AUD_DACDAT),
		.AUD_DACLRCK(AUD_DACLRCK),
		.AUD_XCK(AUD_XCK),
		.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT(FPGA_I2C_SDAT)
	);

endmodule
