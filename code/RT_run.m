
%% tropical and extropical sub-dataset

R1_train=nan(numn,1);
R1_test=nan(numn,1);

site_ind=1:1:length(T);
remm=nan(numn,1);retr=nan(numn,1);
imp=nan(numn,npred);cv_mse=nan(numn,1);
europex=randperm(nsites);
ksites=floor(0.85*nsites);
tsites=nsites-ksites;
testindx=nan(tsites,50);

for regt=1:numn
testind=nan(tsites,1);
for mm=1:tsites
    testind(mm)=europex(mm);
end
testindx(:,regt)=testind;
trainind=setdiff(site_ind,testind);
Xtrain=nan(ksites,npred);
Ytrain=nan(ksites,1);
Xtest=nan(tsites,npred);
Ytest=nan(tsites,1);
    for xx=1:ksites
    Xtrain(xx,:)=XX(trainind(xx),:);
    Ytrain(xx)=T(trainind(xx));
    end
    for xx=1:tsites
    Xtest(xx,:)=XX(testind(xx),:);
    Ytest(xx)=T(testind(xx));
    end
tree=fitrtree(Xtrain,Ytrain,'categoricalpredictors',[npred-1,npred],'MinParent',6,'MinLeaf',3,...
    'PredictorSelection','curvature','Surrogate','on','LeaveOut','on','CrossVal','on','Prune','on');
table_mse=kfoldLoss(tree);
cv_mse(regt,:)=table_mse;
imp(regt,:)= predictorImportance(tree.Trained{2,1});

YY_train=predict(tree.Trained{2,1},Xtrain);
YY_test=predict(tree.Trained{2,1},Xtest);

RegTree_RESM(regt).tree=tree.Trained{2,1};
 ddx=[Ytrain,YY_train];
 r=corrcoef(ddx);
 R1_train(regt)=r(1,2)^2;
 cd /Users/ysun/Documents/Code_for_Matlab;
 retr(regt)=rmse(exp(Ytrain),exp(YY_train));
 ddx=[Ytest,YY_test];
 r=corrcoef(ddx);
 R1_test(regt)=r(1,2)^2;
 cd /Users/ysun/Documents/Code_for_Matlab;
 remm(regt)=rmse(exp(Ytest),exp(YY_test));
end
[RX,row]=sort(R1_test,'descend');
%%
for regg=1:50
    RegTreeG(regg).tree=RegTree_RESM(row(regg)).tree;
end

[R2_test,pos]=sort(R1_test,'descend');
R2_train=nan(50,1);rmse_v=nan(50,1);
imp_cp=nan(50,npred);cv_mses=nan(50,1);
rett_v=nan(50,1);
for xxx=1:50
    R2_train(xxx)=R1_train(pos(xxx));
    R2_test(xxx)=R1_test(pos(xxx));
    rmse_v(xxx)=remm(pos(xxx));
    rett_v(xxx)=retr(pos(xxx));
    imp_cp(xxx,:)=imp(pos(xxx),:);
    cv_mses(xxx,:)=cv_mse(pos(xxx),:);
     YY_train=predict(RegTreeG(xxx).tree,Xtrain);
end

[rx,rowx]=sort(rmse_v);

for reggg=1:25
    RegTreeGR(reggg).tree=RegTreeG(rowx(reggg)).tree;
end

