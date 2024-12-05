%% BBM version of tidal generation spectra evolution
% load data
load ../bbm_tide2crittry.mat
% set up some useful parameters
L=60;
[M,N] = size(B1s);
% FFT in space
B1sf=fft(B1s,[],1);
% spectrum
myspecs=B1sf.*conj(B1sf);
% minimum k and k values to use
dk=2*pi/L;
numks=1000; myks=(0:numks)*dk;
% plot
figure(6)
clf
betterplots
subplot(2,1,1)
plot(myks, myspecs(1:numks+1,600),'bo-')
grid on
ylabel('spectrum')
axis([0 20 0 400])
title('Spample spectra at half way and end')
subplot(2,1,2)
plot(myks, myspecs(1:numks+1,1200),'rs-')
grid on
xlabel('k')
ylabel('spectrum')
axis([0 20 0 400])
% Hovmoeller or space-time plot
figure(7)
clf
betterplots
subplot(2,1,1)
pcolor(myks,1:N,myspecs(1:numks+1,:)')
shading flat,colormap hot,colorbar
ylabel('output number')
xlabel('k')
title('PSD')
axis([0 10 1 1200])
caxis([0 200])
subplot(2,1,2)
pcolor(myks,1:N,log10(myspecs(1:numks+1,:)'))
shading flat,colormap hot,colorbar
caxis([-10 2.5])
ylabel('output number')
xlabel('k')
title('log 10 PSD')
hold on
plot([10 10],[1 1200],'b--')
% comparison with sinusoids
figure(8)
clf
betterplots
myf=.3*sin(2*pi*x/15)+.2*cos(2*pi*x/5);
sampspec=abs(fft(myf));
plot(myks, sampspec(1:numks+1),'kp-',myks, myspecs(1:numks+1,1200),'rs-')
grid on
xlabel('k')
ylabel('spectrum')
axis([0 20 0 400])
% temporal spectra
figure(9)
clf
betterplots
% extract data
Btime=B2s(920,:);
% window function
mywin=[0:599  600:-1:1]/600;
Btimewin=Btime.*mywin;
subplot(2,1,1)
plot(1:1200,Btime,'b',1:1200,Btimewin,'r')
ylabel('B at fixed x')
xlabel('time')
axis([1 1200 -0.3 0.15])
grid on
subplot(2,1,2)
% frequencies
dom=2*pi/1200;
numoms=100;
oms=(0:numoms)*dom;
% even extension
Btimeext=[Btime flipud(Btime)];
spt=abs(fft(Btime));
spwint=abs(fft(Btimewin));
omsext=(0:2*numoms)*0.5*dom;
spext=abs(fft(Btimeext));
% notice for the extension you halve the spectrum to account for doubling
% the points
plot(oms,spt(1:numoms+1),'b',oms,spwint(1:numoms+1),'r',omsext(1:2:end),spext(1:2:2*numoms+1)/2,'k--')
ylabel('PSD')
xlabel('\omega')
axis([0 0.5 0 25])
grid on
