clear all;close all;clc;

f = imread('GroundTruth\GroundTruth1_1_1.jpg'); %读取真值图 (ground truth image)
[M,N,c]=size(f);
figure,imshow(f);
f=double(f);

h = imread('Kernals\Ker1_3d.png');  %读取卷积核
h=double(h);
[A,B]=size(h);

F=fft2(f);    %取 FFT
H=fft2(h,M,N);
Y=F.*H;        %时间中的卷积 = 频率中的乘法
y1=real(ifft2(Y));
y=mat2gray(y1);  %缩放到 0 到 1
fi= uint8(y*255);  %缩放到 0-255 并显示为 uint8 格式
figure,imshow(fi);
imwrite(fi,'img_blurry.jpg','jpg'); %保存创建的模糊图像


