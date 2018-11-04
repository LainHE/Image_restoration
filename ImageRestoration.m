%EE 610 Image Processing
%Assignment-2: Image Restoration
%Author: Irina Merin Baby

function varargout = ImageRestoration(varargin)
% 代码初始化
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageRestoration_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageRestoration_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% 初始化代码结束


% --- 在 ImageRestoration 可视化前执行.
function ImageRestoration_OpeningFcn(hObject, eventdata, handles, varargin)
% 这个函数没有输出 args, 请参阅 OutputFcn.
% hObject    处理图像
% eventdata  预留 - 将在将在 MATLAB 的未来版本中定义
% handles    句柄和用户数据的结构 (请参阅 GUIDATA)
% varargin   ImageRestoration 的命令行参数 (请参阅 VARARGIN)
% 为 ImageRestoration 选择默认命令行输出
handles.output = hObject;
% 升级 handles 结构
guidata(hObject, handles);


% --- 这个函数的输出会返回到命令行.
function varargout = ImageRestoration_OutputFcn(hObject, eventdata, handles) 
% 从句柄结构中获取默认命令行输出
varargout{1} = handles.output;


% --- 在 LoadButton 中按按钮执行.
function LoadButton_Callback(hObject, eventdata, handles)
global img F M N s1
s1=1; %模糊图像通道的数字
[filename,user_cancel]=imgetfile(); %打开文件选择器来导入图像
if user_cancel  %如果用户取消了加载操作
    msgbox(sprintf('Error'),'Error','Error'); %错误消息显示
    return
end
img=imread(filename); % 读取选定的图像
img_org=img; %将 img_org 设为加载的图像

if length(size(img))==3 %彩色图像是三维矩阵
   [M,N,s1]=size(img);%如果是彩色图像
else
    [M,N]=size(img);
end   
axes(handles.axes1); %axes1 总是加载模糊图像
imshow(img_org);     
axes(handles.axes2); %axes2 恢复图像
imshow(img_org);     %最初的模糊图像
img_org=double(img_org); %转换为 double type 的计算 
F=fft2(img_org); %模糊图像的 FFT

% --- 在 LoadKerButton 中按按钮执行.
function LoadKerButton_Callback(hObject, eventdata, handles)
global ker s2
s2=1;   %卷积核通道的数字
[filename,user_cancel]=imgetfile(); %打开文件选择器来导入卷积核
if user_cancel  %如果用户取消了加载操作
    msgbox(sprintf('Error'),'Error','Error'); %错误消息显示
    return
end
ker=imread(filename); % 读取选定的卷积核
if length(size(ker))==3 %彩色图像是三维矩阵
   s2=3;  %如果是彩色图像,设 s2 为 3 
end   
axes(handles.axes3); %axes3 卷积核
imshow(ker);      
ker=double(ker);



% --- 在 InvButton 中按按钮执行.
function InvButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %零填充卷积核的FFT
if s1==3 && s2==1  %根据模糊图像调整卷积核
    H=repmat(H,1,1,3);  
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H;  %逆滤波
img=real(ifft2(Y1));
img=uint8(mat2gray(img)*255); %用 uint8 格式缩放与显示
axes(handles.axes2) %用 axes2 显示恢复的图像
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %获得 PSNR 和 SSIM 并显示
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR); 
set(handles.text8,'String',SSIM);


% --- 在 TruncButton 中按按钮执行.
function TruncButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %零填充卷积核的FFT
if s1==3 && s2==1   %根据模糊图像调整卷积核的大小
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %逆滤波
%为输入截断半径初始化提示窗口值
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; %展开窗口的名称
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %默认值 = 100

HH=Butter_LPF(M,N,r,10); %在 freq 域中得到 LPF
HH=fftshift(HH); % 分散频谱
if s1==3   % 为三通道重复
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH;  %缩短逆滤波

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255);%用 uint8 格式缩放与显示
axes(handles.axes2) %用 axes1 显示恢复的图像
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %获得 PSNR 和 SSIM 并显示
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- 在 WienerButton 中按按钮执行.
function WienerButton_Callback(hObject, eventdata, handles) 
global img F M N s1 ker s2 gt
H=fft2(ker,M,N);%零填充卷积核的FFT
if s1==3 && s2==1   %根据模糊图像调整卷积核
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end

%为K值初始化提示窗口值
prompt={'Enter the K value for Wiener Filter:'};
name='K value'; % 展开窗口的名称
K=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %默认值=0.8

Y1=F./H;
Habs=abs(H).^2;
Y3= (Y1.*Habs)./(Habs+K); %维纳滤波

img=real(ifft2(Y3));
img=uint8(mat2gray(img)*255);%用 uint8 格式缩放与显示
axes(handles.axes2) %用 axes1 显示恢复的图像
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %获得 PSNR 和 SSIM 并显示
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- 在 ClsButton 中按按钮执行.
function ClsButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %零填充卷积核的FFT
if s1==3 && s2==1 %根据模糊图像调整卷积核
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
p=[0,-1,0;-1,4,-1;0,-1,0]; %拉普拉斯算符
P=fft2(p,M,N); %这个是 fft
if s1==3     % 为三通道重复
    P=repmat(P,1,1,3);
end

%为伽马值初始化提示窗口值
prompt={'Enter the gamma value for Constrained Least Squares Filter:'};
name='Gamma value'; % 展开窗口的名称
gamma=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %默认值=0.8

Habs=abs(H).^2;
Pabs=abs(P).^2;
Y4=F.*conj(H);
Y4= Y4./(Habs+gamma*Pabs); %约束最小二乘方滤波

img=real(ifft2(Y4));
img=uint8(mat2gray(img)*255); %用 uint8 格式缩放与显示
axes(handles.axes2) %用 axes1 显示恢复的图像
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %获得 PSNR 和 SSIM 并显示
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);

% --- 在 EstButton 中按按钮执行.
function EstButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2
set(handles.text7,'Visible','off'); %无法找到 PSNR 和 SSIM
set(handles.text8,'Visible','off'); %估计模糊的情况
cla(handles.axes4);  %当真值不可用时清除真值显示 (Ground truth)
s2=1;
[filename,user_cancel]=imgetfile(); %打开文件选择器来导入估计的卷积核
if user_cancel  %如果用户取消了加载操作
    msgbox(sprintf('Error'),'Error','Error'); %错误消息显示
    return
end
ker=imread(filename); % 读取选取的卷积核
if length(size(ker))==3 %彩色图像是三维矩阵
   s2=3;  %如果是彩色图像,设 s2 为 3 
end   
axes(handles.axes3); %axes3 预估卷积核图像
imshow(ker);     
ker=double(ker); %为了计算
H=fft2(ker,M,N);  %零填充卷积核的FFT
if s1==3 && s2==1 %根据模糊图像调整卷积核
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %逆滤波
%为输入截断半径初始化提示窗口值
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; % 展开窗口的名称
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %默认值=100

HH=Butter_LPF(M,N,r,10);%在 freq 域中得到 LPF
HH=fftshift(HH); %分散频谱
if s1==3   % 为三通道重复
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH; %缩短逆滤波

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255); %用 uint8 格式缩放与显示
axes(handles.axes2) %用 axes2 显示恢复的图像
imshow(img);



% --- 在 GtButton 中按按钮执行.
function GtButton_Callback(hObject, eventdata, handles)
global gt
[filename,user_cancel]=imgetfile(); %打开文件选择器来导入真值图 (Ground truth image)
if user_cancel  %如果用户取消了加载操作
    msgbox(sprintf('Error'),'Error','Error'); %错误消息显示
    return
end
gt=imread(filename); % 读取选取的真值图
axes(handles.axes4); %axes4 真值图
imshow(gt);      



% --- 在 SaveButton 中按按钮执行.
function SaveButton_Callback(hObject, eventdata, handles)
global img %恢复的图像, 如., image in axes2 is saved
[fn, ext, ucancel] = imputfile; %打开文件选择器供用户指定保存的图像路径
imwrite(img,fn); %将图像写入选定的文件夹
