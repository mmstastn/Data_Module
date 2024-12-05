%% Wavelets for BBM tide
load bbm_tide2crittry.mat

figure(1)
clf
betterplots
colormap darkjet
pcolor(B1s')
shading flat
caxis([-1 1]*0.1)
hold on
plot([1 2048],[300 300],'w--')
plot([1 2048],[600 600],'w--')
plot([1 2048],[900 900],'w--')
plot([1 2048],[1200 1200],'w--')
plot([768 768],[1 1200],'k--')

figure(11)
clf 
betterplots
subplot(4,1,4)
plot(x,B1s(:,300),'k')
grid on
text(-28, -0.3,'300')
subplot(4,1,3)
plot(x,B1s(:,600),'k')
grid on
text(-28, -0.3,'600')
subplot(4,1,2)
plot(x,B1s(:,900),'k')
grid on
text(-28, -0.3,'900')
subplot(4,1,1)
plot(x,B1s(:,1200),'k')
grid on
text(-28, -0.3,'1200')
for pi=1:4
    subplot(4,1,pi)
    axis([-30 30 -0.35 0.1])
end

% Need to figure out how to make a proper CWT for space pic
figure(2)
clf
betterplots
colormap hot
cwt([B1s(:,300); B1s(:,300)])
caxis([0 1]*0.03)
figure(3)
clf
betterplots
colormap hot
cwt([B1s(:,600);B1s(:,600)])
caxis([0 1]*0.03)
figure(4)
clf
betterplots
colormap hot
cwt([B1s(:,900); B1s(:,900)])
caxis([0 1]*0.03)
figure(5)
clf
betterplots
colormap hot
cwt([B1s(:,1200);B1s(:,1200)])
caxis([0 1]*0.03)

% wavelet for buoy type plot
figure(11)
clf
betterplots
plot(1:1200,B1s(768,:))
grid on
figure(12)
clf
betterplots
colormap hot
cwt(B1s(768,:))
caxis([0 1]*0.03)