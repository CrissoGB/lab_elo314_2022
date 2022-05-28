clc
close all

%% Pregunta 1.
% y(n) = x(n) - 2*cos(t)*x(n-1) + x(n-2)
close all

fs = 50;
n = 1:1:fs;
L = length(n);
t = pi/3;

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
yy1 = H1(w_array, pi/6);
yy2 = H1(w_array, pi/3);
yy3 = H1(w_array, pi/2);

plot(w_array, yy1)
hold on
plot(w_array, yy2)
plot(w_array, yy3)
axis([-pi pi -40 20]); xlabel('w (rad/s)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
legend('pi/6','pi/3','pi/2')

%% pregunta 2
r_p = 0.7;
b0 = 1-r_p;

for i = 1:length(x)
    if (i-2>0)
        y(i) = b0*x(i-2) + 2*r_p*cos(t)*y(i-1) - r_p^2*y(i-2);
    else
        y(i) = 0;
    end
end
subplot(2,1,1)
stem(n, x)
xlabel('muestras (n)'); ylabel('amplitud');
title('Impulso de entrada')

subplot(2,1,2)
stem(n, y)
xlabel('muestras (n)'); ylabel('amplitud');
title('Respuesta a impulso')
%% |H(w)| = |1 - 2cos(t)*e^(-jw) + e^(-2jw)|
close all

w_array = -pi:1e-3:pi;
yy1 = H2(w_array, 0.99);
yy2 = H2(w_array, 0.9);
yy3 = H2(w_array, 0.7);

plot(w_array, yy1)
hold on
plot(w_array, yy2)
plot(w_array, yy3)
axis([-pi pi -40 20]); xlabel('w (rad/s)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
legend('pi/6','pi/3','pi/2')

%% p3 FILTRAR CON FIR LA SEÑAL NSPEECH
fn= 1685/fs;
w_arr0 = -pi:2*pi/length(nspeech):pi-2*pi/length(nspeech);

y = FIR_filter(nspeech,fn);
w_arr1 = -pi:2*pi/length(y):pi-2*pi/length(y);

r = 0.99;
theta = 2*pi*fn;
%parámetros
b0 = 1;
b1 = -r*cos(theta);
b2 = r^2;  
B = [b0 b1 b2];
A = 1;

yfi=filter(A, B, nspeech); %FORMA DIRECTA 2 TRANSPUESTA
figure()
plot(w_arr0, abs(fftshift(fft(nspeech))));
hold on 
%plot(w_arr0, abs(fftshift(fft(yfi))));
plot(w_arr1, abs(fftshift(fft(y))));
axis([-pi pi -20 330]); xlabel('w (rad/s)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
%legend('nspeech','filter','FIR filter')
%%  FILTRAR  CON IRR LA SEÑAL PCM
b_k = [1 -r];
a1 = -r*cos(theta);
a2 = r^2;
a_k = [a1 a2];

filtered_pcm= IIR_filter( pcm, b_k, a_k);
%%
paso = (2*pi/(length(pcm)));
w_arr = -pi:paso:pi-paso;
z = fftshift(fft(pcm));
z2 = fftshift(fft(filtered_pcm));


%y_pcm = H2(w_arr, 0.99);
%y_fpcm =  H2(w_arr, 0.99);
figure()
plot(w_arr, abs(z))
hold on
plot(w_arr, abs(z2))
axis([-pi pi -20 330]); xlabel('w (rad/s)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
legend('pcm','pcm filtered')
%%
[xn ,fs]=audioread('bfunkcrop.wav');
T = 1/fs;
L = length(xn);
t = (0:L-1)*T;

Y = fft(xn,nf);
f = fs/2*linspace(0,1,nf/2+1);
plot(f,abs(Y(1:nf/2+1)));
%% Ventana h[n]

wc = 2*pi/3;
N = 101;
h = zeros(1,N);
nn = -(N-1)/2:(N-1)/2;

for n=1:N
   h(n) = wc/pi * sinc(wc/pi* (n-(N-1)/2));
end
figure()
stem(nn,h)

[H,w]=DTFT(h,N);
figure()
plot(w,abs(H))
%% VENTANAS





%% FUNCIONES
% filtro 
function y = H1(w, t)
    y = abs(1 - 2*cos(t)*exp(-1i*w) + exp(-2*1i*w));
    y = 20*log10(y);
end

function y = H2(w, r)
    y = (1-r)./abs((1 - 2*r*cos(2*pi*0.210625000000000)*exp(-1i*w) + r^2*exp(-2*1i*w)));
    y = 20*log10(y);
end

% Filtro FIR por convolución 
function y = FIR_filter(x,fn) % r = 1 theta = 2*pi*fn
    r = 0.9;
    theta = 2*pi*fn;
    %parámetros
    b0 = 1;
    b1 = -r*cos(theta);
    b2 = r^2;  

    b = [b0 b1 b2];
    a = 1;
    h = b/a;
    y = conv(h,x);
end

% Filtro IIR ec de dif. coef A B
function y = IIR_filter( x, bCoeff, aCoeff)
    y = zeros(size(x));
    for i = 1:length(x)

        if i < 2
            y(i) = bCoeff(1)*x(i);        
        elseif (1<i)<3
            y(i) = bCoeff(1)*x(i)+bCoeff(2)*x(i-1)-aCoeff(1)*y(i-1);
        else
            y(i) = bCoeff(1)*x(i)+bCoeff(2)*x(i-1)-aCoeff(1)*y(i-1)-aCoeff(2)*y(i-2);
        end
    end
end
   
