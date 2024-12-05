%% This is an example script on spectral coherence
%% https://en.wikipedia.org/wiki/Coherence_(signal_processing)
%% if you don't do any averaging (numens=1) then the spectral coherence
%% is always 1 even for very different signals
%% The script then shows the wavelet coherence which does not need
%% an ensemble and shows periods in time where coherence is strong
clear all,close all
% Seed the random number generator
rng('shuffle')
% Define the various functions
bigt=10;numpts=1000; mysig=0.5; numens=100;
t=linspace(0,bigt,numpts+1)'; t=t(1:end-1);

% loop over ensemble members
for k=1:numens
% define the functions and add noise
f1=cos(2*pi*t/0.5)+1e-3*randn(numpts,1); 
% add a bit of noise so all frequencies have spectral power
f1b=f1+mysig*randn(size(f1));
f2=exp(-((t-0.5*bigt)/(0.1*bigt)).^2)+1e-3*randn(numpts,1);
%f3=(t<0.5*L).*f1;
f3=exp(-((t-0.5*bigt)/(0.1*bigt)).^2).*cos(2*pi*t/0.5)+1e-3*randn(numpts,1);

% Define the cross correlations and the cross-spectral densities

Sf1f1(:,k)=fft(f1).*conj(fft(f1));
Sf1bf1b(:,k)=fft(f1b).*conj(fft(f1b));
Sf2f2(:,k)=fft(f2).*conj(fft(f2));
Sf3f3(:,k)=fft(f3).*conj(fft(f3));
Sf1f2(:,k)=fft(f1).*conj(fft(f2));
Sf1bf2(:,k)=fft(f1b).*conj(fft(f2));
Sf1f3(:,k)=fft(f1).*conj(fft(f3));
Sf1bf3(:,k)=fft(f1b).*conj(fft(f3));
Sf2f3(:,k)=fft(f2).*conj(fft(f3));

end
Sf1f1=mean(Sf1f1,2);
Sf1bf1b=mean(Sf1bf1b,2);
Sf2f2=mean(Sf2f2,2);
Sf3f3=mean(Sf3f3,2);
Sf1f2=mean(Sf1f2,2);
Sf1f3=mean(Sf1f3,2);
Sf2f3=mean(Sf2f3,2);
Sf1bf2=mean(Sf1bf2,2);
Sf1bf3=mean(Sf1bf3,2);

% build the spectral coherence
Cf1f2=abs(Sf1f2)./(sqrt(Sf1f1).*sqrt(Sf2f2));
Cf1bf2=abs(Sf1bf2)./(sqrt(Sf1bf1b).*sqrt(Sf2f2));
Cf1f3=abs(Sf1f3)./(sqrt(Sf1f1).*sqrt(Sf3f3));
Cf1bf3=abs(Sf1bf3)./(sqrt(Sf1bf1b).*sqrt(Sf3f3));
Cf2f3=abs(Sf2f3)./(sqrt(Sf2f2).*sqrt(Sf3f3));

% build the spectra
sp1=fft(f1).*conj(fft(f1));
sp1b=fft(f1b).*conj(fft(f1b));
sp2=fft(f2).*conj(fft(f2));
sp3=fft(f3).*conj(fft(f3));

% parameters
dom=2*pi/bigt;
numoms=100;
oms=(0:numoms)*dom;
figure(1)
clf
betterplots
subplot(3,1,1)
plot(t,f1,'b',t,f2,'r--',t,f3,'k:')
ylabel('function')
xlabel('time')
subplot(3,1,2)
plot(oms,sp1(1:numoms+1),'b',oms,sp2(1:numoms+1),'r^',oms,sp3(1:numoms+1),'k.')
ylabel('spectrum')
xlabel('frequency')
legend('f1','f2','f3')
subplot(3,1,3)
plot(oms,Cf1f2(1:numoms+1),'m',oms,Cf1f3(1:numoms+1),'co-',oms,Cf2f3(1:numoms+1),'gp-')
ylabel('spectral coherence')
xlabel('frequency')
legend('f1 f2','f1 f3','f2 f3')

% now use this to explore the role of randomness
figure(2)
clf
betterplots
subplot(3,1,1)
plot(t,f1,'b',t,f1b,'r--',t,f3,'k:')
ylabel('function')
xlabel('time')
subplot(3,1,2)
plot(oms,sp1(1:numoms+1),'b',oms,sp1b(1:numoms+1),'r^',oms,sp3(1:numoms+1),'k.')
ylabel('spectrum')
xlabel('frequency')
legend('f1','f1b','f3')
subplot(3,1,3)
plot(oms,Cf1f3(1:numoms+1),'mp',oms,Cf1bf3(1:numoms+1),'co-')
ylabel('spectral coherence')
xlabel('frequency')
legend('f1 f3','f1b f3')

% OK now let's try some wavelet coherence for a signal anmd its noisy
% counterpart
figure(4)
clf
betterplots
wcoherence(f1,f1b,seconds(t(2)-t(1)))
title('wavelet coherence between f1 and f1b')

% OK next consider a periodic signal and its packet counterpart
figure(5)
clf
betterplots
wcoherence(f1,f3,seconds(t(2)-t(1)))
title('wavelet coherence between f1 and f3')

% finally do it again for a phase shifted packet (same pattern different
% arrows)
f3b=exp(-((t-0.5*bigt)/(0.1*bigt)).^2).*sin(2*pi*t/0.5);
figure(6)
clf
betterplots
wcoherence(f1,f3b,seconds(t(2)-t(1)))
title('wavelet coherence between f1 and phase shifted f3')
