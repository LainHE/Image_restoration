function [ bw_filter ] = Butter_LPF(M,N,d0,n)
bw_filter=zeros(M,N);

%d0	 = 截止频率
%n 	 = 巴特沃斯滤波的顺序

for i=1:M
    for j=1:N
        dist=((i-M/2)^2 + (j-N/2)^2)^0.5; % 距离取自中心而不是原点
        bw_filter(i,j)= ( 1 + (dist/d0)^(2*n))^(-1); %巴特沃斯 LPF 的公式
        
    end
end

end

