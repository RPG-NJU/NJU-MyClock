module KeyTranslate(
	input ready,
	input [7:0] now_data,
	input CLK_50,

	output reg out_en,// 用来标识是否准备好这按键
	output reg [7:0] ASCII
	);
	
	reg [7:0] last_data;
	reg [7:0] ASCII_MEMORY [255:0];//键码对应的ASCII码
	
	initial//初始化ASCII码存储器
	begin
		$readmemh( "ASCII.txt", ASCII_MEMORY, 0, 255);
		last_data = 8'hF0;
		out_en = 1'b0;
	end

	always @ (posedge CLK_50)
	begin
		if (ready)
		begin
			if (last_data == 8'hF0) // 如果前一个是断码
			begin
				out_en = 1'b0;
				last_data = now_data;
				//ASCII = 8'b0;
			end

			else if (now_data[7:0] == 8'hF0)
			begin
				out_en = 1'b0; // 抬起的那一瞬间，判定为无效的
				last_data = now_data;
				//ASCII = 8'b0;
			end

			else
			begin
				ASCII = ASCII_MEMORY[now_data];
				out_en = 1'b1;
				last_data = now_data;
			end
		end

		else
		begin
			//out_en = out_en;
			//last_data = last_data;
			//ASCII = 8'b0;
		end
	end

endmodule
