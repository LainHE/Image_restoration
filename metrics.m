function [ PSNR,SSIM ] = metrics( img,gt )
%�ڼ�����ת��Ϊ double
img1=double(img); %�ָ���ͼ�� 
gt1=double(gt);  %��ֵͼ
if length(size(img))==3  %�Բ�ɫͼ��
    [M,N,c]= size(img);
    MSE = sum(sum(sum((gt1-img1).^2)))/(M*N*c);  %�������
else  %�ԻҶ�ͼ��
    [M,N] =size(img);
    MSE = sum(sum((gt1-img1).^2))/(M*N);  %�������
end
PSNR = 10*log10(255*255/MSE); %dB �е� PSNR

% �Գ���ȡ��׼ֵ
%alpha=beta=gamma=1 �� C3=C2/2
C1=(0.01*255).^2;    C2 = (0.03*255).^2; %Std. ����ֵ
mu1= mean(gt1(:));   %��ֵ��ƽ��ֵ
mu2= mean(img1(:));  %�ָ�ͼ���ƽ��ֵ
sig12=mean((gt1(:)-mu1).*(img1(:)-mu2)); %Э����
var1=mean((gt1(:)-mu1).^2);  %��ֵ�Ĳ��
var2=mean((img1(:)-mu2).^2);  %�ָ�ͼ��Ĳ��

%ʵ�� SSIM �ļ򻯹�ʽ
SSIM = (2*mu1*mu2+C1)*(2*sig12+C2);
SSIM = SSIM/(mu1*mu1+mu2*mu2+C1);
SSIM = SSIM/(var1+var2+C2);

end

