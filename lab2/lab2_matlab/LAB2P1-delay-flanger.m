clc
close all
%% 1.1 
[x,fs]=audioread("besh_16_20.wav"); % fs 20khz || lenght(x)-> 6001 (300ms)

% 65 ms -> muestra 1300. 
% 180 ms -> muestra 3600.
% 220 ms -> muestra 4400.

e = zeros(6001,1);
sh = zeros(6001,1);

e(1300:3600) = x(1300:3600);
sh(4400:end)= x(4400:end);

figure
plot(x,'b')
hold on
plot(e,'r')
plot(sh,'k')
grid on 
xlim ([0 6001])

% tramos segmentados
es = x(1300:3600);
shs = x(4400:end);

audiowrite('Lab2p1_vocal.wav',es,fs);
% sound(es,fs)


%% 1.2 segmentacion visual del audio original.

as = crop(x,fs,'Lab2p1_segmento vocal.wav');

%% 1.3 

[gt,fs]=audioread('gtr-jazz_16_48.wav');
%[gt,fs]=audioread('9992.wav');
gtr = gt(:,1);   %canales derecho e izquierdo de la señal estéreo.
gtl = gt(:,2);
gtc = crop(gtr,fs,"Lab2p1_arpegio.wav");

%% 2.1 distorsion simple overdrive
[msc,fs2]=audioread('musica_16_44p1.wav');
alpha = 1;
beta = 0.4;
G_i = 1;
G_o = 1;
x = gtc;
x_p = G_i*x;
y_p = zeros(length(x_p),1);
for i = 1:length(x_p)
   aux = beta*x_p(i) + sign(x_p(i))*(1-beta)*alpha;
   if abs(x_p(i)) >= alpha
       y_p(i) = aux;
   else
       y_p(i) = x_p(i);
   end
end
y = G_o*y_p;

figure
plot(x)
hold on
plot(y)
grid on
hold off

figure
h = stem(x,y);
h.LineStyle = 'none';
h.Marker = '.';
h.MarkerSize = 2;
h.MarkerEdgeColor = '#D95319';
grid on

%% 2.2 delay multi tap
%parametros
N=10; % numero de etapas de retardo
l=0.250; % longitud en s de la etapa de retardo.
b_k=0.35; %ganancia por etapa de retardo
M = l*fs; % numero de muestras equivalentes a la longitud de cada retardo


xgd=gtc; %señal de entrada

%xgd = resample(xgd,1,3);

gtdelay = zeros(size(xgd)); %salida

time_lapse = length(xgd)/fs;
buffer=zeros(N*M,1);

%ganancia b_k dinámica
varb_k = zeros(N,1);
for i = 1:length(varb_k)
    varb_k(i)=0.35^i;
end

for i = 1:length(xgd)
    dval_aux = 0;
    for k = 1:N
       if(i-k*M>0)
           dval_aux = dval_aux + varb_k(k)*xgd(i-k*M);  %ganancia variable varb_k. constante -> b_k
       else
           break
       end
    end
    gtdelay(i) = dval_aux;

%    for k = 1:N
%        if xgd(i-k*M)
%           i_value = b_k*xgd(i-k*M);
%           buffer(k*N+1,1) = buffer + i_value;
%        else
%           i_value = 0;
%           buffer(k*N+1,1) = buffer + i_value;
%        end
%    end
end

%% Flanging
f_in = gtc; %entrada

f=0.5; % f>>speed
A=0.03; % A>>sweep
g_f = 1; %ganancia del flanger

M_0 = 4000; %muestras
flan = zeros(size(f_in)); %salida
m = zeros (size(f_in));

for i = 1:length(f_in)
    m(i)= M_0 *(1 + A*sin(2*pi*(f/fs)*i)); % modulación LFO sobre el retardo 
    if (i-m(i)>0)
        idx=ceil(i-m(i));
        flan(i) = f_in(i)+g_f*f_in(idx); %salida
    else
        flan(i) = f_in(i);
    end
end


%% FUNCIONES

%funcion de segmentación visual
function a = crop(x,fs,name)
   plot(x)
   xlim([0 length(x)])
   [lims, ~] = ginput(2);
   lims=floor(lims);
   if lims(1)>lims(2)
       limsaux=lims(1);
       lims(1)=lims(2);
       lims(2)=limsaux;
   end
   if lims(1)<0
       lims(1)=0;
   end
   if lims(2)>length(x)
       lims(2)=lenght(x);
   end
   a = x(lims(1):lims(2));
   audiowrite(name,a,fs)
end
