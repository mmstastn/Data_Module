%% This is a basic wavelet tutorial
clear all, close all
% parameters and sample functions

t=linspace(0,100,5001);
dt=t(2)-t(1);
sampfreq=2*pi/dt;
f1a=exp(-((t-25)/2).^2);
f1b=exp(-((t-75)/2).^2); % a pair of Gaussians

f2a=exp(-((t-50)/10).^2).*sin(2*pi*t/2); % a pair of packets
f2b=exp(-((t-50)/10).^2).*(0.6*sin(2*pi*t/2)+0.4*sin(2*pi*t/0.8+0.1));

f3a=exp(-((t-50)/10).^2).*sin(2*pi*t/2); % packet with and without noise
f3b=exp(-((t-50)/10).^2).*sin(2*pi*t/2)+0.2*randn(size(t));

figure(11)
clf
betterplots
subplot(3,1,1)
plot(t,f1a,'b',t,f1b,'r')
title('Gaussians for Figure 1,2')
subplot(3,1,2)
plot(t,f2a,'b',t,f2b,'r')
title('Packets for Figure 3,4')
subplot(3,1,3)
plot(t,f3b,'r',t,f3a,'b--')
title('Packet+Noise for Figure 5,6')


figure(1)
clf
% The standard CWT plot
cwt(f1a,'amor',sampfreq,'VoicesPerOctave',48)
figure(2)
% The standard CWT plot
cwt(f1b,'amor',sampfreq,'VoicesPerOctave',48)

figure(3)
clf
% The standard CWT plot
cwt(f2a,'amor',sampfreq,'VoicesPerOctave',48)
figure(4)
% The standard CWT plot
cwt(f2b,'amor',sampfreq,'VoicesPerOctave',48)

figure(5)
clf
% The standard CWT plot
cwt(f3a,'amor',sampfreq,'VoicesPerOctave',48)
figure(6)
% The standard CWT plot
cwt(f3b,'amor',sampfreq,'VoicesPerOctave',48)

% Let's try plotting from data
figure(7)
clf
[cfs frq]=cwt(f3b,'amor',sampfreq,'VoicesPerOctave',48);
surface(t,frq,abs(cfs))
axis tight
shading flat
xlabel('Time')
ylabel('Frequency')
set(gca,"yscale","log")
% a decent approximation to the built in one, albeit without the shaded out
% part

% Let's compare wavelet types; you can see that while there are differences
% they are a bit on the subtle side
figure(8)
clf
[cfs1 frq1]=cwt(f2b,'amor',sampfreq,'VoicesPerOctave',48);
[cfs2 frq2]=cwt(f2b,'morse',sampfreq,'VoicesPerOctave',48);
[cfs3 frq3]=cwt(f2b,'bump',sampfreq,'VoicesPerOctave',48);
subplot(1,3,1)
surface(t,frq1,abs(cfs1))
axis tight
shading flat
xlabel('Time')
ylabel('Frequency')
set(gca,"yscale","log")
ylim([1 1e2])
title('Gabor wavelet')
subplot(1,3,2)
surface(t,frq2,abs(cfs2))
axis tight
shading flat
xlabel('Time')
ylabel('Frequency')
set(gca,"yscale","log")
ylim([1 1e2])
title('Morse wavelet')
subplot(1,3,3)
surface(t,frq3,abs(cfs3))
axis tight
shading flat
xlabel('Time')
ylabel('Frequency')
set(gca,"yscale","log")
ylim([1 1e2])
title('Bump wavelet')




