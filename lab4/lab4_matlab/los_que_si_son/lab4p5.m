%% V.1)
N = 8;
t=0:0.5/N:0.5-0.5/N;
xe = cos(2*pi*100*t);
xe = xe';
Xe = DFTmatrix(xe);
w = -pi:2*pi/N:pi-2*pi/N;
figure()
stem(w,abs(Xe))
figure()
stem()

%% V. 1)
N = 100;
w = 0:2*pi/N:2*pi-2*pi/N;

x=zeros(N,1);
x(1)=1;

X1 = DFTmatrix(x);
figure()
subplot(2,1,1)
stem(w,X1)

X2 = dftmtx(N)*x;
subplot(2,1,2);
stem(w,X2);

err = immse(X1,X2);

A = genAmatrix(N);
B = dftmtx(N);
err2 = immse(A,B);

%% V.2)
N=5;
A = genAmatrix(N);
figure()
Aim=imag(A);
imagesc(Aim)
title("Parte imaginaria de la matriz A en escala de color, N=64.")
figure()
Are=real(A);
imagesc(Are)
title("Parte real de la matriz A en escala de color, N=64.")
%% V.3)
% N muestras
N = 8;
n = 0:N-1;

%señal 
% x = e^-2*pi*n/N
x=exp(-1i*2*pi*n/N);
            
% x = delta()
xdlt = zeros(8,1);
xdlt(1)=1;

% x = 1
xuan = ones(8,1);

% x = cos(2pin/N)
xos = cos(2*pi*n/N);

w = 0:2*pi/N:2*pi-2*pi/N;

x = x';
Xe = DFTmatrix(x);
subplot(4,2,1);
stem(w,abs(Xe));
title("Calculo matricial de la DFT de una señal exponencial N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
Xdlt = DFTmatrix(xdlt);
subplot(4,2,3);
stem(w,abs(Xdlt));
title("Calculo matricial de la DFT de una señal delta dirac N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
xos=xos';
Xos = DFTmatrix(xos);
subplot(4,2,5);
stem(w,abs(Xos));
title("Calculo matricial de la DFT de una señal cosenoidal N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
Xuan = DFTmatrix(xuan);
subplot(4,2,7);
stem(w,abs(Xuan));
title("Calculo matricial de la DFT de una señal escalón N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")

Xe2 = fft(x);
subplot(4,2,2);
stem(w,abs(Xe2));
title("Cálculo fft() de una señal exponencial N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
Xdlt2 = fft(xdlt);
subplot(4,2,4);
stem(w,abs(Xdlt2));
title("Cálculo fft() de una señal delta dirac N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
Xos2 = fft(xos);
subplot(4,2,6);
stem(w,abs(Xos2));
title("Cálculo fft() de una señal cosenoidal N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")
Xuan2 = fft(xuan);
subplot(4,2,8);
stem(w,abs(Xuan2));
title("Cálculo fft() de una señal escalón N=8.")
ylabel("Magnitud Normalizada dB")
xlabel("Frecuencia Normalizada rad/muestra")

errexp=immse(Xe,Xe2);
errcos=immse(Xos,Xos2);
errdlt=immse(Xdlt,Xdlt2);
errwan=immse(Xuan,Xuan2);

%% V.3)

fs = 5000;
t = 0:1/fs:1-1/fs;
x1=cos(2*pi*100*t);
x1=x1';
X1 = DFTmatrix(x1);
w = -pi:2*pi/5000:pi-2*pi/5000;
figure()
subplot(2,1,1)
stem(w,abs(fftshift(X1)));

X3 = fft(x1,5000);
w3 = -pi:2*pi/5000:pi-2*pi/5000;
subplot(2,1,2)
stem(w3,abs(fftshift(X3)));

err3=immse(X1,X3);
%%

fs = 5000;
t = 0:1/fs:1-1/fs;
x1=cos(2*pi*100*t);
x1 = x1';
tfft = zeros(50,1);
tdftsum = zeros(50,1);
tdftmtx = zeros (50,1);


for N = 100:100:5000
    i = N/100;
    f = @() DFTmatrix(x1(1:N));
    
    tdftmtx(i) = timeit(f);

    f = @() DFTsum(x1(1:N));

    tdftsum(i) = timeit(f);

    f = @() fft(x1,N);

    tfft(i) = timeit(f);
    
end
N=0:50-1;
figure()
plot(N,tdftmtx)
hold on
plot(N,tdftsum)
plot(N,tfft)
legend('DFTmtx','DFTsum', 'fft')
title("Tiempo de procesamiento en función del largo N")
ylabel("Tiempo s ")
xlabel("muestras N")
hold off




%%

function A = genAmatrix(N)
    A = zeros(N);
    for k=1:N
        for n=1:N
            A(k,n)=exp(-1i*2*pi*(k-1)*(n-1)/N);
        end
    end
end

function X = DFTmatrix(x)   
    N = length(x);
    A = genAmatrix(N);
    X = A*x;

end

function X = DFTsum(x)
    N = length(x);
    X = zeros(size(N));
    for k=1:N
        XK = 0;
        for n=1:N
            theta = 2*pi*(k-1)*(n-1)/N;
            XK= XK + x(n)*(cos(theta)-1i*sin(theta));
        end
        X(k) = XK;

    end
end