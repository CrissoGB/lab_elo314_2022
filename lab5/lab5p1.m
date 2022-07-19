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
%soundsc(x1,fs)
L=length(x1);

t = 0:1/fs:L/fs-1/fs;
%%

audiowrite("entrenamiento.wav",x2,fs)

%%

% Segmentación de silencios
%[S11, S12] = segment(x1);
%[S21, S22] = segment(x1);
%[S31, S32] = segment(x1);

% Segmentación sin vibración de cuerda vocales. U

%[V11, V12] = segment(x1);
%[V21, V22] = segment(x1);
%[V31, V32] = segment(x1);
%[V41, V42] = segment(x1);
%[V51, V52] = segment(x1);

%%
S1 = x1(1:1675);
U1 = x1(1675:1937);
V1 = x1(1937:2242);
U2 = x1(2242:3077);
V2 = x1(3077:3887);
U3 = x1(3887:5600);
V3 = x1(5600:6003);
S2 = x1(6003:6614);
U4 = x1(6614:7241);
V4 = x1(7241:8373);
U5 = x1(8373:8758);
V5 = x1(8758:9584);
S3 = x1(9584:end);

figure
plot(t(1:1675),S1,'black'), hold on % SILENCIO 1
plot(t(1675:1937),U1,'green') % CONSONANTE S
plot(t(1937:2242),V1,'magenta') % VOCAL E
plot(t(2242:3077),U2,'green') % CONSONANTE Ñ
plot(t(3077:3887),V2,'magenta') % VOCAL A 
plot(t(3887:5600),U3,'green') % CONSONANTE L + CONSONANTE D
plot(t(5600:6003),V3,'magenta') % VOCAL E
plot(t(6003:6614),S2,'black') % SILENCIO 2
plot(t(6614:7241),U4,'green') % CONSONANTE PR
plot(t(7241:8373),V4,'magenta') % VOCALES UE
plot(t(8373:8758),U5,'green') % CONSONANTE B
plot(t(8758:9584),V5,'magenta') % VOCAL A
plot(t(9584:end),S3,'black') % SILENCIO 3

grid on 
%% Calculo de Vrms y Zero crossing count


zcS1 = zerocrossing(S1);
zcS2 = zerocrossing(S2);
zcS3 = zerocrossing(S3);

zcU1 = zerocrossing(U1);
zcU2 = zerocrossing(U2);
zcU3 = zerocrossing(U3);
zcU4 = zerocrossing(U4);
zcU5 = zerocrossing(U5);

zcV1 = zerocrossing(V1);
zcV2 = zerocrossing(V2);
zcV3 = zerocrossing(V3);
zcV4 = zerocrossing(V4);
zcV5 = zerocrossing(V5);

S1rms = rms(S1);
S2rms = rms(S2);
S3rms = rms(S3);

U1rms = rms(U1);
U2rms = rms(U2);
U3rms = rms(U3);
U4rms = rms(U4);
U5rms = rms(U5);

V1rms = rms(V1);
V2rms = rms(V2);
V3rms = rms(V3);
V4rms = rms(V4);
V5rms = rms(V5);

scatter(V1rms,zcV1,'magenta')
hold on 
scatter(V2rms,zcV2,'magenta')
scatter(V3rms,zcV3,'magenta')
scatter(V4rms,zcV4,'magenta')
scatter(V5rms,zcV5,'magenta')

scatter(U1rms,zcU1,'blue')
scatter(U2rms,zcU2,'blue')
scatter(U3rms,zcU3,'blue')
scatter(U4rms,zcU4,'blue')
scatter(U5rms,zcU5,'blue')

scatter(S1rms,zcS1,'black')
scatter(S2rms,zcS2,'black')
scatter(S3rms,zcS3,'black')

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