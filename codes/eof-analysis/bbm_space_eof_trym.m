%% Basic EOF that captures spatial distribution of temporal variance
clear all,close all

%load BBM_sample_long
%load bbm_crittry
load ../bbm_tidecrittry
data=B2s;

num_modes=170
[M,N] = size(data); % find dimensions of data
data_noav = bsxfun(@minus, data, mean(data,2)); % remove mean
% for BBM_sample_long
%myx=(0.5:511.5)/512; mytime=0:299;
 % for bbm_crittry
%myx=(0.5:4095.5)/4096; mytime=0:599;
 % for bbm_tidecrittry
 myx=(0.5:2047.5)/4096; mytime=0:599;
 
%% Compute time EOFs
% flip the data matrix to get the cumulative approximation
[lambda,u,coeff,cumul_approx] = eofs(data_noav,num_modes);
figure(1)
clf
betterplots
plot(lambda/sum(lambda),'bo-')

for ii=1:num_modes
    myapp=squeeze(cumul_approx(ii,:,:));
    myerrnow=(myapp-data_noav)';
    myerr2(ii)=norm(myerrnow,2);
    myerrinf(ii)=norm(myerrnow,Inf);
end   

figure(2)
clf
colormap darkjet
betterplots
subplot(3,1,1)
pcolor(myx,mytime,data'),shading flat,colormap darkjet,colorbar
title('density and the error of the 50, 100 and 105 EOF approxmation')
subplot(3,2,3)
plot(1:num_modes,myerr2,'bo-')
grid on
ylabel('l2 error')
subplot(3,2,4)
semilogy(1:num_modes,myerr2,'rs-')
grid on
subplot(3,2,5)
plot(1:num_modes,myerrinf,'bo-')
grid on
ylabel('linf error')
xlabel('number of modes in approx')
subplot(3,2,6)
semilogy(1:num_modes,myerrinf,'rs-')
grid on
xlabel('number of modes in approx')


figure(3)
clf
betterplots
subplot(4,1,1)
plot(myx,u(:,1),'b-');
title('EOFs (1,50,100,150) top to bottom')
subplot(4,1,2)
plot(myx,u(:,50),'k-');
subplot(4,1,3)
plot(myx,u(:,100),'r-');
subplot(4,1,4)
plot(myx,u(:,150),'g-');
xlabel('time')
figure(4)
clf
betterplots
plot(mytime,coeff(1,:),'b-',mytime,coeff(50,:),'k-',mytime,coeff(100,:),'r-',mytime,coeff(150,:),'g-');
title('coefficients of EOFs')
legend('coeff 1','coeff 50','coeff 100','coeff 150','Location','SouthEast')  