module ClockRun(
	input one_second_clk,//传入的是1s为周期的时钟信号

	output reg [5:0] hour,
	output reg [5:0] minute,
	output reg [5:0] second    //顾名思义，用于将时钟信号分开为三个时钟单位进行输出
	);
	
	initial
	begin
		hour = 6'b000000;
		minute = 6'b000000;
		second = 6'b000000;  
	end
endmodule
