%%

N = 8;
n = 0:N-1;

x1 = zeros(1,N); x1(1) = 1;     % delta
x2 = ones(1,N);                 % escalon
x3 = zeros(1,N);
for nn=n
    x3(nn+1) = exp(-1i*2*pi*nn/N);
end
x4 = cos(2*pi*n/N);

xx = x4;

TEST = fft_stage(xx);

subplot(2,1,1)
plot(n,abs(TEST),'o-')
subplot(2,1,2)
plot(n,abs(fft(xx)),'o-')


%%



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
    WW = W.^nn

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