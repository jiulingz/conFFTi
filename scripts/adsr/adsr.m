% Michelle Chang
% 3/4/2021
% Capstone S21 conFFTi
% ADSR

% Tests
figure;
fs = 10000;
target = [0.75; 0.25; 0];
duration = [250; 300; 200; 250];
envelope = adsr_gen(fs, target, duration);
plot(envelope)
figure;
target = [0.8; 0.4; 0.1];
duration = [300; 200; 400; 100];
envelope = adsr_gen(fs, target, duration);
plot(envelope)

function env = adsr_gen(fs, target, duration)
% duration is in ms

env = zeros(fs, 1);
duration = round(duration./1000.*fs); % duration of envelope

% attack
m1 = target(1)/duration(1);
for n = (2 : duration(1))
    env(n) = m1 * n;
end

% decay
m2 = (target(2)-target(1))/duration(2);
for n = (duration(1)+1 : duration(1)+duration(2))
    env(n) = m2 * (n - duration(1)) + target(1);
end

% sustain
for n = (duration(1)+duration(2)+1 : duration(1)+duration(2)+duration(3))
    env(n) = target(2);
end

% release
m3 = (target(3)-target(2))/duration(4);
for n = (duration(1)+duration(2)+duration(3)+1 : fs)
    env(n) = m3 * (n-duration(1)-duration(2)-duration(3)) + target(2);
end

end