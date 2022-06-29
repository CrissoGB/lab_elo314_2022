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
