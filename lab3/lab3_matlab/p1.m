%% Pregunta 1.
% y(n) = x(n) - 2*cos(t)*x(n-1) + x(n-2)
close all

fs = 11;
n = 1:1:fs;
L = length(n);
t = pi/4;

x = zeros(1, L); x(1) = 1;
y = zeros(1, length(x));

y(1) = x(1);
y(2) = x(2) - 2*cos(t)*x(1);
for i = 3 : length(x)
    y(i) = x(i) - 2*cos(t)*x(i-1) + x(i-2);
end

subplot(2,1,1)
stem(n, x)
xlabel('muestras (n)'); ylabel('amplitud');
axis([0 L -2 2])
title('Impulso de entrada')

subplot(2,1,2)
stem(n, y)
xlabel('muestras (n)'); ylabel('amplitud');
axis([0 L -2 2])
title('Respuesta a impulso')

%% |H(w)| = |1 - 2cos(t)*e^(-jw) + e^(-2jw)|
close all

w_array = -pi:1e-3:pi;
yy1 = H(w_array, pi/6);
yy2 = H(w_array, pi/3);
yy3 = H(w_array, pi/2);

plot(w_array, yy1)
hold on
plot(w_array, yy2)
plot(w_array, yy3)
axis([-pi pi -40 20]); xlabel('w (rad/s)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
legend('pi/6','pi/3','pi/2')


%%
function y = H(w, t)
    y = abs(1 - 2*cos(t)*exp(-1i*w) + exp(-2*1i*w));
    y = 20*log10(y);
end