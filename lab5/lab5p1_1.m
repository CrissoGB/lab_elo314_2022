%% I.1)
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
%sound(X,fs)
%%
XX = fft(X,fs);
w = -fs/2:fs/2-1;
figure()
plot(w,mag2db(abs(fftshift(XX))));
xlabel('Frecuencia Hz'); ylabel('Magnitud dB');
title('Magnitud del espectro del tren de pulsos entre [0 fs/2] fs=8ksps, fo=100Hz')
ylim([39.9 40.1])
xlim([0 fs/2])

%% I.2)
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
%% I.3)

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

audiowrite("matlab_vowel_a.wav",y_a,fs)
%sound(y_a,fs)
%pause(2);

y_e = filter(b,[1 e(2:end)],X);
Ye = fft(y_e);
figure()
plot(w,mag2db(abs(fftshift(Ye))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "e"')

audiowrite("matlab_vowel_e.wav",y_e,fs)
%sound(y_e,fs)
%pause(2);

y_i = filter(b,[1 i(2:end)],X);
Yi = fft(y_i);
figure()
plot(w,mag2db(abs(fftshift(Yi))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "i"')

audiowrite("matlab_vowel_i.wav",y_i,fs)
%sound(y_i,fs)
%pause(2);

y_o = filter(b,[1 o(2:end)],X);
Yo = fft(y_o);
figure()
plot(w,mag2db(abs(fftshift(Yo))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "o"')

audiowrite("matlab_vowel_o.wav",y_o,fs)
%sound(y_o,fs)
%pause(2);

y_u = filter(b,[1 u(2:end)],X);
Yu = fft(y_u);
figure()
plot(w,mag2db(abs(fftshift(Yu))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "u"')

audiowrite("matlab_vowel_u.wav",y_u,fs)
sound(y_u,fs)
%pause(2);

%% I.4) myLPC

P = 15; % filter order 
a2 = mylpc(vowel_a,P);
e2 = mylpc(vowel_e,P);
i2 = mylpc(vowel_i,P);
o2 = mylpc(vowel_o,P);
u2 = mylpc(vowel_u,P);

w=-fs/2:fs/2-1;
b = 1;

est_a = filter(b,a2,vowel_a);
est_e = filter(b,e2,vowel_e);
est_i = filter(b,i2,vowel_i);
est_o = filter(b,o2,vowel_o);
est_u = filter(b,u2,vowel_u);



Fa = fft(est_a,fs);
figure()
plot(w,mag2db(abs(fftshift(Fa))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "a"')

Fe = fft(est_e,fs);
figure()
plot(w,mag2db(abs(fftshift(Fe))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "e"')

Fi = fft(est_i,fs);
figure()
plot(w,mag2db(abs(fftshift(Fi))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "i"')

Fo = fft(est_o,fs);
figure()
plot(w,mag2db(abs(fftshift(Fo))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "o"')

Fu = fft(est_u,fs);
figure()
plot(w,mag2db(abs(fftshift(Fu))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del filtro AR modulador del tracto vocal para la vocal "u"')
%% 
%calculo de error entre coeficientes obtenidos por lpc y mylpc
err_a = immse(a,a2);
err_e = immse(e,e2);
err_i = immse(i,i2);
err_o = immse(o,o2);
err_u = immse(u,u2);
%%

w=-fs/2:fs/2-1;
b = 1;
y_a2 = filter(b,a2,X);
Ya2 = fft(y_a2);
figure()
plot(w,mag2db(abs(fftshift(Ya2))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "a"')

audiowrite("mylpc_vowel_a.wav",y_a2,fs)
%sound(y_a,fs)
%pause(2);

y_e2 = filter(b,e2,X);
Ye2 = fft(y_e2);
figure()
plot(w,mag2db(abs(fftshift(Ye2))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "e"')

audiowrite("mylpc_vowel_e.wav",y_e2,fs)
%sound(y_e,fs)
%pause(2);

y_i2 = filter(b,i2,X);
Yi2 = fft(y_i2);
figure()
plot(w,mag2db(abs(fftshift(Yi2))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "i"')

audiowrite("mylpc_vowel_i.wav",y_i2,fs)
%sound(y_i,fs)
%pause(2);

y_o2 = filter(b,o2,X);
Yo2 = fft(y_o2);
figure()
plot(w,mag2db(abs(fftshift(Yo2))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "o"')

audiowrite("mylpc_vowel_o.wav",y_o2,fs)
%sound(y_o,fs)
%pause(2);

y_u2 = filter(b,u2,X);
Yu2 = fft(y_u2);
figure()
plot(w,mag2db(abs(fftshift(Yu2))));
xlim([0 fs/2])
grid
xlabel('Frecuencia Hz')
ylabel('Magnitud dB')
title('Magnitud del espectro de la señal sintetizada para la vocal "u"')

audiowrite("mylpc_vowel_u.wav",y_u2,fs)
%sound(y_u,fs)
%pause(2);
%% 
function zc = zerocrossing(x)
    zc = 0;
    for i = 1:length(x)
        if i >1 
            if x(i)>0 && x(i-1)<0 || x(i)<0 && x(i-1)>0
                zc = zc+1;
            end
        end
    end
end

function y = mylpc(x,P)
    N = 160; % frame length
    i = 50; % lote n°i de N muestras
    sp = i*N+1; %starting point (sample)

    %vector de N muestras de x(n)
    x = x(sp:sp+N-1);

    % autocorrelación del vector x con desfase máximo P.
    rx = xcorr(x,P); % largo 2*P + 1

    % matriz Rx simétrica con toeplitz
    RxColumn = rx(P+1:end-1); % largo P rx(0:P-1)
    Rx = toeplitz(RxColumn);

    % vector xcorr corregido 
    rx2 = rx(P+2:end); % largo P rx(1:P)

    % Rx*a = rx => Rx^-1*Rx*a rx*Rx^-1 => a = Rx^-1* rx
    ag = Rx\rx2;
    a = [1 -ag.'];
    y = a; 
end

function y = mylpc2(x,P)
    N = 20; % frame length
    i = 0; % lote n°i de N muestras
    sp = i*N+1; %starting point (sample)

    %vector de N muestras de x(n)
    x = x(sp:sp+N-1);

    % autocorrelación del vector x con desfase máximo P.
    rx = xcorr(x,P); % largo 2*P + 1

    % matriz Rx simétrica con toeplitz
    RxColumn = rx(P+1:end-1); % largo P rx(0:P-1)
    Rx = toeplitz(RxColumn);

    % vector xcorr corregido 
    rx2 = rx(P+2:end); % largo P rx(1:P)

    % Rx*a = rx => Rx^-1*Rx*a rx*Rx^-1 => a = Rx^-1* rx
    ag = Rx\rx2;
    a = [1 -ag.'];
    y = a; 
end

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

%funcion de segmentación visual
function [l1,l2] = segment(x)
   plot(x)
   xlim([0 length(x)])
   [lims, ~] = ginput(2);
   lims=floor(lims);
   if lims(1)>lims(2)
       limsaux=lims(1);
       lims(1)=lims(2);
       lims(2)=limsaux;
   end
   if lims(1)<0
       lims(1)=1;
   end
   if lims(2)>length(x)
       lims(2)=lenght(x);
   end
   l1 = lims(1);
   l2 = lims(2);
end