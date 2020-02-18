function [season,p,G]=PROCESS_FOR_USE(fname)
syms p1 p2 x y
y=p1*x+p2;
season=[];pre=[];
M=readmatrix(fname);
M(:,1:2)=[];
G=M;
M=G(161:320);
% M(isnan(M))=[];
alpha=M(1:4:length(M));%1980-2019��һ����ˮ������
beta=M(2:4:length(M));%������
gamma=M(3:4:length(M));%������
zeta=M(4:4:length(M));%�ļ���
t=1:4:length(M);%1980 ��һ���� Ϊ ����1
result=createFit(t,alpha'); %һ����ˮ������ֱ�����
t=161:4:360;
temp=subs(y,[p1 p2],[result.p1 result.p2]);
season(1,:)=subs(temp,x,t); %Ԥ��2020-2069һ����ˮ��
t=2:4:length(M);
result=createFit(t,beta');
t=162:4:360;
temp=subs(y,[p1 p2],[result.p1 result.p2]);
season(2,:)=subs(temp,x,t);
t=3:4:length(M);
result=createFit(t,gamma');
t=163:4:360;
yummy=subs(y,[p1 p2],[result.p1 result.p2]);
season(3,:)=subs(yummy,x,t);
t=4:4:length(M);
result=createFit(t,zeta');
t=164:4:360;
temp=subs(y,[p1 p2],[result.p1 result.p2]);
season(4,:)=subs(temp,x,t);
% ������������
for sigma=1:4
    pre(sigma,:)=season(sigma,:)+2*(rand(1,length(t))-0.5);
end
p=pre(:);

