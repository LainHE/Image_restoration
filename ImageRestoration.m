%EE 610 Image Processing
%Assignment-2: Image Restoration
%Author: Irina Merin Baby

function varargout = ImageRestoration(varargin)
% �����ʼ��
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
% ��ʼ���������


% --- �� ImageRestoration ���ӻ�ǰִ��.
function ImageRestoration_OpeningFcn(hObject, eventdata, handles, varargin)
% �������û����� args, ����� OutputFcn.
% hObject    ����ͼ��
% eventdata  Ԥ�� - ���ڽ��� MATLAB ��δ���汾�ж���
% handles    ������û����ݵĽṹ (����� GUIDATA)
% varargin   ImageRestoration �������в��� (����� VARARGIN)
% Ϊ ImageRestoration ѡ��Ĭ�����������
handles.output = hObject;
% ���� handles �ṹ
guidata(hObject, handles);


% --- �������������᷵�ص�������.
function varargout = ImageRestoration_OutputFcn(hObject, eventdata, handles) 
% �Ӿ���ṹ�л�ȡĬ�����������
varargout{1} = handles.output;


% --- �� LoadButton �а���ťִ��.
function LoadButton_Callback(hObject, eventdata, handles)
global img F M N s1
s1=1; %ģ��ͼ��ͨ��������
[filename,user_cancel]=imgetfile(); %���ļ�ѡ����������ͼ��
if user_cancel  %����û�ȡ���˼��ز���
    msgbox(sprintf('Error'),'Error','Error'); %������Ϣ��ʾ
    return
end
img=imread(filename); % ��ȡѡ����ͼ��
img_org=img; %�� img_org ��Ϊ���ص�ͼ��

if length(size(img))==3 %��ɫͼ������ά����
   [M,N,s1]=size(img);%����ǲ�ɫͼ��
else
    [M,N]=size(img);
end   
axes(handles.axes1); %axes1 ���Ǽ���ģ��ͼ��
imshow(img_org);     
axes(handles.axes2); %axes2 �ָ�ͼ��
imshow(img_org);     %�����ģ��ͼ��
img_org=double(img_org); %ת��Ϊ double type �ļ��� 
F=fft2(img_org); %ģ��ͼ��� FFT

% --- �� LoadKerButton �а���ťִ��.
function LoadKerButton_Callback(hObject, eventdata, handles)
global ker s2
s2=1;   %�����ͨ��������
[filename,user_cancel]=imgetfile(); %���ļ�ѡ��������������
if user_cancel  %����û�ȡ���˼��ز���
    msgbox(sprintf('Error'),'Error','Error'); %������Ϣ��ʾ
    return
end
ker=imread(filename); % ��ȡѡ���ľ����
if length(size(ker))==3 %��ɫͼ������ά����
   s2=3;  %����ǲ�ɫͼ��,�� s2 Ϊ 3 
end   
axes(handles.axes3); %axes3 �����
imshow(ker);      
ker=double(ker);



% --- �� InvButton �а���ťִ��.
function InvButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %��������˵�FFT
if s1==3 && s2==1  %����ģ��ͼ����������
    H=repmat(H,1,1,3);  
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H;  %���˲�
img=real(ifft2(Y1));
img=uint8(mat2gray(img)*255); %�� uint8 ��ʽ��������ʾ
axes(handles.axes2) %�� axes2 ��ʾ�ָ���ͼ��
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %��� PSNR �� SSIM ����ʾ
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR); 
set(handles.text8,'String',SSIM);


% --- �� TruncButton �а���ťִ��.
function TruncButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %��������˵�FFT
if s1==3 && s2==1   %����ģ��ͼ���������˵Ĵ�С
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %���˲�
%Ϊ����ضϰ뾶��ʼ����ʾ����ֵ
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; %չ�����ڵ�����
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %Ĭ��ֵ = 100

HH=Butter_LPF(M,N,r,10); %�� freq ���еõ� LPF
HH=fftshift(HH); % ��ɢƵ��
if s1==3   % Ϊ��ͨ���ظ�
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH;  %�������˲�

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255);%�� uint8 ��ʽ��������ʾ
axes(handles.axes2) %�� axes1 ��ʾ�ָ���ͼ��
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %��� PSNR �� SSIM ����ʾ
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- �� WienerButton �а���ťִ��.
function WienerButton_Callback(hObject, eventdata, handles) 
global img F M N s1 ker s2 gt
H=fft2(ker,M,N);%��������˵�FFT
if s1==3 && s2==1   %����ģ��ͼ����������
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end

%ΪKֵ��ʼ����ʾ����ֵ
prompt={'Enter the K value for Wiener Filter:'};
name='K value'; % չ�����ڵ�����
K=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %Ĭ��ֵ=0.8

Y1=F./H;
Habs=abs(H).^2;
Y3= (Y1.*Habs)./(Habs+K); %ά���˲�

img=real(ifft2(Y3));
img=uint8(mat2gray(img)*255);%�� uint8 ��ʽ��������ʾ
axes(handles.axes2) %�� axes1 ��ʾ�ָ���ͼ��
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %��� PSNR �� SSIM ����ʾ
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);


% --- �� ClsButton �а���ťִ��.
function ClsButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2 gt
H=fft2(ker,M,N); %��������˵�FFT
if s1==3 && s2==1 %����ģ��ͼ����������
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
p=[0,-1,0;-1,4,-1;0,-1,0]; %������˹���
P=fft2(p,M,N); %����� fft
if s1==3     % Ϊ��ͨ���ظ�
    P=repmat(P,1,1,3);
end

%Ϊ٤��ֵ��ʼ����ʾ����ֵ
prompt={'Enter the gamma value for Constrained Least Squares Filter:'};
name='Gamma value'; % չ�����ڵ�����
gamma=str2double(inputdlg(prompt,name,[1 60],{'0.8'})); %Ĭ��ֵ=0.8

Habs=abs(H).^2;
Pabs=abs(P).^2;
Y4=F.*conj(H);
Y4= Y4./(Habs+gamma*Pabs); %Լ����С���˷��˲�

img=real(ifft2(Y4));
img=uint8(mat2gray(img)*255); %�� uint8 ��ʽ��������ʾ
axes(handles.axes2) %�� axes1 ��ʾ�ָ���ͼ��
imshow(img);
[PSNR,SSIM]=metrics(gt,img); %��� PSNR �� SSIM ����ʾ
set(handles.text7,'Visible','on');
set(handles.text8,'Visible','on');
set(handles.text7,'String',PSNR);
set(handles.text8,'String',SSIM);

% --- �� EstButton �а���ťִ��.
function EstButton_Callback(hObject, eventdata, handles)
global img F M N s1 ker s2
set(handles.text7,'Visible','off'); %�޷��ҵ� PSNR �� SSIM
set(handles.text8,'Visible','off'); %����ģ�������
cla(handles.axes4);  %����ֵ������ʱ�����ֵ��ʾ (Ground truth)
s2=1;
[filename,user_cancel]=imgetfile(); %���ļ�ѡ������������Ƶľ����
if user_cancel  %����û�ȡ���˼��ز���
    msgbox(sprintf('Error'),'Error','Error'); %������Ϣ��ʾ
    return
end
ker=imread(filename); % ��ȡѡȡ�ľ����
if length(size(ker))==3 %��ɫͼ������ά����
   s2=3;  %����ǲ�ɫͼ��,�� s2 Ϊ 3 
end   
axes(handles.axes3); %axes3 Ԥ�������ͼ��
imshow(ker);     
ker=double(ker); %Ϊ�˼���
H=fft2(ker,M,N);  %��������˵�FFT
if s1==3 && s2==1 %����ģ��ͼ����������
    H=repmat(H,1,1,3);
elseif s1==1 && s2==3
    H=H(:,:,1);
end
Y1=F./H; %���˲�
%Ϊ����ضϰ뾶��ʼ����ʾ����ֵ
prompt={'Enter the radius for Radially Truncated Filter:'};
name='Radius of Truncation'; % չ�����ڵ�����
r=str2double(inputdlg(prompt,name,[1 60],{'100'})); %Ĭ��ֵ=100

HH=Butter_LPF(M,N,r,10);%�� freq ���еõ� LPF
HH=fftshift(HH); %��ɢƵ��
if s1==3   % Ϊ��ͨ���ظ�
HH=repmat(HH,1,1,3);
end
Y2=Y1.*HH; %�������˲�

img=real(ifft2(Y2));
img=uint8(mat2gray(img)*255); %�� uint8 ��ʽ��������ʾ
axes(handles.axes2) %�� axes2 ��ʾ�ָ���ͼ��
imshow(img);



% --- �� GtButton �а���ťִ��.
function GtButton_Callback(hObject, eventdata, handles)
global gt
[filename,user_cancel]=imgetfile(); %���ļ�ѡ������������ֵͼ (Ground truth image)
if user_cancel  %����û�ȡ���˼��ز���
    msgbox(sprintf('Error'),'Error','Error'); %������Ϣ��ʾ
    return
end
gt=imread(filename); % ��ȡѡȡ����ֵͼ
axes(handles.axes4); %axes4 ��ֵͼ
imshow(gt);      



% --- �� SaveButton �а���ťִ��.
function SaveButton_Callback(hObject, eventdata, handles)
global img %�ָ���ͼ��, ��., image in axes2 is saved
[fn, ext, ucancel] = imputfile; %���ļ�ѡ�������û�ָ�������ͼ��·��
imwrite(img,fn); %��ͼ��д��ѡ�����ļ���
