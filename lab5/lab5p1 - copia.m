%En este laboratorio se estudiará una aplicación particular del procesamiento digital de señales en la cual se
% manipulan señales de audio asociadas a la voz humana, lo que permite extender conceptos de análisis espectral,
% introducir modelos auto-regresivos e ideas de compresión de señales en función a dichos modelos.

fs = 8000; % frecuencia de muestreo ksps
t = 0:1/fs:1-1/fs;
fo = 100; %frecuencia fundamental Hz
N = fs*1; % numero de muestras totales (1 s)
T = (1/fo); % periodo en segundos
Np = round(fs*T); % periodo en muestras del tren de impulsos
X = exciteV(N,Np);

%%
figure()
stem(t,X);
xlabel('tiempo s'); ylabel('amplitud');
title('Tren de pulsos fs=8ksps, fo=100Hz')
sound(X,fs)
%%
cont=0;
for i=1:N-1
    if X(i) == 1
        cont=cont+1;
    end
end
%%
XX = fft(X,fs);
w = -fs/2:fs/2-1;
figure()
plot(w,mag2db(abs(fftshift(XX))));
xlabel('Frecuencia Hz'); ylabel('Magnitud dB');
title('Magnitud del espectro del tren de pulsos entre [0 fs/2] fs=8ksps, fo=100Hz')
ylim([39.9 40.1])
xlim([0 fs/2])

%%
load("vowels.mat");

%%
a = lpc(vowel_a,15);
e = lpc(vowel_e,15);
i = lpc(vowel_i,15);
o = lpc(vowel_o,15);
u = lpc(vowel_u,15);

est_a = filter(1,a,vowel_a);
est_e = filter(1,e,vowel_e);
est_i = filter(1,i,vowel_i);
est_o = filter(1,o,vowel_o);
est_u = filter(1,u,vowel_u);

% plot(1:fs,vowel_a(end-fs+1:end),1:fs,est_a(end-fs+1:end),'--')
%grid
%xlabel('Sample Number')
%ylabel('Amplitude')
%legend('Original signal','LPC estimate')

Fa = fft(est_a,fs);
figure()
w=-fs/2:fs/2-1;
plot(w,mag2db(abs(fftshift(Fa))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "a"')

Fe = fft(est_e,fs);
figure()
w=-fs/2:fs/2-1;
plot(w,mag2db(abs(fftshift(Fe))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "e"')

Fi = fft(est_i,fs);
figure()
w=-fs/2:fs/2-1;
plot(w,mag2db(abs(fftshift(Fi))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "i"')

Fo = fft(est_o,fs);
figure()
w=-fs/2:fs/2-1;
plot(w,mag2db(abs(fftshift(Fo))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "o"')

Fu = fft(est_u,fs);
figure()
w=-fs/2:fs/2-1;
plot(w,mag2db(abs(fftshift(Fu))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "u"')
%% 

w=-fs/2:fs/2-1;
b = 1;
y_a = filter(b,[1 a(2:end)],X);
Ya = fft(y_a);
figure()
plot(w,mag2db(abs(fftshift(Ya))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "a"')

sound(y_a,fs)
pause(2);

y_e = filter(b,[1 e(2:end)],X);
Ye = fft(y_e);
figure()
plot(w,mag2db(abs(fftshift(Ye))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "e"')

sound(y_e,fs)
pause(2);

y_i = filter(b,[1 i(2:end)],X);
Yi = fft(y_i);
figure()
plot(w,mag2db(abs(fftshift(Yi))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "i"')

sound(y_i,fs)
pause(2);

y_o = filter(b,[1 o(2:end)],X);
Yo = fft(y_o);
figure()
plot(w,mag2db(abs(fftshift(Yo))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "o"')

sound(y_o,fs)
pause(2);

y_u = filter(b,[1 u(2:end)],X);
Yu = fft(y_u);
figure()
plot(w,mag2db(abs(fftshift(Yu))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "u"')

sound(y_u,fs)
pause(2);
%%
function X = exciteV(N,Np)
    
    X = zeros(length(N));
    X(1) = 1;

    for i=2:N
        if mod(i,Np)==0
            X(i)=1;
        else 
            X(i)=0;
        end
    end
end