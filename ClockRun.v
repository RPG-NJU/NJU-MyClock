/*
 * 该模块是进行时钟运作的主要模块
 * 其功能为，时钟的运行，以及根据使能端决定是否进行时间的设定
 */




module ClockRun(
	input one_second_clk,//传入的是1s为周期的时钟信号

	input [5:0] hour_set,
	input [5:0] minute_set,
	input [5:0] second_set,    //这是用于设定时间的三个输入变量

	input set_en,  //这是用来标识是否进行时间设定的使能端

	output reg [5:0] hour,
	output reg [5:0] minute,
	output reg [5:0] second    //顾名思义，用于将时钟信号分开为三个时钟单位进行输出
	);

	// reg set;
	
	initial
	begin
		hour = 6'b000000;
		minute = 6'b000000;
		second = 6'b000000;  
		// set = 1'b0;
	end
	//一开始进行初始化，将所有的时间置为00:00:00，从头开始

	// always @ (set_en)
	// begin
	// 	if (set_en == 1'b1)
	// 		set = 1'b1;
	// 	//如果触发了时间设定，则将set置为1，后续进行判定
	// end

	always @ (posedge one_second_clk or posedge set_en)
	begin
		if (set_en == 1'b1) // 进行时间的设定
		begin
			hour <= hour_set;
			minute <= minute_set;
			second <= second_set;
			//set = 1'b0;
		end

		else if (one_second_clk == 1'b1)
		begin
			if (second >= 6'd59)
			begin
				second <= 6'b0;
				minute <= minute + 1'b1;
			end
			else
				second <= second + 1'b1;
			
			if (minute >= 6'd59 && second >= 6'd59)
			begin
				minute <= 6'b0;
				hour <= hour + 1'b1;
			end

			if (hour >= 6'd23 && minute >= 6'd59 && second >= 6'd59)
			begin
				hour <= 6'b0;
			end
		end
	end

endmodule
