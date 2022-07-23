%% III)

load("test_training_signals.mat");
x = test_signal;
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
subplot(5,1,1)
plot(x)
title('Señal temporal de prueba')
xlabel('muestra n')
ylabel('amplitud')
subplot(5,1,2)
plot(synth_audio)
title('Señal de prueba sintetizada previo a corrección potencia RMS')
xlabel('muestra n')
ylabel('amplitud')
subplot(5,1,3)
plot(RMS)
title('Valor RMS de la señal original, frames de 20 muestras.')
xlabel('frame n')
ylabel('Valor RMS')

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


RMS1 = zeros(length(frame_idx),1);

for k = frame_idx
    frame = synth_audio((20*(k-1)+1):20*(k));
    rms_v = rms(frame);
    RMS1(k) = rms_v;
end

coef = zeros(length(frame_idx),1);
for k = frame_idx
    if RMS1(k) == 0
        coef(k) = 0;
    else
        coef(k) = RMS(k)/RMS1(k);
    end
end

synth_frame_corr= coef.*synth_frame;
synth_audio_corr = zeros(N*length(frame_idx),1);

for k = frame_idx
        synth_audio_corr(20*(k-1)+1:k*20)=synth_frame_corr(k,:);
end
subplot(5,1,4)
plot(RMS1)
title('Valor RMS de la señal sintetizada, frames de 20 muestras.')
xlabel('frame n')
ylabel('Valor RMS')
subplot(5,1,5)
plot(synth_audio_corr)
title('Señal sintetizada con correción de potencia RMS.')
xlabel('muestra n')
ylabel('Valor RMS')

audiowrite('my_test_signal.wav',synth_audio_corr,fs)

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