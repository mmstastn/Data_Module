%% This script tries to compare EOF and CEOF for the BBM tidal case
clear all,close all
load bbm_tidecrittry
sz=size(B2s);
% create the complexified data
for ii=1:sz(2)
    B2sc(:,ii)=hilbert(B2s(:,ii));
end
mymat=cov(B2s');
mymatc=cov(B2sc');
[V,D]=eig(mymat);
myeigs=diag(D); myeigs=myeigs/sum(myeigs);
[myeigs myeigsi]=sort(myeigs,'descend');
[Vc,Dc]=eig(mymatc);
% noten eventhough Dc is complex the evals are real
myeigsc=diag(Dc); myeigsc=myeigsc/sum(myeigsc);
[myeigsc myeigsci]=sort(myeigsc,'descend');
for eofi=1:5
    figure(eofi)
    clf
    betterplots
    subplot(2,1,1)
    plot(myeigs,'bo')
    hold on
    plot(myeigsc,'rs')
    plot(eofi,myeigs(eofi),'b*','Markersize',12)
    plot(eofi,myeigsc(eofi),'rx','Markersize',12)
    grid on
    axis([1 30 0 0.3])
    title(['Evalues, and ' int2str(eofi) ' EOF and CEOF'])
    subplot(2,1,2)
    eofnow=V(:,myeigsi(eofi));
    ceofnow=Vc(:,myeigsi(eofi));
    plot(x,eofnow,'k',x,real(ceofnow),'b',x,imag(ceofnow),'r')
    legend('EOF','Re CEOF','Im CEOF')
end

