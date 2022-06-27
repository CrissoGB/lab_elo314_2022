%% IV)

N = 8;
n = 0:N-1;

x1 = zeros(1,N); x1(1) = 1;     % delta
x2 = ones(1,N);                 % escalon
x3 = zeros(1,N);
for nn=n
    x3(nn+1) = exp(-i*2*pi*nn/N);
end
x4 = cos(2*pi*n/N);


%%

w = 0:2*pi/N:2*pi-2*pi/N;
X1 = fft(x1); X11 = DFTsum(x1);
X2 = fft(x2); X22 = DFTsum(x2);
X3 = fft(x3); X33 = DFTsum(x3);
X4 = fft(x4); X44 = DFTsum(x4);

subplot(4,2,1)
stem(w,abs(X1))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_1")
subplot(4,2,2)
stem(w,abs(X11),'r')
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTsum() para x_1")

subplot(4,2,3)
stem(w,abs(X2))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_2")
subplot(4,2,4)
stem(w,abs(X22),'r')
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTsum() para x_2")

subplot(4,2,5)
stem(w,abs(X3))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_3")
subplot(4,2,6)
stem(w,abs(X33),'r')
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTsum() para x_3")

subplot(4,2,7)
stem(w,abs(X4))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_4")
subplot(4,2,8)
stem(w,abs(X44),'r')
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTsum() para x_4")
ylim([-inf inf])

%%

immse(X1,X11)
immse(X2,X22)
immse(X3,X33)
immse(X4,X44)


%%
function X = DFTsum(x)
    N = length(x);
    X = zeros(1,8);
    for k=0:N-1
        XK = 0;
        for nn=0:N-1
            t = 2*pi*k*nn/N;
            XK= XK + x(nn+1)*exp(-i*t);
        end
        X(k+1) = XK;
    end
end