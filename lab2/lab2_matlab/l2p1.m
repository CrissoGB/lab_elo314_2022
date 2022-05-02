%% Parte 1

[x, Fs] = audioread('besh_16_20.wav');
% largo del audio: # muestras / Fs
% largo del audio = 300ms

x1 = zeros(length(x),1);
x2 = zeros(length(x),1);

% 65ms => 1300 samples
% 180ms => 3600 samples
x1(1300:3600) = x(1300:3600);
audiowrite('Lab2p1_vocal.wav', x1, Fs)

% 220ms => 4400 samples
x2(4400:end) = x(4400:end);

plot(x)
hold on
plot(x1,'r')
plot(x2,'k')
title 'Señal de audio besh\_16\_20.wav'; xlabel 'muestras (n)'; ylabel 'amplitud'
xlim([0 6001])
hold off

%%

crop(x, Fs, 'Lab2p1_segmento_vocal.wav');

%%

[gtr, fs2] = audioread('gtr-jazz_16_48.wav');
crop(gtr(:,1), fs2, 'Lab2p1_arpegio.wav');


%%
function a = crop(audio, Fs, name)
    plot(audio)
    xlim([0 length(audio)])
    [lims,~] = ginput(2);
    lims = floor(lims);

    if lims(1) > lims(2)
        temp = lims(2);
        lims(2) = lims(1);
        lims(1) = temp;
    end
    if lims(1) < 0
        lims(1) = 0;
    end
    if lims(2) > length(audio)
        lims(2) = length(audio);
    end

    a = audio(lims(1):lims(2));
    audiowrite(name, a, Fs);
end