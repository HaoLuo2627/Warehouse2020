function [season,p,G]=PROCESS_FOR_USE(fname)
syms p1 p2 x y
y=p1*x+p2;
season=[];pre=[];
M=readmatrix(fname);
M(:,1:2)=[];
G=M;
M=G(161:320);
% M(isnan(M))=[];
alpha=M(1:4:length(M));%1980-2019第一季度水温数据
beta=M(2:4:length(M));%二季度
gamma=M(3:4:length(M));%三季度
zeta=M(4:4:length(M));%四季度
t=1:4:length(M);%1980 第一季度 为 季度1
result=createFit(t,alpha'); %一季度水温数据直线拟合
t=161:4:360;
temp=subs(y,[p1 p2],[result.p1 result.p2]);
season(1,:)=subs(temp,x,t); %预测2020-2069一季度水温
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
% 加入随机误差项
for sigma=1:4
    pre(sigma,:)=season(sigma,:)+2*(rand(1,length(t))-0.5);
end
p=pre(:);

