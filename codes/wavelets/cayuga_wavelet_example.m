%% wavelet analysis at three heights from a detrended single event in lake Cayuga
%% Seth Schweizer's PhD thesis data detrended by Marek Stastna
clear all,close all
load sample_lake_data.mat

% Plot the three time series
figure(11)
clf
betterplots
subplot(2,1,1)
plot(time,myf1,'r',time,myf2,'b',time,myf3,'k')
xlabel('day')
ylabel('detrended T')
grid on
legend(['z = ' num2str(z(12),3)],['z = ' num2str(z(6),3)],['z = ' num2str(z(3),3)],'Location','SouthWest')

figure(12)
clf
colormap hot
% The standard CWT plot
cwt(myf1,'amor',days(time(2)-time(1)),'VoicesPerOctave',24)
% Now get it to return values
[wt, period, coi]=cwt(myf1,'amor',days(time(2)-time(1)),'VoicesPerOctave',24);
% sum over fast timescales
wtsub=wt(1:100,:); % try changing the 100
myhigh1=sum(abs(wtsub).^2,1);
% sum over medium timescales
wtsub=wt(101:150,:);
mymid1=sum(abs(wtsub).^2,1);
caxis([0 1])

% do it all again for the second time series
figure(13)
clf
colormap hot
cwt(myf2,'amor',days(time(2)-time(1)),'VoicesPerOctave',24)
caxis([0 1])
[wt, period, coi]=cwt(myf2,'amor',days(time(2)-time(1)),'VoicesPerOctave',24);
wtsub=wt(1:100,:);
myhigh2=sum(abs(wtsub).^2,1);
wtsub=wt(101:150,:);
mymid2=sum(abs(wtsub).^2,1);

% and the third
figure(14)
clf
colormap hot
cwt(myf3,'amor',days(time(2)-time(1)),'VoicesPerOctave',24)
caxis([0 1])
[wt, period, coi]=cwt(myf3,'amor',days(time(2)-time(1)),'VoicesPerOctave',24);
wtsub=wt(1:100,:);
myhigh3=sum(abs(wtsub).^2,1);
wtsub=wt(101:150,:);
mymid3=sum(abs(wtsub).^2,1);

% plot the sum over the high components along with the time series
figure(15)
clf
betterplots
subplot(3,1,1)
plot(time,myf1/10,'k',time,myhigh1/max(myhigh1),'m')
legend('timeseries','wavelet power (high)','Location','NorthWest')
grid on
ylabel('f1')
subplot(3,1,2)
plot(time,myf2/10,'k',time,myhigh2/max(myhigh2),'m')
grid on
ylabel('f2')
subplot(3,1,3)
plot(time,myf3/10,'k',time,myhigh3/max(myhigh3),'m')
grid on
ylabel('f3')

% plot the sum over the medium components along with the time series
figure(16)
clf
betterplots
subplot(3,1,1)
plot(time,myf1/10,'k',time,mymid1/max(mymid1),'m')
grid on
ylabel('f1')
subplot(3,1,2)
plot(time,myf2/10,'k',time,mymid2/max(mymid1),'m')
legend('timeseries','wavelet power (mid)','Location','NorthWest')
grid on
ylabel('f2')
subplot(3,1,3)
plot(time,myf3/10,'k',time,mymid3/max(mymid1),'m')
grid on
ylabel('f3')

% Compare the "fast" time series
figure(11)
subplot(2,1,2)
plot(time,myhigh1,'r',time,myhigh2,'b',time,myhigh3,'k')
xlabel('day')
ylabel('wavelet power (high)')
grid on
%legend(['z = ' num2str(z(12),3)],['z = ' num2str(z(6),3)],['z = ' num2str(z(3),3)])