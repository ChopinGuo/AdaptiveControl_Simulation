% �ɵ�����Lyapunov-MRAC

clear
close all;

% ��ֵ���ֲ����ͷ��沽������Сh��������߻��־��ȣ�
h = 0.1;
L = 100/h;

% ����������ϸ���ʵ��
num = [2 1];
den = [1 2 1];
n = length(den) - 1;

% ������������ݺ���ģ��ת��Ϊ״̬�ռ�ģ�ͣ�
kp = 1;
[Ap, Bp, Cp, Dp] = tf2ss(kp*num, den);

% �ο�ģ�Ͳ���
km = 1;
[Am, Bm, Cm, Dm] = tf2ss(km*num, den);

gamma = 0.1; % ����Ӧ����

% ��ֵ
yr0 = 0;
u0 = 0;
e0 = 0;

% ״̬������ֵ
xp0 = zeros(n,1);
xm0 = zeros(n,1);

% �ɵ������ֵ
kc0 = 0;

r = 2;
yr = r*[ones(1,L/4) -ones(1,L/4) ones(1,L/4) -ones(1,L/4)];

for k=1:L
    time(k) = k*h;
    xp(:,k) = xp0 + h*(Ap*xp0 + Bp*u0);
    yp(k) = Cp*xp(:,k);   % ����yp
    
    xm(:,k) = xm0 + h*(Am*xm0 + Bm*yr0);
    ym(k) = Cm*xm(:,k);  % ����ym
    
    e(k) = ym(k) - yp(k);         % e = ym - yp
    
    kc = kc0 + h*gamma*e0*yr0;    % Lyapunov-MARC ����Ӧ��
    
    u(k) = kc*yr(k); % ������
    
    % ��������
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
ylabel('y_m(t)��y_p(t)')

subplot(2,1,2);
plot(time,u);
xlabel('t');
ylabel('u(t)')