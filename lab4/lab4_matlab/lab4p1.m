clc
close all
%% I.1)
f=100;
w=2*pi*f;
fs=5000;
t = 0:1/fs:0.1-1/fs;

x1=sin(w*t);
x2=cos(w*t);

%señales x1(t) x2(t)
figure()
subplot(2,1,1)
plot(t,x1)
ylabel("amplitud")
xlabel("tiempo (s)")
title("Señal x_1(t)")
grid on
subplot(2,1,2)
plot(t,x2)
xlabel("amplitud")
ylabel("tiempo (s)")
title("Señal x_2(t)")
grid on

%calculo de FFT (X1(w), X2(w))
N = 4096;
X1 = fft(x1,N);
X2 = fft(x2,N);

w = -pi:2*pi/N:pi-2*pi/fs;
fa = -fs/2:fs/N:fs/2-fs/N;
fb = 0:fs/N:fs-fs/N;

figure()
subplot(2,1,1)
plot(fa,20*log10(abs(fftshift(X1))))
axis([-fs/2 fs/2 -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Hz")
title("Magnitud del espectro de X_1(w) N=4096")
grid on
subplot(2,1,2)
plot(fb,20*log10(abs((X1))));
ylabel("Magnitud dB")
xlabel("Frecuencia Hz")
title("Magnitud del espectro de X_1(w) N=4096")
axis([0 fs -30 60])
grid on

figure()
subplot(2,1,1)
plot(fa,20*log10(abs(fftshift(X2))))
axis([-fs/2 fs/2 -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Hz")
title("Magnitud del espectro de X_2(w) N=4096")
grid on
subplot(2,1,2)
plot(fb,20*log10(abs((X2))));
ylabel("Magnitud dB")
xlabel("Frecuencia Hz")
title("Magnitud del espectro de X_2(w) N=4096")
axis([0 fs -30 60])
grid on
%% I.2)
N2=256;
N3=500;
N4=2048;

w2 = -pi:2*pi/N2:pi-2*pi/fs;
w3 = -pi:2*pi/N3:pi-2*pi/fs;
w4 = -pi:2*pi/N4:pi-2*pi/fs;

X12 = fft(x1,N2);
X13 = fft(x1,N3);
X14 = fft(x1,N4);

X22 = fft(x2,N2);
X23 = fft(x2,N3);
X24 = fft(x2,N4);

% Espectro X1(w) para distintos largos N
figure()
subplot(3,1,1)
plot(w2,20*log10(abs(fftshift(X12))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_1(w) N=256")
grid on
subplot(3,1,2)
plot(w3,20*log10(abs(fftshift(X13))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_1(w) N=500")
grid on
subplot(3,1,3)
plot(w4,20*log10(abs(fftshift(X14))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_1(w) N=2048")
grid on

% Espectro X2(w) para distintos largos N
figure()
subplot(3,1,1)
plot(w2,20*log10(abs(fftshift(X22))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_2(w) N=256")
grid on
subplot(3,1,2)
plot(w3,20*log10(abs(fftshift(X23))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_2(w) N=500")
grid on
subplot(3,1,3)
plot(w4,20*log10(abs(fftshift(X24))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de X_2(w) N=2048")
grid on

% Re|Im X1(w)

figure()
subplot(3,2,1)
plot(w2,real(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_1(w) N=256")
subplot(3,2,2)
plot(w2,imag(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_1(w) N=256")
subplot(3,2,3)
plot(w3,real(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_1(w) N=500")
subplot(3,2,4)
plot(w3,imag(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_1(w) N=500")
subplot(3,2,5)
plot(w4,real(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_1(w) N=2048")
subplot(3,2,6)
plot(w4,imag(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_1(w) N=2048")

% Re|Im X2(w)

figure()
subplot(3,2,1)
plot(w2,real(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_2(w) N=256")
subplot(3,2,2)
plot(w2,imag(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_2(w) N=256")
subplot(3,2,3)
plot(w3,real(fftshift(X23)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_2(w) N=500")
subplot(3,2,4)
plot(w3,imag(fftshift(X23)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_2(w) N=500")
subplot(3,2,5)
plot(w4,real(fftshift(X24)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte real de X_2(w) N=2048")
subplot(3,2,6)
plot(w4,imag(fftshift(X24)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Parte imaginaria de X_2(w) N=2048")

%% II.1)
fs=5000;
t = 0:1/fs:0.1-1/fs;
x = 0.5*cos(2*pi*100*t) + 1.5*cos(2*pi*500*t);
%varianza -> sigma ^2
r = sqrt(2)*randn(1,length(x));
y = x+r;

figure()
plot(t,y)

f = 0:fs/500:fs-fs/500;
X = fft(x);
Y = fft(y);

figure()
subplot(2,1,1)
plot(f,(abs(X)))
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de la señal limpia")
axis([0 1001 -30 600])
subplot(2,1,2)
plot(f,(abs(Y)))
ylabel("Magnitud")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud del espectro de la señal con ruido")
axis([0 1001 -10 600])

%20log10 amplitud en decibeles 
xmax = max(20*log10(abs(X)));
ymax = max(20*log10(abs(Y)));

figure()
subplot(2,1,1)
plot(f,20*log10(abs(X))-xmax)
axis([0 1001 -60 10])
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud normalizada del espectro de la señal limpia en dB")
axis([0 1001 -60 10])
subplot(2,1,2)
plot(f,20*log10(abs(Y))-ymax)
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
title("Magnitud normalizada del espectro de la señal con ruido en dB")
axis([0 1001 -60 10])

%para un periodo de tiempo de un segundo, debe ajustarse: 
% t = 0:1/fs:1-1/fs; f = 0:fs;

%% III.1) Filtrado en dominio de la frequencia.

%% IV.1)

N = 8;
n = 0:N-1;

% x = e^2pin/n
x=cos(2*pi*n/N)-1i*sin(2*pi*n/N);

% x = delta()
%x = zeros(8,1);
%x(1)=1;

% x = 1
%x = ones(8,1);

% x = cos(2pin/N)
%x = cos(2*pi*n/N);
t=0:0.5/N:0.5-0.5/N;
figure()
stem(t,x)
X = DFTsum(x);
w = 0:2*pi/N:2*pi-2*pi/N;
figure()
stem(w,abs(X))
X2 = fft(x);
figure()
stem(w,abs(X2))
%% IV.2)

%% IV.3)
x1=cos(2*pi*100*t);
fs = 5000;
t = 0:1/fs:1-1/fs;
X1 = DFTsum(x1);
w = -pi:2*pi/5000:pi-2*pi/5000;
figure()
stem(w,abs(X1));

X3 = fft(x1,500);
w3 = -pi:2*pi/500:pi-2*pi/500;
stem(w3,abs(X3));

%% V.1)
N = 8;
t=0:0.5/N:0.5-0.5/N;
xe = cos(2*pi*100*t);
Xe = DFTmatrix(xe);
w = -pi:2*pi/N:pi-2*pi/N;
figure()
stem(w,abs(Xe))


%%
function A = genAmatrix(N)
    A = zeros(N);
    for k=1:N
        for n=1:N
            A(k,n)=exp(-1i*2*pi*(k-1)*(n-1)/N);
        end
    end
end

function X = DFTmatrix(x)
    A = genAmatrix(8);
    X = A*x';

end

function X = DFTsum(x)
    N = 5000;
    X = zeros(size(N));
    for k=1:N
        XK = 0;
        for n=1:N
            theta = 2*pi*(k-1)*(n-1)/N;
            XK= XK + x(n)*(cos(theta)-1i*sin(theta));
        end
        X(k) = XK;

    end
end