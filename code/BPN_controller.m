%% control predictor selected
%% import data
load('data/responseY.mat'); 
load('data/lat_eu.mat'); %
load('data/long_eu.mat'); %
XX=importdata('data/sinput.mat');
datasavepath=char('BPf');
Y=log(responseY);
[xl,yl]=find(isnan(XX)|XX==-inf);
XX(xl,:)=[];Y(xl)=[];
long_eu(xl)=[];
lat_eu(xl)=[];
[xm,ym]=find(isnan(Y));
XX(xm,:)=[];Y(xm)=[];
long_eu(xm)=[];lat_eu(xm)=[];
T=Y;

cd(datasavepath);
save('XXxall.mat','XX');
save('Txall.mat','T');
nss=length(T);
v=size(XX);vv=v(2);vv=vv-2+16+11;
nsites=length(T)-1;axx=size(XX);npred=axx(2);
cd(datasavepath);save('T.mat','T');hoo=nan(nss);hoostd=nan(nss);


PP=XX';
TT=T;
numn=5000;

soil_P=nan(11,length(TT'));
for ii=1:length(TT')
    soil=zeros(11,1);
    a=PP(npred-1,ii);soil(a)=1;
     soil_P(:,ii)=soil;
end
veg_P=nan(16,length(TT'));
for ii=1:length(TT')
    veg=zeros(16,1);
    a=PP(npred,ii);veg(a)=1;
     veg_P(:,ii)=veg;
end

R2_testv=nan(25,length(TT'));
R2_trainv=nan(25,length(TT'));
rmse_metric=nan(25,length(TT'));
%% BPN
for rrm=1:126
    tic;
    rrm
P=[PP(1:npred-2,:);soil_P;veg_P];

T=TT';
ap=exp(T(rrm));
Ttt=T(rrm);XXtt=P(:,rrm);
T(rrm)=[];P(:,rrm)=[];

%
dum=1
R1_train=nan(numn,1);
R1_test=nan(numn,1);
site_ind=1:1:length(P);
remm=nan(numn,1);retr=nan(numn,1);
imp=nan(numn,npred);cv_mse=nan(numn,1);
Ytt=nan(numn,1);diff=nan(numn,1);
%
BPN_run; 
mmx=length(RXX);
  if length(RXX)>25
      if ap<25
     [sp,sx]=sortrows(RXX,2,'descend');
      else
     [sp,sx]=sortrows(RXX,4,'ascend');
      end
     RXX=sp(1:25,:);
     for ik=1:25
         Ytm(ik)=Ytt(sx(ik));
         RE(ik)=BP_RESM(sx(ik));
     end
     Ytt=Ytm;
     BP_RESM=RE;
  end
  while length(RXX)<25
     dum=dum+1
      RXXor=RXX;
      BP_RESMor=BP_RESM;
     Yttor=Ytt;
     BPN_run;
     Ytt=[Yttor;Ytt(1:25-length(RXXor))];
     RXX=[RXXor;RXX(1:25-length(RXXor),:)];
     BP_RESM=[BP_RESMor,BP_RESM(1:25-length(RXXor))];
   end     
hoo(rrm)=nanmedian(exp(Ytt));
hoostd(rrm)=1.4826*mad(exp(Ytt));
dc=exp(Ytt);
cd(datasavepath);
mkdir(char(strcat(num2str(rrm))));
save(char(strcat(num2str(rrm),'/dc.mat')),'dc');
save(char(strcat(num2str(rrm),'/RXX.mat')),'RXX');
save(char(strcat(num2str(rrm),'/BP_RESM.mat')),'BP_RESM');
save('hoo.mat','hoo');save('hoostd.mat','hoostd');
save('P.mat','P');save('T.mat','T');
toc;
end
