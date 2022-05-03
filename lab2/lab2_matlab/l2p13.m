%% 3. FLANGER
f_in = x;                   % entrada

f = 0.8;                    % f >> speed
A = 1;                      % A >> sweep
g_f = 1;                    % ganancia del flanger

M_0 = 100;                  % muestras
flan = zeros(size(f_in));   % salida
m = zeros (size(f_in));

for i = 1:length(f_in)
    m(i)= M_0 *(1 + A*sin(2*pi*(f/fs)*i)); % modulación LFO sobre el delay 
    if (i-m(i)>0)
        idx=ceil(i-m(i));
        flan(i) = f_in(i)+g_f*f_in(idx);   % salida
    else
        flan(i) = f_in(i);
    end
end

audiowrite("flanger_sin.wav", gtc, fs)
audiowrite("flanger_con.wav", flan, fs)


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
       lims(2)=length(x);
   end
   a = x(lims(1):lims(2));
end
