% Hongrun Zhou, 02/27/2021
% Frequency Modulation
% dependency: communications toolbox

fs = 441000; % sampling frequency
fc = 200; % carrier frequency
t = (0:1/fs:0.2)'; % time vector of 0.2 s

% testcase 1
x1 = sin(2*pi*30*t) + 2*sin(2*pi*60*t);
% create two tone sinusoidal signals
% with frequencies 30 and 60 Hz
fDev1 = 50; % frequency deviation
y1 = fmmod(x1, fc, fs, fDev1); % frequency modulate x

% testcase 2
x2 = sin(2*pi*30*t) + 2*sin(2*pi*60*t);
% create two tone sinusoidal signals
% with frequencies 30 and 60 Hz
fDev2 = 100; % frequency deviation
y2 = fmmod(x2, fc, fs, fDev2); % frequency modulate x

% testcase 3
x3 = sin(2*pi*10*t) + 2*sin(2*pi*40*t);
% create two tone sinusoidal signals
% with frequencies 30 and 60 Hz
fDev3 = 30; % frequency deviation
y3 = fmmod(x3, fc, fs, fDev3); % frequency modulate x

subplot(3,1,1);
plot(t,x1,'c',t,y1,'b--');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal','Modulated Signal');
subplot(3,1,2);
plot(t,x2,'c',t,y2,'b--');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal','Modulated Signal');
subplot(3,1,3);
plot(t,x3,'c',t,y3,'b--');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal','Modulated Signal');
