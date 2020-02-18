D=450.17; % distance between Scotland and Norway (unit:km)
syms miu T1(x,t) T2(x) c(x) t x g
T1(x,t)=(20*(t-160)*tan(0.006369*(x-D/2)));
T2(x)=(50-49.5*sin(2.5/450.17*x));
% c(x)=1-x/D; %第3问
c(x)=3*(cos(pi/(2*D)*x))^(1/2)-2; %第4问
%产量函数，季度t和外海捕捞的渔船比例miu (0<=miu<=1) 的二元函数
P=int((1-miu)*(T1(x,t)+T2(x))*c(x),x,0,D/2)+int(miu*(T1(x,t)+T2(x))*c(x),x,D/2,D);
p=[];
g=0;
% 固定季度，解P关于miu的约束极值问题,求max P
for tt=163:4:360
    y=subs(P,t,tt);
    g=-y;
    g=matlabFunction(g);
    [u,yval]=fminbnd(g,0,1);
    p=[p;tt u -yval];
end
q=abs(p);
T=table;
T.season=q(:,1);
T.miu=q(:,2);
T.production=q(:,3);
% 预测结果，各季度外海捕捞渔船比例和渔获量
writetable(T,'./optim/4.xlsx');
close all
season=q(:,1);
production=q(:,3);
plot(season,production)
xlabel('season')
ylabel('total catch')