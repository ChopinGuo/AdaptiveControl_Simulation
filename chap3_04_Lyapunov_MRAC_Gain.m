% 可调增益Lyapunov-MRAC

clear
close all;

% 数值积分步长和仿真步数（减小h，可以提高积分精度）
h = 0.1;
L = 100/h;

% 对象参数（严格正实）
num = [2 1];
den = [1 2 1];
n = length(den) - 1;

% 对象参数（传递函数模型转化为状态空间模型）
kp = 1;
[Ap, Bp, Cp, Dp] = tf2ss(kp*num, den);

% 参考模型参数
km = 1;
[Am, Bm, Cm, Dm] = tf2ss(km*num, den);

gamma = 0.1; % 自适应增益

% 初值
yr0 = 0;
u0 = 0;
e0 = 0;

% 状态变量初值
xp0 = zeros(n,1);
xm0 = zeros(n,1);

% 可调增益初值
kc0 = 0;

r = 2;
yr = r*[ones(1,L/4) -ones(1,L/4) ones(1,L/4) -ones(1,L/4)];

for k=1:L
    time(k) = k*h;
    xp(:,k) = xp0 + h*(Ap*xp0 + Bp*u0);
    yp(k) = Cp*xp(:,k);   % 计算yp
    
    xm(:,k) = xm0 + h*(Am*xm0 + Bm*yr0);
    ym(k) = Cm*xm(:,k);  % 计算ym
    
    e(k) = ym(k) - yp(k);         % e = ym - yp
    
    kc = kc0 + h*gamma*e0*yr0;    % Lyapunov-MARC 自适应律
    
    u(k) = kc*yr(k); % 控制量
    
    % 更新数据
    yr0 = yr(k);
    u0 = u(k);
    e0 = e(k);
    xp0 = xp(:,k);
    xm0 = xm(:,k);
    kc0 = kc;
    
end

subplot(2,1,1);
plot(time,ym,'r',time,yp,':');
xlabel('t');
ylabel('y_m(t)、y_p(t)')

subplot(2,1,2);
plot(time,u);
xlabel('t');
ylabel('u(t)')