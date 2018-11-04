function [ PSNR,SSIM ] = metrics( img,gt )
%在计算中转换为 double
img1=double(img); %恢复的图像 
gt1=double(gt);  %真值图
if length(size(img))==3  %对彩色图像
    [M,N,c]= size(img);
    MSE = sum(sum(sum((gt1-img1).^2)))/(M*N*c);  %均方误差
else  %对灰度图像
    [M,N] =size(img);
    MSE = sum(sum((gt1-img1).^2))/(M*N);  %均方误差
end
PSNR = 10*log10(255*255/MSE); %dB 中的 PSNR

% 对常数取标准值
%alpha=beta=gamma=1 和 C3=C2/2
C1=(0.01*255).^2;    C2 = (0.03*255).^2; %Std. 常量值
mu1= mean(gt1(:));   %真值的平均值
mu2= mean(img1(:));  %恢复图像的平均值
sig12=mean((gt1(:)-mu1).*(img1(:)-mu2)); %协方差
var1=mean((gt1(:)-mu1).^2);  %真值的差额
var2=mean((img1(:)-mu2).^2);  %恢复图像的差额

%实现 SSIM 的简化公式
SSIM = (2*mu1*mu2+C1)*(2*sig12+C2);
SSIM = SSIM/(mu1*mu1+mu2*mu2+C1);
SSIM = SSIM/(var1+var2+C2);

end

