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
title ('Señal temporal con clasificación de segmentos S,U o V')
xlabel ('tiempos s')
ylabel('amplitud')
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
title ('Diagrama de nube de puntos Cruces-por-cero v/s Valor RMS para segmentos S, U o V')
xlabel('Valor RMS')
ylabel('Cruces por cero')
%%
% umbral rms SILENCIO
s_th = 0.036;

% umbral rms U/V y de cruces por cero
uv_th = 0.040; uv_vzc = 190;

% umbral rms Vibración de cuerdas vocales (V) 
v_th = 0.07;
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
    elseif (rms_v > uv_th && rms_v < v_th && zc_v < uv_vzc)  % Zona de incerteza U/V. 
        VUS(k) = -1;
    elseif (rms_v > uv_th && rms_v < v_th && zc_v > uv_vzc)
        VUS(k) = 1;
    elseif rms_v > v_th    % Umbral rms para determinar vocales V.
        VUS(k) = 1;
    end
end
figure()
subplot(3,1,1)
plot(x1)
title('Señal temporal de prueba')
xlabel('muestra n')
ylabel('Amplitud')
subplot(3,1,2)
stairs(VUS)
title('Variable VUS en función del frame n de 20 muestras')
xlabel('frame n')
ylabel('VUS (1,-1,0)')
ylim([-1.1,1.1])
subplot(3,1,3)
plot(RMS)
xlabel('frame n')
ylabel('valor RMS')
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