%% Parte 2.2

[x, Fs] = audioread('gtr-jazz_16_48.wav');
x = x(:,1);     % un solo canal

xgd = x;        % señal de entrada
xgd = resample(xgd, 16, 48); Fs = 1/3*Fs;

N = 4;          % numero de etapas de retardo
l = 0.250;      % longitud en s de la etapa de retardo.
b_k = 0.35;     % ganancia por etapa de retardo
M = l*Fs;       % # de muestras equivalentes a la longitud de cada retardo

gtdelay = zeros(size(xgd)); % salida

for i = 1:length(xgd)
    dval_aux = 0;
    for k = 1:N
       if(i-k*M>0)      % asegura causalidad (y evita errores)
           dval_aux = dval_aux + b_k^k*xgd(i-k*M); 
           % ganancia: variable -> b_k^k | constante -> b_k
       else
           break
       end
    end
    gtdelay(i) = xgd(i) + dval_aux;
end