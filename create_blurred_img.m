clear all;close all;clc;

f = imread('GroundTruth\GroundTruth1_1_1.jpg'); %��ȡ��ֵͼ (ground truth image)
[M,N,c]=size(f);
figure,imshow(f);
f=double(f);

h = imread('Kernals\Ker1_3d.png');  %��ȡ�����
h=double(h);
[A,B]=size(h);

F=fft2(f);    %ȡ FFT
H=fft2(h,M,N);
Y=F.*H;        %ʱ���еľ�� = Ƶ���еĳ˷�
y1=real(ifft2(Y));
y=mat2gray(y1);  %���ŵ� 0 �� 1
fi= uint8(y*255);  %���ŵ� 0-255 ����ʾΪ uint8 ��ʽ
figure,imshow(fi);
imwrite(fi,'img_blurry.jpg','jpg'); %���洴����ģ��ͼ��


