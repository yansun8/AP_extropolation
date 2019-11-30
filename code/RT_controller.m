%% control predictor selected
%% import data
load('data/responseY.mat'); 
load('data/lat_eu.mat'); %
load('data/long_eu.mat'); %
XX=importdata('data/sinput.mat');
Y=log(responseY);
[xl,yl]=find(isnan(XX)|XX==-inf);
XX(xl,:)=[];Y(xl)=[];
long_eu(xl)=[];
lat_eu(xl)=[];
[xm,ym]=find(isnan(Y));
XX(xm,:)=[];Y(xm)=[];
long_eu(xm)=[];lat_eu(xm)=[];
T=Y;
numn=500;
datasavepath=char('RT');
cd(datasavepath);
save('XX.mat','XX');
save('T.mat','T');
TT=T;
XXx=XX;
nss=length(T);hoo=nan(1,nss);hoostd=nan(1,nss);
nsites=length(T)-1;
axx=size(XX);
npred=axx(2);
for rrm=1:126
    rrm
    tic;
T=TT;
XX=XXx;
ap=exp(T(rrm));
Ttt=T(rrm);XXtt=XX(rrm,:);
T(rrm)=[];XX(rrm,:)=[];
RT_run;
R2_trainx=nan(25,1);R2_testx=nan(25,1);
imp_cpx=nan(25,npred);cv_msex=nan(25,1);rmse_vx=nan(25,1);Ytt=nan(25,1);rett_vx=nan(25,1);
for xxy=1:25
    R2_trainx(xxy)=R2_train(rowx(xxy));
    R2_testx(xxy)=R2_test(rowx(xxy));
    imp_cpx(xxy,:)=imp_cp(rowx(xxy),:);
    cv_msex(xxy,:)=cv_mses(rowx(xxy),:);  
    rmse_vx(xxy,:)=rmse_v(rowx(xxy),:);
    rett_vx(xxy,:)=rett_v(rowx(xxy),:);
 YY_train=predict(RegTreeGR(xxy).tree,Xtrain);
  value=predict(RegTreeGR(xxy).tree,XXtt);
Ytt(xxy)=value;
end
dc=exp(Ytt);
hoo(rrm,1)=median(exp(Ytt));
hoostd(rrm,1)=1.426*mad(exp(Ytt));
RXX=[R2_trainx,R2_testx,rmse_vx,rett_vx];
% save
cd(datasavepath);
mkdir(char(strcat(num2str(rrm))));
save(char(strcat(num2str(rrm),'/RXX.mat')),'RXX');
save(char(strcat(num2str(rrm),'/RegTreeGR.mat')),'RegTreeGR');
save(char(strcat(num2str(rrm),'/dc.mat')),'dc')
toc;
end


