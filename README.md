# Image_restoration

图像处理从内核恢复模糊的图像.

"ImageRestoration.m" - 在Matlab中实现了一个GUI，用于应用逆滤波、截断逆滤波、维纳滤波和约束最小二乘滤波
"metrics.m" - 一个用户定义的函数用于计算 PSNR 和 SSIM. 在 "ImageRestoration.m" 中被调用

"Butter_LPF.m" - 一个用户定义的函数用于创建具有指定半径和顺序的转换域中巴特沃斯滤波
"Sample_Images" - 文件夹包含一些模糊的图像,卷积核和真值图
"create_blurred_img" - 一个代码用于创建模糊的图像, 如果 真值图和模糊核已知的话