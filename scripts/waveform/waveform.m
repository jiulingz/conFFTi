% Michelle Chang
% 2/28/2021
% Capstone S21 conFFTi
% Waveform generation

T = 3;
fs = 44100;
t = 0:1/fs:T-1/fs;

% sine wave
y_sin = sin(2*pi*t);
% sawtooth wave
y_saw = sawtooth(2*pi*t);
% square wave
y_sqr = square(2*pi*t);
% triangle wave
y_tri = sawtooth(2*pi*t, 1/2);

% plots
figure;
plot(t, y_sin);
xlabel('Time');
ylabel('Amplitude');
title("Sine Wave");
figure;
plot(t, y_saw);
xlabel('Time');
ylabel('Amplitude');
title("Sawtooth Wave");
figure;
plot(t, y_sqr);
xlabel('Time');
ylabel('Amplitude');
title("Square Wave");
figure;
plot(t, y_tri);
xlabel('Time');
ylabel('Amplitude');
title("Triangle Wave");
