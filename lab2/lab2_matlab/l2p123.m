%% Parte 2.2

[x, Fs] = audioread('gtr-jazz_16_48.wav');

x = x(:,1); % un solo canal
N = 4;
s = 0.125;  % longitud de cada retardo en segundos
M = Fs*s;   % longitud de cada retardo en muestras
bk = 0.35;

buffer = zeros(1,N*M);
y = zeros(length(x),1);

for i = 1:length(x)
    for j = 1:N
        y(i) = y(i) + bk*buffer(j*M);
    end
end