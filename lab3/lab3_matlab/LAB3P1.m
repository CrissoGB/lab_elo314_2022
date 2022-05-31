clc
close all


%% I.1
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

% |H(w)| = |1 - 2cos(t)*e^(-jw) + e^(-2jw)|
close all

w_array = -pi:1e-3:pi;
yy1 = H1(w_array, pi/6);
yy2 = H1(w_array, pi/3);
yy3 = H1(w_array, pi/2);

plot(w_array, yy1)
hold on
plot(w_array, yy2)
plot(w_array, yy3)
axis([-pi pi -40 20]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos \theta')
hold off
legend('pi/6','pi/3','pi/2')

%% I.2


r_p = 0.7;
b0 = 1-r_p;

y(1) = b0*x(1);
y(2) = b0*x(1) +2*r_p*cos(t)*y(1);

for i = 1:length(x)
    if (i-2>0)
        y(i) = b0*x(i) + 2*r_p*cos(t)*y(i-1) - r_p^2*y(i-2);
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
% |H(w)| = |1 - 2cos(t)*e^(-jw) + e^(-2jw)|
close all

w_array = -pi:1e-3:pi;
yy1 = H2(w_array, 0.99);
yy2 = H2(w_array, 0.9);
yy3 = H2(w_array, 0.7);

plot(w_array, yy1)
hold on
plot(w_array, yy2)
plot(w_array, yy3)
axis([-pi pi -40 20]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud de respuesta en frecuencia para distintos r')
hold off
legend('0.99','0.9','0.7')

%% I.3 FILTRADO FIR DE LA SEÑAL NSPEECH
load("nspeech.mat");
fn= 1685/fs;
w_arr0 = -pi:2*pi/length(nspeech):pi-2*pi/length(nspeech);

y = FIR_filter(nspeech,fn);
w_arr1 = -pi:2*pi/length(y):pi-2*pi/length(y);

r = 1;
theta = 2*pi*fn;
%parámetros
b0 = 1;
b1 = -2*r*cos(theta);
b2 = r^2;  
B = [b0 b1 b2];
A = 1;

yfi=filter(B, A, nspeech); %FORMA DIRECTA 2 TRANSPUESTA
figure()
plot(w_arr0, (20*log10(abs(fftshift(fft(nspeech))))));
axis([-pi pi -30 75]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud del espectro de la señal de entrada nspeech')
%plot(w_arr0, abs(fftshift(fft(yfi))));
figure()
plot(w_arr1, (20*log10(abs(fftshift(fft(y))))));
axis([-pi pi -30 75]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud del espectro de la señal de salida')
figure()
plot(w_arr0, (20*log10(abs(fftshift(fft(yfi))))));
axis([-pi pi -30 75]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud del espectro de la señal de salida empleando filter()')
%legend('nspeech','filter','FIR filter')A
%%  FILTRADO IIR DE LA SEÑAL PCM
load("pcm.mat")
r=0.99;
b_k = [1 -r];
a1 = -2*r*cos(theta);
a2 = r^2;
a_k = [a1 a2];

filtered_pcm= IIR_filter( pcm, b_k, a_k);
%
paso = (2*pi/(length(pcm)));
w_arr = -pi:paso:pi-paso;
z = fftshift(fft(pcm));
z2 = fftshift(fft(filtered_pcm));


%y_pcm = H2(w_arr, 0.99);
%y_fpcm =  H2(w_arr, 0.99);
figure()
plot(w_arr, (20*log10(abs(z))))
axis([-pi pi -20 70]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud del espectro de la señal de entrada pcm')
figure()
plot(w_arr, (20*log10(abs(z2))))
axis([-pi pi -20 70]); xlabel('w (rad/muestra)'); ylabel('magnitud (dB)');
title('Magnitud del espectro de la señal de salida del filtro IIR diseñado')




%% II.1
wc = 2*pi/3;

N1 = 21;
N2 = 101;
N3 = 1001;

n1=0:N1-1;
n2=0:N2-1;
n3=0:N3-1;

h1 = wc/pi * sinc((n1-(N1-1)/2)*wc/pi);
h2 = wc/pi * sinc((n2-(N2-1)/2)*wc/pi);
h3 = wc/pi * sinc((n3-(N3-1)/2)*wc/pi);
figure()
subplot(3,1,1)
plot(n1,h1)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('filtro h(n) con N=21')
grid on
subplot(3,1,2)
plot(n2,h2)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('filtro h(n) con N=101')
grid on
subplot(3,1,3)
plot(n3,h3)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('filtro h(n) con N=1001')
grid on

[H11,w1]=DTFT(h1,512);
figure()
subplot(3,1,1)
plot(w1/pi,abs(H11))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud ')
title('|H(w)| con N=21')
grid on
[H21,w2]=DTFT(h2,512);
subplot(3,1,2)
plot(w2/pi,abs(H21))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud ')
title('|H(w)| con N=101')
grid on
[H31,w3]=DTFT(h3,512);
subplot(3,1,3)
plot(w3/pi,abs((H31)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud ')
title('|H(w)| con N=1001')
grid on

figure()
subplot(3,1,1)
plot(w1/pi,unwrap(angle(H11)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-90 90])
xlim([-1 1])
title('Fase del espectro de H(w) con N=21')
grid on 
subplot(3,1,2)
plot(w2/pi,unwrap(angle(H21)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-270 90])
xlim([-1 1])
title('Fase del espectro de H(w) con N=101')
grid on 
subplot(3,1,3)
plot(w3/pi,unwrap(angle(H31)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-270 90])
xlim([-1 1])
title('Fase del espectro de H(w) con N=1001')
grid on 
%% II.2

fs= 1000;
Ts=1/fs;
L = 100;
t = (0:L-1).*Ts;

rect = rectwin(L);
jamon = hann(L);
hamm = hamming(L);
black = blackman(L);
bart = bartlett(L);


figure()
subplot(5,1,1)
plot(t,rect);
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Ventana rectangular')
grid on

subplot(5,1,2)
plot(t,jamon)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Ventana hanning')
grid on

subplot(5,1,3)
plot(t,hamm)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Ventana hamming')
grid on

subplot(5,1,4)
plot(t,black)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Ventana blackman')
grid on

subplot(5,1,5)
plot(t,bart)
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Ventana bartlett')
grid on

w=-pi:2*pi/L:pi-2*pi/L;

s_rect=fft(rect);
s_jamon = fft(jamon);
s_hamm = fft(hamm);
s_black = fft(black);
s_bart = fft(bart);

figure()
subplot(5,2,1)
stem(w/pi,20*log10(abs(fftshift(s_rect))))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud (dB)')
ylim([-50 50])
xlim([-1 1])
title('Magnitud del espectro de la ventana rectangular')
grid on
subplot(5,2,2)
plot(w/pi,unwrap(angle(s_rect)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-30 10])
xlim([-1 1])
title('Fase del espectro de la ventana rectangular')
grid on 

subplot(5,2,3)
stem(w/pi,20*log10(abs(fftshift(s_jamon))))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud (dB)')
ylim([-50 50])
xlim([-1 1])
title('Magnitud del espectro de la ventana hanning')
grid on
subplot(5,2,4)
plot(w/pi,unwrap(angle(s_jamon)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-30 10])
xlim([-1 1])
title('Fase del espectro de la ventana rectangular')
grid on 

subplot(5,2,5)
stem(w/pi,20*log10(abs(fftshift(s_hamm))))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud (dB)')
ylim([-50 50])
xlim([-1 1])
title('Magnitud del espectro de la ventana hamming')
grid on
subplot(5,2,6)
plot(w/pi,unwrap(angle(s_hamm)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-30 10])
xlim([-1 1])
title('Fase del espectro de la ventana rectangular')
grid on 

subplot(5,2,7)
stem(w/pi,20*log10(abs(fftshift(s_black))))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud (dB)')
ylim([-50 50])
xlim([-1 1])
title('Magnitud del espectro de la ventana blackman')
grid on
subplot(5,2,8)
plot(w/pi,unwrap(angle(s_black)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-30 10])
xlim([-1 1])
title('Fase del espectro de la ventana rectangular')
grid on 


subplot(5,2,9)
stem(w/pi,20*log10(abs(fftshift(s_bart))))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Magnitud (dB)')
ylim([-50 50])
xlim([-1 1])
title('Magnitud del espectro de la ventana bartlett')
grid on
subplot(5,2,10)
plot(w/pi,unwrap(angle(s_bart)))
xlabel('Frecuencia Normalizada (\times\pi rad/muestra)')
ylabel('Fase (°)')
ylim([-30 10])
xlim([-1 1])
title('Fase del espectro de la ventana rectangular')
grid on 



%% III
%III.2
fs=16000;
fc=3000;
w=pi*fc/fs;
n=70;

A1 = fir1(n,w,"low","scale");
A2 = fir1(n,w,"low",rectwin(n+1),"scale");
A3 = fir1(n,w,"low",blackman(n+1),"scale");
figure()
freqz(A1,1,16000)
title('Espectro del filtro pasabajos de orden 70, fc=3kHz, fs=16ksps.')
figure()
freqz(A2,1,16000)
title('Espectro del filtro pasabajos de orden 70, fc=3kHz, fs=16ksps, método fir1 con ventana rectangular.')
figure()
freqz(A3,1,16000)
title('Espectro del filtro pasabajos de orden 70, fc=3kHz, fs=16ksps, método fir1 con ventana blackman.')
%% III.3
f=[0 0.1 0.1 0.4 0.4 0.65 0.75 1];
m=[1 1 0 0 0.5 0.5 0 0];
B1 = fir2(70,f,m);
B2 = fir2(150,f,m);

figure()
freqz(B1,1,16000)
title('Espectro del filtro FIR solicitado de orden 70, método fir2().')

figure()
freqz(B2,1,16000)
title('Espectro del filtro FIR solicitado de orden 150, método fir2().')

%% III.4

f=[0 0.1 0.15 0.35 0.4 0.65 0.75 1];
a=[1 1 0 0 0.5 0.5 0 0];
B3 = firpm(70,f,a);
figure()
freqz(B3,1,16000)
title('Espectro del filtro FIR de orden 70, coeficientes obtenidos mediante firpm().')

%% IV.1
Fs = 16000;
Fc1 = 2000;
Fc2 = 4000;
Fc3 = 800;
Fc4 = 1600;
[b1, a1] = ellip(2,3,40,(Fc1/(Fs/2)),"low");
figure()
freqz(b1,a1,[],Fs)
title('Pasa bajos de orden 2 (fc = 2 kHz)')
[b2,a2] = ellip(2,3,40,(Fc2/(Fs/2)),"high");
figure()
freqz(b2,a2,[],Fs)
title('Pasa altos de orden 2 (fc = 4 kHz)')
[b3,a3] = ellip(2,3,40,[(Fc1/(Fs/2)) (Fc2/(Fs/2))]);
figure()
freqz(b3,a3,[],Fs)
title('Pasa banda de orden 4 (f1 = 2 kHz, f2 = 4kHz)')
[b4,a4] = ellip(2,3,40,[(Fc1/(Fs/2)) (Fc2/(Fs/2))],"stop");
figure()
freqz(b4,a4,[],Fs)
title('Rechaza banda de orden 4 (f1 = 2 kHz, f2 = 4kHz)')
%% IV.2
%a) 1.5dB máximo de rizado en banda de paso
[b5,a5] = cheby2(2,20,[(Fc1/(Fs/2)) (Fc2/(Fs/2))],"bandpass");
figure()
freqz(b5,a5,[],Fs)
title('Filtro chebyshev de segundo tipo pasa banda de orden 4 (f1 = 2 kHz, f2 = 4kHz)')

%b) 20 dB de atenuación min en la banda de rechazo 
[b5,a5] = cheby1(2,1.5,[(Fc1/(Fs/2)) (Fc2/(Fs/2))],"bandpass");
figure()
freqz(b5,a5,[],Fs)
title('Filtro chebyshev de primer tipo pasa banda de orden 4 (f1 = 2 kHz, f2 = 4kHz)')
%% IV.3

[b6,a6] = butter(2,[(Fc3/(Fs/2)) (Fc4/(Fs/2))],"bandpass");
figure()
freqz(b6,a6,[],Fs)
title('Filtro butterworth pasa banda de orden 4 (f1 = 800Hz, f2 = 1600Hz)')
[z,p,k] = butter(2,[(Fc3/(Fs/2)) (Fc4/(Fs/2))],"bandpass");
figure()
zplane(z,p)
title('Diagrama de polos y ceros del filtro butterworth pasa-banda de orden 4')
[z,p,k] = butter(4,[(Fc3/(Fs/2)) (Fc4/(Fs/2))],"bandpass");
figure()
zplane(z,p)
title('Diagrama de polos y ceros del filtro butterworth pasa-banda de orden 8')
[z,p,k] = butter(16,[(Fc3/(Fs/2)) (Fc4/(Fs/2))],"bandpass");
figure()
zplane(z,p)
title('Diagrama de polos y ceros del filtro butterworth pasa-banda de orden 32')
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
    r = 1;
    theta = 2*pi*fn;
    %parámetros
    b0 = 1;
    b1 = -2*r*cos(theta);
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
   
