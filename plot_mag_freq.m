 % function to plot an approximation of the magnitue of the DTFT
function plot_mag_freq(x)

N = length(x);

% 4. Create the corresponding frequency axis
omega = (-pi : 2*pi/N : pi - 2*pi/N); % Frequency in radians/sample
X = fftshift(abs(fft(x)));
plot(omega, X);
xlabel('$$ \hat{\omega} $$', 'Interpreter', 'latex');
ylabel('$$ |H(\hat{\omega})| $$', 'Interpreter', 'latex');
end
