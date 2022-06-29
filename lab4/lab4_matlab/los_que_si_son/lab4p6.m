%% VI.1)

N = 8;
n = 0:N-1;

x1 = zeros(1,N); x1(1) = 1;     % delta
x2 = ones(1,N);                 % escalon
x3 = zeros(1,N);
for nn=n
    x3(nn+1) = exp(-1i*2*pi*nn/N);
end
x4 = cos(2*pi*n/N);

%%

X1 = DFTdc(x1);

f = @() DFTdc(x1);
t11= timeit(f);
f= @() fft(x1);
t12= timeit(f);

X2 = DFTdc(x2);

f = @() DFTdc(x2);
t21= timeit(f);
f= @() fft(x2);
t22= timeit(f);

X3 = DFTdc(x3);
f = @() DFTdc(x3);
t31= timeit(f);
f= @() fft(x3);
t32= timeit(f);

X4 = DFTdc(x4);
f = @() DFTdc(x4);
t41= timeit(f);
f= @() fft(x4);
t42= timeit(f);

subplot(4,2,1)
stem(n,abs(X1))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTdc() para x_1")
subplot(4,2,2)
stem(n,abs(fft(x1)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_1")
subplot(4,2,3)
stem(n,abs(X2))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTdc() para x_2")
subplot(4,2,4)
stem(n,abs(fft(x2)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_2")

subplot(4,2,5)
stem(n,abs(X3))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTdc() para x_3")
subplot(4,2,6)
stem(n,abs(fft(x3)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_3")

subplot(4,2,7)
stem(n,abs(X4))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de DFTdc() para x_4")
subplot(4,2,8)
stem(n,abs(fft(x4)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_4")


%% VI.2)
% Se han comentado los tiempos una vez que se extrajo su valor
% para no llenar de respuestas la consola.

X1 = FFT8(x1);

f = @() FFT8(x1);
t11= timeit(f);
f= @() fft(x1);
t12= timeit(f);

X2 = FFT8(x2);

f = @() FFT8(x2);
t21= timeit(f);
f= @() fft(x2);
t22= timeit(f);

X3 = FFT8(x3);
f = @() FFT8(x3);
t31= timeit(f);
f= @() fft(x3);
t32= timeit(f);

X4 = FFT8(x4);
f = @() FFT8(x4);
t41= timeit(f);
f= @() fft(x4);
t42= timeit(f);

subplot(4,2,1)
stem(n,abs(X1))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de FFT8() para x_1")
subplot(4,2,2)
stem(n,abs(fft(x1)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_1")
subplot(4,2,3)
stem(n,abs(X2))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de FFT8() para x_2")
subplot(4,2,4)
stem(n,abs(fft(x2)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_2")

subplot(4,2,5)
stem(n,abs(X3))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de FFT8() para x_3")
subplot(4,2,6)
stem(n,abs(fft(x3)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_3")

subplot(4,2,7)
stem(n,abs(X4))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de FFT8() para x_4")
subplot(4,2,8)
stem(n,abs(fft(x4)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_4")


%% VI.3)

X1 = fft_stage(x1);

f = @() fft_stage(x1);
t11= timeit(f);
f= @() fft(x1);
t12= timeit(f);

X2 = fft_stage(x2);

f = @() fft_stage(x2);
t21= timeit(f);
f= @() fft(x2);
t22= timeit(f);

X3 = fft_stage(x3);
f = @() fft_stage(x3);
t31= timeit(f);
f= @() fft(x3);
t32= timeit(f);

X4 = fft_stage(x4);
f = @() fft_stage(x4);
t41= timeit(f);
f= @() fft(x4);
t42= timeit(f);

subplot(4,2,1)
stem(n,abs(X1))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fftstage() para x_1")
subplot(4,2,2)
stem(n,abs(fft(x1)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_1")
subplot(4,2,3)
stem(n,abs(X2))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fftstage() para x_2")
subplot(4,2,4)
stem(n,abs(fft(x2)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_2")

subplot(4,2,5)
stem(n,abs(X3))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fftstage() para x_3")
subplot(4,2,6)
stem(n,abs(fft(x3)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_3")

subplot(4,2,7)
stem(n,abs(X4))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fftstage() para x_4")
subplot(4,2,8)
stem(n,abs(fft(x4)))
xlabel("frecuencia normalizada (rad/muestra)"); ylabel("magnitud")
title("DFT mediante uso de fft() para x_4")



%% VI.4)

fs = 5000; ts = 1/fs;
n = 0: ts : 1-ts;
x = cos(2*pi*100*n);

tfft_stage = zeros(1,10);
tfft = zeros(1,10);
x = [x zeros(1,2^19-length(x))];

for i = 1:10
    N = 2^(9+i);
   
    f = @() fft_stage(x(1:N));
    tfft_stage(i) = timeit(f);
    f = @() fft(x,N);
    tfft(i) = timeit(f);
end

%%

N = 0:9;

plot(N,tfft_stage,N,tfft,'LineWidth',2)
legend('fft\_stage', 'fft')
title("Tiempo de procesamiento en función del largo N")
ylabel("Tiempo (s) "); xlabel("muestras (2^n^+^1^0)")
axis([0 10 -.2 4])


%%
err1 = fft_stage(x(1:4096));
err2 = fft(x,4096);

immse(err1,err2)


%%
function X = DFTdc(x) 
    NN = length(x);
    xo = x(1:2:NN);              % ODD  part of N-poibt x[n]
    xe = x(2:2:NN);              % EVEN  part of N-poibt x[n]

    Xe = DFTsum(xe);
    Xo = DFTsum(xo);
    Wn = exp(-1i*2*pi/NN);
    X = [Xo, Xo] + (Wn.^[0:NN-1]).*[Xe, Xe];
end

function X = FFT2(x)
    X0 = x(1) + x(2);
    X1 = x(1) - x(2);
    X = [X0 X1];
end

function X = FFT4(x)
    W40 = exp(-1i*2*pi/4*0); % k=0
    W41 = exp(-1i*2*pi/4*1); % k=1

    Xe = FFT2(x(1:2:4));
    Xo = FFT2(x(2:2:4));

    X0 = Xe(1) + W40*Xo(1);
    X1 = Xe(2) + W41*Xo(2);
    X2 = Xe(1) - W40*Xo(1);
    X3 = Xe(2) - W41*Xo(2);
    X = [X0 X1 X2 X3];
end

function X = FFT8(x)
    W80 = exp(-1i*2*pi/8*0); % k=0
    W81 = exp(-1i*2*pi/8*1); % k=1
    W82 = exp(-1i*2*pi/8*2); % k=2
    W83 = exp(-1i*2*pi/8*3); % k=3

    Xe = FFT4(x(1:2:8));
    Xo = FFT4(x(2:2:8));

    X0 = Xe(1) + W80*Xo(1);
    X1 = Xe(2) + W81*Xo(2);
    X2 = Xe(3) + W82*Xo(3);
    X3 = Xe(4) + W83*Xo(4);
    X4 = Xe(1) - W80*Xo(1);
    X5 = Xe(2) - W81*Xo(2);
    X6 = Xe(3) - W82*Xo(3);
    X7 = Xe(4) - W83*Xo(4);

    X = [X0 X1 X2 X3 X4 X5 X6 X7];
end

function X = fft_stage(x)
    NN = length(x);

    if mod(NN,2) ~= 0
        disp('Señal no es de largo N = 2^p');
        X = 0;
        return;
    end

    nn = 0:NN-1;

    W = exp(-1i*2*pi/NN);
    WW = W.^nn;

    if NN ~= 2
        X0 = fft_stage(x(1:2:NN));
        X1 = fft_stage(x(2:2:NN));
    else
        X0 = x(1);
        X1 = x(2);
    end

    X = [X0, X0] + WW.*[X1, X1];
end

%%
function X = DFTsum(x)
    N = length(x);
    X = zeros(1,N);
    for k=0:N-1
        XK = 0;
        for nn=0:N-1
            t = 2*pi*k*nn/N;
            XK= XK + x(nn+1)*exp(-1i*t);
        end
        X(k+1) = XK;
    end
end