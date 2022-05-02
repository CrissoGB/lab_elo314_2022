%% Parte 2

[x, Fs] = audioread('gtr-jazz_16_48.wav');

x = x(:,1); % un solo canal

a = 0.1;
b = 0.05;
Gi = 1;
Go = 1;

xi = Gi*x;
yi = zeros(length(xi), 1);

for i = 1:length(xi)
    aux = b*xi(i) + sign(xi(i))*(1-b)*a;
    if abs(xi(i)) >= a
        yi(i) = aux;
    else
        yi(i) = xi(i);
    end
end

y = Go*yi;

plot(x)
xlim([0 length(x)])
hold on
plot(y)
title 'Señal de audio besh\_16\_20.wav';
xlabel 'muestras (n)';
ylabel 'amplitud'
hold off