clear
clc

[d,sr] = audioread('vaiueo2d.wav');
len1 = length(d);

% fft
F1 = 0:sr/len1:sr-sr/len1;
fft_data = fft(d);
% fft 결과
figure(1);
plot(abs(fft_data(1:len1/2)));

% stft parameters
n = 1024;
r = 0.5;
hop = n/4;
X1 = stft(d, n, n, hop);
% stft 결과
figure(2);
tt = [0:size(X1,2)]*hop/800;
ff = [0:size(X1,1)]*800/n;
imagesc(tt,ff,20*log10(abs(X1)));
axis('xy');
xlabel('time / sec');
ylabel('freq / Hz')

% phase vocoder
[rows, cols] = size(X1);
t = 0:r:(cols-2);
X2 = pvsample(X1, t, hop);

% istft
y = istft(X2, n, n, hop)';

% 변환 후 fft
fft_data2 = fft(y);
figure(3);
plot(abs(fft_data2(1:len1)));

f = resample(y,1,2);
audiowrite('out_double.wav',f,sr);
soundsc(f,sr);
