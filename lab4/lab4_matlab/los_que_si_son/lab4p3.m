%% III.1) Filtrado en dominio de la frequencia.
load('nspeech.mat')
%%
x = nspeech;
N = length(x);
X = fft(x);

%%
f = 0 : fs/N : fs-fs/N;
Xx = mag2db(abs(X));
plot(f,Xx); axis([0 4000 -10 inf])
xlabel("Frecuencia (Hz)"); ylabel("Magnitud (dB)");
title("Espectro de la señal nspeech")

%%
tt = 2*pi*1685/fs;

h = [1 -2*cos(tt) 1];
%zplane(h,1)
H = fft(h,N);

subplot(1,2,1)
plot(f,abs(H));axis([0 4000 -inf inf])
xlabel("Frecuencia (Hz)"); ylabel("Magnitud")
title("Magnitud del filtro H")
subplot(1,2,2)
plot(f,angle(H),'r');axis([0 4000 -inf inf])
xlabel("Frecuencia (Hz)"); ylabel("Fase")
title("Fase del filtro H")

Y = X.*H;
y = ifft(Y,N,'symmetric');
%%
t = 0 : 1/fs : N/fs-1/fs;
%%
plot(t,x,t,y)
xlim([0 N/fs])
xlabel("tiempo (s)"); ylabel("amplitud");
title("Comparación entre señal original y señal filtrada")
legend(["Señal con tono no deseado" "Señal con tono filtrado"])