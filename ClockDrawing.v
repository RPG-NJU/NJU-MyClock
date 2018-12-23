module ClockDrawing(
	input [5:0] hour,
	input [5:0] minute,
	input [5:0] second,


	input clk, // 50MHz
	//input clkin,
	input rst,
	//input clken,
	input reset,
	
	output hsync, // 行同步和列同步信号
	output vsync,
	output valid, // 消隐信号
	
	output vga_clk,
	
	output sync_n,
	
	output [7:0] vga_r, // 红绿蓝颜色信号
	output [7:0] vga_g,
	output [7:0] vga_b,//都更改为4bits表示
	output reg test
	);

	reg signed [19:0] angle [59:0];
	

	
	wire [9:0] v_addr;
	wire [9:0] h_addr;

	reg signed [39:0] x;
	reg signed [39:0] y;
	
	initial
	begin
		test = 1'b0;
		angle[0] = 0;angle[30] = 0;
		angle[1] = 9514;angle[29] = -9514;
		angle[2] = 4704;angle[28] = -4704;
		angle[3] = 3077;angle[27] = -3077;
		angle[4] = 2246;angle[26] = -2246;
		angle[5] = 1732;angle[25] = -1732;
		angle[6] = 1376;angle[24] = -1376;
		angle[7] = 1110;angle[23] = -1110;
		angle[8] = 900;angle[22] = -900;
		angle[9] = 726;angle[21] = -726;
		angle[10] = 577;angle[20] = -577;
		angle[11] = 445;angle[19] = -445;
		angle[12] = 324;angle[18] = -324;
		angle[13] = 212;angle[17] = -212;
		angle[14] = 105;angle[16] = -105;
		angle[15] = 0;
		//angle[60] = 0;
		angle[31] = 9514;angle[59] = -9514;
		angle[32] = 4704;angle[58] = -4704;
		angle[33] = 3077;angle[57] = -3077;
		angle[34] = 2246;angle[56] = -2246;
		angle[35] = 1732;angle[55] = -1732;
		angle[36] = 1376;angle[54] = -1376;
		angle[37] = 1110;angle[53] = -1110;
		angle[38] = 900;angle[52] = -900;
		angle[39] = 726;angle[51] = -726;
		angle[40] = 577;angle[50] = -577;
		angle[41] = 445;angle[49] = -445;
		angle[42] = 324;angle[48] = -324;
		angle[43] = 212;angle[47] = -212;
		angle[44] = 105;angle[46] = -105;
		angle[45] = 0;
	end
	reg [11:0] data_trans;
	assign sync_n = 0;
	clkgen #(25000000) clkgen_fuction(
		.clkin(clk),
		.rst(rst),
		.clken(1'b1),
		.clkout(vga_clk)
		);
		
	// picture_rom rom(
	// 	.address({h_addr[9:0],v_addr[8:0]}),
	// 	.clock(clk),
	// 	.q(data_trans)
	// 	);
	/*  
	 * 经过测试之后，可以明了，该模块的耦合是令人满意的，可以在VGA连线的显示屏上面显示出北大楼
	 * 同时，需要标明我们的数据意义
	 * v_addr是移位之前的y坐标
	 * h_addr是移位之前的x坐标
	 * data_trans用12位表示了我们所有的VGA数据，其中，每四位代表一个颜色的权值
	 */
	// 640 * 512的分辨率


	// always @ (clk)
	// begin
	// 	if (v_addr[8:0] <= 128)
	// 		data_trans = 12'hFFF;
	// 	else if (v_addr[8:0] <= 256)
	// 		data_trans = 12'hF00;
	// 	else if (v_addr[8:0] <= 384)
	// 		data_trans = 12'h0F0;
	// 	else
	// 		data_trans = 12'h00F;
	// end

	/*
	 * 如上这段代码，就会在屏幕上生成四行色带，其中
	 * FFF为白色
	 * F00为红色
	 * 0F0为绿色
	 * 00F为蓝色
	 */

	always @ (clk)
	begin
		x = h_addr[9:0] - 320;
		y = - (v_addr[8:0] - 256);

		// if (1500 * y - x * 15 * 100 >-5000 && 1500 * y - x * 15 * 100 < 5000)
		// 			data_trans = 16'h0F0;

		//分针的部分，以及表盘的部分
		if  (x*x + y*y >=40000 && x*x + y*y <= 42025) // 希望能够在表环上绘制一个 “秒针” ，在对应位置上
		begin
			if (second > 0 && second <= 15)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h0F0;
				if (1000 * y - x * angle[second] > -10000 && 1000 * y - x * angle[second] < 10000 && x > 0 && y > 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else if (second > 15 && second < 30)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h0F0;
				if (1000 * y - x * angle[second] > -10000 && 1000 * y - x * angle[second] < 10000 && x > 0 && y < 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else if (second > 30 && second <= 45)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h0F0;
				if (1000 * y - x * angle[second] > -10000 && 1000 * y - x * angle[second] < 10000 && x < 0 && y < 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else if (second > 45 && second < 60)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h0F0;
				if (1000 * y - x * angle[second] > -10000 && 1000 * y - x * angle[second] < 10000 && x < 0 && y > 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else if (second == 0)
			begin
				if (x < 5 && x > -5 && y > 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else if (second == 30)
			begin
				if (x < 5 && x > -5 && y < 0)
					data_trans = 16'h0F0;
				else
					data_trans = 16'hFFF;
			end
			else
			begin
				data_trans = 16'hFFF;
			end
		end
		else
			data_trans = 16'h000;


		//分针
		if(x*x + y*y >=4000 && x*x + y*y < 40000) 
		begin
			if (minute > 0 && minute <= 15)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h00F;
				if (1000 * y - x * angle[minute] > -4000 && 1000 * y - x * angle[minute] < 4000 && x > 0 && y > 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else if (minute > 15 && minute < 30)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h00F;
				if (1000 * y - x * angle[minute] > -4000 && 1000 * y - x * angle[minute] < 4000 && x > 0 && y < 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else if (minute > 30 && minute <= 45)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h00F;
				if (1000 * y - x * angle[minute] > -4000 && 1000 * y - x * angle[minute] < 4000 && x < 0 && y < 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else if (minute > 45 && minute < 60)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'h00F;
				if (1000 * y - x * angle[minute] > -4000 && 1000 * y - x * angle[minute] < 4000 && x < 0 && y > 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else if (minute == 0)
			begin
				if (x < 3 && x > -3 && y > 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else if (minute == 30)
			begin
				if (x < 3 && x > -3 && y < 0)
					data_trans = 16'h00F;
				else
					data_trans = 16'h000;
			end
			else
			begin
				//test = 1'b0;
				data_trans = 16'h000;
			end
		end

		//时针
		if(x*x + y*y < 4000) 
		begin
			if (hour > 0 && hour <= 3)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf00;
				if (1000 * y - x * angle[hour * 5] > -6000 && 1000 * y - x * angle[hour * 5] < 6000 && x > 0 && y > 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end
			else if (hour > 3 && hour < 6)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf00;
				if (1000 * y - x * angle[hour * 5] > -6000 && 1000 * y - x * angle[hour * 5] < 6000 && x > 0 && y < 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end
			else if (hour > 6 && hour <= 9)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf00;
				if (1000 * y - x * angle[hour * 5] > -6000 && 1000 * y - x * angle[hour * 5] < 6000 && x < 0 && y < 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end
			else if (hour > 9 && hour < 12)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf00;
				if (1000 * y - x * angle[hour * 5] > -6000 && 1000 * y - x * angle[hour * 5] < 6000 && x < 0 && y > 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end
			else if (hour == 0)
			begin
				if (x < 4 && x > -4 && y > 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end
			else if (hour == 6)
			begin
				if (x < 4 && x > -4 && y < 0)
					data_trans = 16'hf00;
				else
					data_trans = 16'h000;
			end

			else if (hour > 12 && hour <= 15)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf0f;
				if (1000 * y - x * angle[(hour - 12) * 5] > -6000 && 1000 * y - x * angle[(hour - 12) * 5] < 6000 && x > 0 && y > 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else if (hour > 15 && hour < 18)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf0f;
				if (1000 * y - x * angle[(hour - 12) * 5] > -6000 && 1000 * y - x * angle[(hour - 12) * 5] < 6000 && x > 0 && y < 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else if (hour > 18 && hour <= 21)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf0f;
				if (1000 * y - x * angle[(hour - 12) * 5] > -6000 && 1000 * y - x * angle[(hour - 12) * 5] < 6000 && x < 0 && y < 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else if (hour > 21 && hour < 24)
			begin
				//test = 1'b1;
				// if (x > 0 && y > 0)
				// 	data_trans = 16'hf0f;
				if (1000 * y - x * angle[(hour - 12) * 5] > -6000 && 1000 * y - x * angle[(hour - 12) * 5] < 6000 && x < 0 && y > 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else if (hour == 12)
			begin
				if (x < 4 && x > -4 && y > 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else if (hour == 18)
			begin
				if (x < 4 && x > -4 && y < 0)
					data_trans = 16'hf0f;
				else
					data_trans = 16'h000;
			end
			else
			begin
				//test = 1'b0;
				data_trans = 16'h000;
			end
		end
	end
		
	vga_ctrl vga(
		.pclk(vga_clk),
		.reset(reset),
		.vga_data(data_trans),
		.h_addr(h_addr),
		.v_addr(v_addr),
		.hsync(hsync),
		.vsync(vsync),
		.valid(valid),
		.vga_r(vga_r),
		.vga_b(vga_b),
		.vga_g(vga_g)
		);
endmodule