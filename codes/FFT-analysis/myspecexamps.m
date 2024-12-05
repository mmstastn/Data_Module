%% This code shows some basic examples of spectra

clear all
close all

N=4096*2;
L=20;
z=linspace(-1,1,N+1); % Make a grid that's one too long
z=z(1:end-1); % truncate it
x=z*L; dx=x(2)-x(1); %make it the correct length for [-L,L]
dk=pi/L; % shortest wave number (like the Nyquist frequency)
ksvec=zeros(size(x));
ksvec(1)=0; ksvec(N/2+1)=0;
for ii=2:(N/2)
   ksvec(ii)=ii-1;
   ksvec(N/2+ii)=-N/2 + ii -1;
end
k=ksvec'*dk; k2=k.*k; ik=sqrt(-1)*k;
% This is Matlab's funny ordering for wavenumbers

% The sample functions
% one sine
f1=sin(2*pi*x/2.5);
% two sines
f2=0.5*sin(2*pi*x/1)+0.5*sin(2*pi*x/0.5);
% Gaussian packet
f3=exp(-(x/4).^2).*sin(2*pi*x/2.5);
% Super Gaussian packet
f4=exp(-(x/4).^8).*sin(2*pi*x/0.5);
f5=abs(f1);
% Two packets
f6=exp(-((x-5)/4).^2).*sin(2*pi*x/3);
f6=f6+exp(-((x+5)/4).^2).*sin(2*pi*x/2);
% Elliptic function like a Stokes wave
[fs,fc,fd]=ellipj(x,0.995);
 f7=sin(2*x)+0.1*x;
 
% This is a plot of the subset of some of the functions
figure(1)
clf
set(gcf,'DefaultLineLineWidth',2,'DefaultTextFontSize',12,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',12,...
          'DefaultAxesFontWeight','bold');
      subplot(3,1,1)
      plot(x,f1,'k-',x,f3,'r-',x,f7,'b-')
      xlabel('x')
      ylabel('f1')
      
      subplot(3,1,2)
      plot(k,abs(fft(f1)),'k.',k,abs(fft(f3)),'rs',k,abs(fft(f7)),'bo')
      xlabel('k')
      ylabel('PSD')
      legend('sine','packet','non-periodic')
      axis([-5 5 1e-4 8e3])
      subplot(3,1,3)
      plot(k,log10(abs(fft(f1))),'k.',k,log10(abs(fft(f3))),'rs',k,log10(abs(fft(f7))),'bo')
      xlabel('k')
      ylabel('log10 PSD')
      axis([-5 5 -3 4])
      
      % If you look at the spectrum of f7 you will notice that even though
      % it is a single sine many wavenumbers have non zero spectral values
      % This is, of course due to the Gibbs phenomenon and can be partially
      % fixed by windowing
      
      No2=N/2; mywin=[0:No2-1 No2:-1:1]/No2; f7w=mywin.*f7;
figure(2)
clf
set(gcf,'DefaultLineLineWidth',2,'DefaultTextFontSize',12,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',12,...
          'DefaultAxesFontWeight','bold');
      subplot(3,1,1)
      plot(x,f7,'k-',x,f7w,'r-')
      legend('actual','windowed')
      xlabel('x')
      ylabel('f1')
      subplot(3,1,2)
      plot(k,abs(fft(f7)),'k.',k,abs(fft(f7w)),'rs')
      xlabel('k')
      ylabel('Raw PSD')
      axis([-5 5 1e-4 3e3])
      grid on
      subplot(3,1,3)
      plot(k,log10(abs(fft(f7))),'k.',k,log10(abs(fft(f7w))),'rs')
      xlabel('k')
      ylabel('log10 PSD')
      axis([-5 5 -0.5 4])
      grid on
      
% Notice that the windowed function is much more localized in Fourier space
% You can think of windowing like making a packet from your signal.  The
% windowed spectrum is choppy especially in the semilogy plot

% Using abs(fft(f)) gives an estimate of the spectrum with a lot of
% variance (technically an astnonishing 100%).  In practice things are
% rarely that bad, but when a signal is long the variance can be reduced by
% splitting the signal up, windowing each piece and summing like this
No4=N/4;
mywin=[0:No4/2-1 No4/2:-1:1]/(No4/2);
myspec=zeros(No4,1)';
for ii=0:3
    fnow=mywin.*f7(ii*No4+1:(ii+1)*No4);
    myspec=myspec+abs(fft(fnow));
end
dk=4*pi/L; % shortest wave number for shorter series (like the Nyquist frequency)
ksvec=zeros(No4,1);
ksvec(1)=0; ksvec(No4/2+1)=0;
for ii=2:(No4/2)
   ksvec(ii)=ii-1;
   ksvec(No4/2+ii)=-No4/2 + ii -1;
end
k4=ksvec'*dk;
figure(3)
clf
set(gcf,'DefaultLineLineWidth',2,'DefaultTextFontSize',12,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',12,...
          'DefaultAxesFontWeight','bold');
      subplot(3,1,1)
      plot(x,f7w,'r-')
      xlabel('x')
      ylabel('f1')
      subplot(3,1,2)
      plot(k4,myspec,'k.',k,abs(fft(f7w)),'rs')
      xlabel('k')
      ylabel('PSD')
      grid on
      axis([-5 5 1e-4 3e3])
      legend('variance reduced','raw')
      subplot(3,1,3)
      plot(k4,log10(myspec),'k.',k,log10(abs(fft(f7w))),'rs')
      xlabel('k')
      ylabel('log10 PSD')
      axis([-5 5 -0.5 4])
      grid on
      
      % or by smoothing the spectrum like this
      
      spec0=abs(fft(f7w));
      spec0sm=spec0;
      for ii=3:N-2
          spec0sm(ii)=sum(spec0(ii-2:ii+2))/5;
      end
      figure(4)
clf
set(gcf,'DefaultLineLineWidth',2,'DefaultTextFontSize',12,...
        'DefaultTextFontWeight','bold','DefaultAxesFontSize',12,...
          'DefaultAxesFontWeight','bold');
      subplot(2,1,1)
      plot(k,spec0sm,'k.-',k,spec0,'rs-'), axis([-5 5 1e-4 3e3])
      legend('smoothed','raw')
      grid on
      ylabel('PSD')
      subplot(2,1,2)
      plot(k,log10(spec0sm),'k.-',k,log10(spec0),'rs-')
      axis([-5 5 -0.5 4])
      grid on
      ylabel('log10 PSD')
      xlabel('k')
      
      
