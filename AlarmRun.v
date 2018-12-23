module AlarmRun(
	input [5:0] hour_set,
	input [5:0] minute_set,
	input [5:0] second_set,//用于设定闹钟的变量

	input [5:0] hour,
	input [5:0] minute,
	input [5:0] second,

	input CLK_50,

	input alarm_set,

	input one_second_clk, // 每秒的时钟周期

	output [3:0] LEDR,
	output reg LEDAlarm, // 测试用的LED闹铃输出

	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK, // 音频实验所需要的大量引脚

	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT

	);

	reg [5:0] alarm_hour;
	reg [5:0] alarm_minute;
	reg [5:0] alarm_second;

	reg [2:0] count;

	initial
	begin
		LEDAlarm = 1'b0;
		alarm_hour = 6'b0;
		alarm_minute = 6'b0;
		alarm_second = 6'b0;
		count = 3'b0;
	end

	always @ (posedge one_second_clk)
	begin
		if (alarm_set == 1'b1) // 此时是需要设定闹钟的时候
		begin
			alarm_hour = hour_set;
			alarm_minute = minute_set;
			alarm_second = second_set;
		end

		else if (hour == alarm_hour && minute == alarm_minute && second == alarm_second)
		// 此时是闹钟设定的时间
		begin
			count = 3'b1; // count加一进行计数
			LEDAlarm = 1'b1;
		end

		else if (count != 3'b0)
		begin
			count = count + 1;
			//LEDAlarm <= 1'b1;
		end

		else if (count == 1'b0)
		begin
			LEDAlarm = 1'b0;
		end
	end

	sound_sample Sound(
		.CLOCK_50(CLK_50),
		.LEDR(LEDR),
		.AUD_BCLK(AUD_BCLK),
		.AUD_DACDAT(AUD_DACDAT),
		.AUD_DACLRCK(AUD_DACLRCK),
		.AUD_XCK(AUD_XCK),
		.FPGA_I2C_SCLK(FPGA_I2C_SCLK),
		.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
		.en_count(count)
	);
	
endmodule
