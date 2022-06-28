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
subplot(2,1,1)
plot(t,x1)
ylabel("amplitud")
xlabel("tiempo (s)")
title("Señal x_1(t)")
grid on
subplot(2,1,2)
plot(t,x2)
ylabel("amplitud")
xlabel("tiempo (s)")
title("Señal x_2(t)")
grid on

%% calculo de FFT (X1(w), X2(w))
N = 4096;
X1 = fft(x1,N);
X2 = fft(x2,N);

w = -pi:2*pi/N:pi-2*pi/fs;
fa = -fs/2:fs/N:fs/2-fs/N;
fb = 0:fs/N:fs-fs/N;

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
%% 
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

%% Espectro X1(w) para distintos largos N

subplot(3,2,1)
plot(w2,20*log10(abs(fftshift(X12))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_1(w) N=256")
grid on
subplot(3,2,3)
plot(w3,20*log10(abs(fftshift(X13))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_1(w) N=500")
grid on
subplot(3,2,5)
plot(w4,20*log10(abs(fftshift(X14))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_1(w) N=2048")
grid on

subplot(3,2,2)
yyaxis left
plot(w2,real(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w2,imag(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=256")
grid on

subplot(3,2,4)
yyaxis left
plot(w3,real(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w3,imag(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=500")
grid on

subplot(3,2,6)
yyaxis left
plot(w4,real(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w4,imag(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=2048")
grid on

%% Espectro X2(w) para distintos largos N

subplot(3,2,1)
plot(w2,20*log10(abs(fftshift(X22))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_2(w) N=256")
grid on
subplot(3,2,3)
plot(w3,20*log10(abs(fftshift(X23))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_2(w) N=500")
grid on
subplot(3,2,5)
plot(w4,20*log10(abs(fftshift(X24))))
axis([-pi pi -30 60])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de X_2(w) N=2048")
grid on

subplot(3,2,2)
yyaxis left
plot(w2,real(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w2,imag(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_2(w) N=256")
grid on

subplot(3,2,4)
yyaxis left
plot(w3,real(fftshift(X23)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w3,imag(fftshift(X23)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_2(w) N=500")
grid on

subplot(3,2,6)
yyaxis left
plot(w4,real(fftshift(X24)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w4,imag(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_2(w) N=2048")
grid on

%% Re|Im X1(w)

subplot(3,1,1)
yyaxis left
plot(w2,real(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w2,imag(fftshift(X12)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=256")

subplot(3,1,2)
yyaxis left
plot(w3,real(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w3,imag(fftshift(X13)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=500")

subplot(3,1,3)
yyaxis left
plot(w4,real(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Parte Real")
yyaxis right
plot(w4,imag(fftshift(X14)))
axis([-pi pi -30 60])
ylabel("Parte Imaginaria")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Espectro de X_1(w) N=2048")

%% Re|Im X2(w)

figure()
subplot(3,2,1)
plot(w2,real(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Parte real de X_2(w) N=256")
subplot(3,2,2)
plot(w2,imag(fftshift(X22)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Parte imaginaria de X_2(w) N=256")
subplot(3,2,3)
plot(w3,real(fftshift(X23)))
axis([-pi pi -30 60])
ylabel("Magnitud")
xlabel("Frecuencia Normalizada (rad/muestra)")
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
%%
x = 0.5*cos(2*pi*100*t) + 1.5*cos(2*pi*500*t);
%varianza -> sigma ^2
r = sqrt(2)*randn(1,length(x));
y = x+r;

subplot(2,1,1)
plot(t,x)
ylabel("amplitud")
xlabel("tiempo (s)")
title("Señal sin ruido")
subplot(2,1,2)
plot(t,y,'r')
ylabel("amplitud")
xlabel("tiempo (s)")
title("Señal con ruido")

%%

f = 0:fs/500:fs-fs/500;

%%
X = fft(x);
Y = fft(y);

%figure()
subplot(2,1,1)
plot(f,(abs(X)))
ylabel("Magnitud")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de la señal limpia")
axis([0 1001 -30 inf])
subplot(2,1,2)
plot(f,(abs(Y)),'r')
ylabel("Magnitud")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud del espectro de la señal con ruido")
axis([0 1001 -10 inf])

%% 20log10 amplitud en decibeles 
xmax = max(20*log10(abs(X)));
ymax = max(20*log10(abs(Y)));

%figure()
subplot(2,1,1)
plot(f,20*log10(abs(X))-xmax)
axis([0 1001 -60 10])
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud normalizada del espectro de la señal limpia en dB")
axis([0 1001 -60 10])
subplot(2,1,2)
plot(f,20*log10(abs(Y))-ymax,'r')
ylabel("Magnitud dB")
xlabel("Frecuencia Normalizada (rad/muestra)")
title("Magnitud normalizada del espectro de la señal con ruido en dB")
axis([0 1001 -60 10])

%% para un periodo de tiempo de un segundo, debe ajustarse: 
t = 0:1/fs:1-1/fs; f = 0:fs/5000:fs-fs/5000;


%% II.2)
load('fft_analysis.mat')

%%
N = 2^13;%length(modulation1);
M = 2^12;

% w = rectwin(N)';
 w = bartlett(N)';
% w = blackman(N)';
% w = hamming(N)';
% w = hann(N)';
% w = flattopwin(N)';

x1 = modulation1(1:N)'.*w;
x2 = modulation2(1:N)'.*w;

X1 = fft(x1,M);
X2 = fft(x2,M);
f = -Fs/2 : Fs/M : Fs/2 -Fs/M;

subplot(2,1,1)
plot(f, mag2db(abs(fftshift(X1))))
axis([-Fs/2 Fs/2 -20 60])
subplot(2,1,2)
plot(f, mag2db(abs(fftshift(X2))))
axis([-Fs/2 Fs/2 -20 60])


%%
N = length(distorted);M=3000;
dd = distorted;

DD = abs(fftshift(fft(dd,M)));
f = -Fs/2 : Fs/M : Fs/2 -Fs/M;

plot(f,(DD));



%% III.1) Filtrado en dominio de la frequencia.
load('nspeech.mat')
%%
x = nspeech;
N = length(x);
X = fft(x);

%%
f = 0 : fs/N : fs-fs/N;
Xx = mag2db(abs(X));
plot(f,Xx); axis([0 4000 -10 inf])
xlabel("Frecuencia (Hz)"); ylabel("Magnitud (dB)");
title("Espectro de la señal nspeech")

%%
tt = 2*pi*1685/fs;

h = [1 -2*cos(tt) 1];
%zplane(h,1)
H = fft(h,N);

subplot(1,2,1)
plot(f,abs(H));axis([0 4000 -inf inf])
xlabel("Frecuencia (Hz)"); ylabel("Magnitud")
title("Magnitud del filtro H")
subplot(1,2,2)
plot(f,angle(H),'r');axis([0 4000 -inf inf])
xlabel("Frecuencia (Hz)"); ylabel("Fase")
title("Fase del filtro H")

Y = X.*H;
y = ifft(Y,N,'symmetric');
%%
t = 0 : 1/fs : N/fs-1/fs;
%%
plot(t,x,t,y)
xlim([0 N/fs])
xlabel("tiempo (s)"); ylabel("amplitud");
title("Comparación entre señal original y señal filtrada")
legend(["Señal con tono no deseado" "Señal con tono filtrado"])






%% IV.1)

N = 8;
n = 1:N;
x = ones(1,N);
%x=cos(2*pi*n/N)-sqrt(-1)*sin(2*pi*n/N);
t=0:0.5/N:0.5-0.5/N;
figure()
plot(t,x)
X = DFTsum(x);
w = 0:2*pi/N:2*pi-2*pi/N;
figure()
stem(w,abs(X))
X2 = fft(x);
figure()
stem(w,abs(X2))
%%
function X = DFTsum(x)
    N = 8;
    X = zeros(size(N));
    for k=1:N
        XK = 0;
        for n=1:N
            theta = 2*pi*k*n/N;
            XK= XK + x(n)*(cos(theta)-sqrt(-1)*sin(theta));
        end
        X(k) = XK;

    end
end