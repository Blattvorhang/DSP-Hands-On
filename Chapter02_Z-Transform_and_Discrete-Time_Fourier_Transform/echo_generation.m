%% Record
Fs = 8000; 
nBits = 16;
nChannels = 1;
ID = -1;  % default audio input device
recorder = audiorecorder(Fs, nBits, nChannels, ID);

record_time = 3;
disp('Start speaking.');
recordblocking(recorder, record_time);
disp('End of Recording.');

%% Plot record data
x = getaudiodata(recorder);
N = size(x, 1);

subplot(321);
t = linspace(0, record_time, N);
plot(t, x);
title('采样声音信号');
xlabel('t(s)');
ylabel('幅度');

% signal sampling
factor = 2;  % Sampling rate reduction factor
downsampled_x = downsample(x, factor);
new_Fs = Fs / factor;
downsampled_N = size(downsampled_x, 1);
subplot(322);
plot(linspace(0, record_time, downsampled_N), downsampled_x);
title('抽取声音信号');
xlabel('t(s)');
ylabel('幅度');

%% Generation of echoes
% time domain 
delay = 0.4;
alpha = 0.4;
R = round(N * delay / record_time);
delay_x = x(1:end - R);
delay_x = padarray(delay_x, R, 'pre');
y = x + alpha * delay_x;

subplot(323);
plot(t, x, t, alpha * delay_x);
legend({'原信号', '延迟衰减信号'}, 'Location', 'Best');
xlabel('t(s)');
ylabel('幅度');

subplot(325);
plot(t, y);
title('回声（时域法）');
xlabel('t(s)');
ylabel('幅度');

% transfer function (filter)
b = zeros(R + 1, 1);
b(1) = 1;
b(R + 1) = alpha;
a = 1;
y_filter = filter(b, a, x);

subplot(326);
plot(t, y_filter);
title('回声（滤波器）');
xlabel('t(s)');
ylabel('幅度');

%% Play sound signals
disp('Playing the original sound signal.');
play(recorder);
pause(record_time);
disp('Playing the downsampled sound signal.');
sound(downsampled_x, Fs / 2, nBits);
pause(record_time);
disp('Playing the echo signal.');
sound(y, Fs, nBits);
pause(record_time);
disp('Playing the echo signal (filter).');
sound(y_filter, Fs, nBits);
