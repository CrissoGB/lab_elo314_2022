%En este laboratorio se estudiará una aplicación particular del procesamiento digital de señales en la cual se
% manipulan señales de audio asociadas a la voz humana, lo que permite extender conceptos de análisis espectral,
% introducir modelos auto-regresivos e ideas de compresión de señales en función a dichos modelos.

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

%sound(y_u,fs)
%pause(2);

%% I.4) myLPC
x_in = vowel_a; % input
P = 15; % filter order 
a = mylpc(x_in,P);
w=-fs/2:fs/2-1;
b = 1;
y_a = filter(b,a,X);
soundsc(y_a,fs)
%%
Ya = fft(y_a);
figure()
plot(w,mag2db(abs(fftshift(Ya))))

%% II.1) Segmento VUS 
load("test_training_signals.mat");

x1 = test_signal;
x2 = training_signal;
soundsc(x2,fs)
L=length(x1);

t = 0:1/fs:L/fs-1/fs;
% [u1,u2] = segment(x2);

%% Segmentos SUV 

S1 = 1:2000;
U1 = 2000:3060;
V1 = 3060:3600;
U2 = 3600:4150;
V2 = 4150:5400;
U3 = 5400:5800;
V3 = 5800:6690;
U4 = 6690:7830;
S2 = 7830:8400;
U5 = 8400:8700;
V4 = 8700:9200;
U6 = 9200:10200;
U7 = 10200:10500;
V5 = 10500:10800;
U8 = 10800:11000;
V6 = 11000:11900;
U9 = 11900:12500;
V7 = 12500:13400;
U10 = 13400:15450;
S3 = 15450:15920;
%% PLOT de los segmentos VUS (manual)
figure
plot(t(S1),x2(S1),'black'), hold on % SILENCIOS
plot(t(S2),x2(S2),'black')
plot(t(S3),x2(S3),'black')

plot(t(U1),x2(U1),'green') % CONSONANTES
plot(t(U2),x2(U2),'green')
plot(t(U3),x2(U3),'green')
plot(t(U4),x2(U4),'green')
plot(t(U5),x2(U5),'green')
plot(t(U6),x2(U6),'green')
plot(t(U7),x2(U7),'green')
plot(t(U8),x2(U8),'green')
plot(t(U9),x2(U9),'green')
plot(t(U10),x2(U10),'green')

plot(t(V1),x2(V1),'magenta') % VOCALES
plot(t(V2),x2(V2),'magenta')
plot(t(V3),x2(V3),'magenta')
plot(t(V4),x2(V4),'magenta')
plot(t(V5),x2(V5),'magenta')
plot(t(V6),x2(V6),'magenta')
plot(t(V7),x2(V7),'magenta')

grid on 
hold off 
%% Calculo de Vrms y Zero crossing count

zcS1 = zerocrossing(x2(S1));
zcS2 = zerocrossing(x2(S2));
zcS3 = zerocrossing(x2(S3));

zcU1 = zerocrossing(x2(U1));
zcU2 = zerocrossing(x2(U2));
zcU3 = zerocrossing(x2(U3));
zcU4 = zerocrossing(x2(U4));
zcU5 = zerocrossing(x2(U5));
zcU6 = zerocrossing(x2(U6));
zcU7 = zerocrossing(x2(U7));
zcU8 = zerocrossing(x2(U8));
zcU9 = zerocrossing(x2(U9));
zcU10 = zerocrossing(x2(U10));

zcV1 = zerocrossing(x2(V1));
zcV2 = zerocrossing(x2(V2));
zcV3 = zerocrossing(x2(V3));
zcV4 = zerocrossing(x2(V4));
zcV5 = zerocrossing(x2(V5));
zcV6 = zerocrossing(x2(V6));
zcV7 = zerocrossing(x2(V7));


S1rms = rms(x2(S1));
S2rms = rms(x2(S2));
S3rms = rms(x2(S3));


U1rms = rms(x2(U1));
U2rms = rms(x2(U2));
U3rms = rms(x2(U3));
U4rms = rms(x2(U4));
U5rms = rms(x2(U5));
U6rms = rms(x2(U6));
U7rms = rms(x2(U7));
U8rms = rms(x2(U8));
U9rms = rms(x2(U9));
U10rms = rms(x2(U10));

V1rms = rms(x2(V1));
V2rms = rms(x2(V2));
V3rms = rms(x2(V3));
V4rms = rms(x2(V4));
V5rms = rms(x2(V5));
V6rms = rms(x2(V6));
V7rms = rms(x2(V7));

figure()
scatter(V1rms,zcV1,'magenta')
hold on 
scatter(V2rms,zcV2,'magenta')
scatter(V3rms,zcV3,'magenta')
scatter(V4rms,zcV4,'magenta')
scatter(V5rms,zcV5,'magenta')
scatter(V6rms,zcV6,'magenta')
scatter(V7rms,zcV7,'magenta')

scatter(U1rms,zcU1,'blue')
scatter(U2rms,zcU2,'blue')
scatter(U3rms,zcU3,'blue')
scatter(U4rms,zcU4,'blue')
scatter(U5rms,zcU5,'blue')
scatter(U6rms,zcU6,'blue')
scatter(U7rms,zcU7,'blue')
scatter(U8rms,zcU8,'blue')
scatter(U9rms,zcU9,'blue')
scatter(U10rms,zcU10,'blue')

scatter(S1rms,zcS1,'black')
scatter(S2rms,zcS2,'black')
scatter(S3rms,zcS3,'black')
%%
% umbral rms SILENCIO
s_th = 0.08;

% umbral rms U/V 
uv_th = 0.040; uv_vzc = 180;

% umbral rms V 
v_th = 0.0725;
%% II.2) 

l = length(x1); 
frame_idx = 1:l/20; % lotes de muestras.

VUS = zeros(length(frame_idx),1); % Salida VUS (1,-1,0).
RMS = zeros(length(frame_idx),1);

for k = 1:length(frame_idx)
    frame = x1((20*(k-1)+1):20*(k)); % Muestreado en frames.
    rms_v = rms(frame);   % RMS del frame de 20 muestras.
    zc_v = zerocrossing(frame); % Cruces por cero del frame.
    RMS(k) = rms_v;
    if (rms_v < s_th)   % Umbral de rms para determinar Silencio.
        VUS(k) = 0;
    elseif (rms_v>s_th && rms_v<uv_th)
        VUS(k) = -1;
    elseif (rms_v < uv_th && zc_v <200)  % Zona de incerteza U/V. 
        VUS(k) = -1;
    elseif (rms_v < uv_th && zc_v > 200)
        VUS(k) = 1;
    else                            % Umbral rms para determinar vocales V.
        VUS(k) = 1;
    end
end
figure()
subplot(3,1,1)
plot(x1)
subplot(3,1,2)
stairs(VUS)
subplot(3,1,3)
plot(RMS)

%% III)

load("test_training_signals.mat");
x = training_signal;
N = length(x);
t = 0:1/fs:N/fs-1/fs;
fo = 100; %frecuencia fundamental Hz
T = (1/fo); % periodo en segundos
Np = round(fs*T); % periodo en muestras del tren de impulsos

frame_idx = 1:N/20; % lotes de muestras.

VUS = zeros(length(frame_idx),1); % Salida VUS (1,-1,0).
RMS = zeros(length(frame_idx),1);
Acoeff = zeros(length(frame_idx),16);

for k = frame_idx
    frame = x((20*(k-1)+1):20*(k)); % Muestreado en frames.
    rms_v = rms(frame);   % RMS del frame de 20 muestras.
    zc_v = zerocrossing(frame); % Cruces por cero del frame.
    RMS(k) = rms_v;
    Acoeff(k,:) = mylpc2(frame,15);
    if (rms_v < s_th)   % Umbral de rms para determinar Silencio.
        VUS(k) = 0;
    elseif (rms_v < uv_th && zc_v <200)  % Zona de incerteza U/V. 
        VUS(k) = -1;
    elseif (rms_v < uv_th && zc_v > 200)
        VUS(k) = 1;
    else                            % Umbral rms para determinar vocales V.
        VUS(k) = 1;
    end
end

N = 20;
X = exciteV(20,Np);
X1 = rand(1,20);

synth_frame = zeros(length(frame_idx),20);

for k = frame_idx
    if VUS(k) ==1
        synth_frame(k,:) = filter(1,Acoeff(k,:),X);
    elseif VUS(k) ==-1
        synth_frame(k,:) = filter(1,Acoeff(k,:),X1);
    else 
        synth_frame(k,:) = zeros(N,1);
    end
end

synth_audio = zeros(N*length(frame_idx),1);

for k = frame_idx
        synth_audio(20*(k-1)+1:k*20)=synth_frame(k,:);
end

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