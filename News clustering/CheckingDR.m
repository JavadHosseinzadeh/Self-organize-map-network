clc
clear all
close all
%% data importation
% number of input
totalNumOfInputs = 2225;
% open Csv file and get data
[~,origTable,~] = xlsread('bbc-text.csv');
% Removes the titles
origTable(1,:)=[];
% extract lable and news from csv file
lable = origTable(:,1)';
news=origTable(:,2);
%% preprocessing
% Tokenize the text.
% Remove a list of stop words then lemmatize the words. To improve
% lemmatization, first use addPartOfSpeechDetails.
% Erase punctuation.
% Remove words with 2 or fewer characters, and words with 15 or more
% characters.
documents = preprocessText(news);
%%
% A tokenized document is a document represented as a collection of words
documents = tokenizedDocument(documents);% original 33385
% Creating bag of word
bag = bagOfWords(documents) 
% Set the TF factor to 1 + log(bag.Counts).
% TFWeight = 'log';
% log(N/NT),where N is the number of documents in the input data and NT is 
% the number of documents in the input data containing each term.
% IDFWeight = 'normal';
TF_IDF = tfidf(bag,'TFWeight','log','IDFWeight','normal');
%% with dimension rdunction
% Creating Self organizing Map Network for Clustering with dimension reduction
y1 = TF_IDF';
x = full(y1);
%%
% SVD decomposition of tf-idf matrix
% % K=1000;
% % [ U S V ] = svd(x');
% % % Generate new rank reduced matrix of rank k
% % Sk = S(1:K,1:K);
% % Uk = U(:,1:K);
% % x = inv(Sk)*Uk';
[coeff] = pca(x,'Algorithm','als');
x=coeff;
% labelll=zeros(5,2225);
% for i=1:2225
%     if KnownGroups(1,i)==1
%         labelll(:,i)=[1;0;0;0;0];
%     end
%     if KnownGroups(1,i)==2
%         labelll(:,i)=[0;1;0;0;0];
%     end
%     if KnownGroups(1,i)==3
%         labelll(:,i)=[0;0;1;0;0];
%     end
%     if KnownGroups(1,i)==4
%         labelll(:,i)=[0;0;0;1;0];
%     end
%     if KnownGroups(1,i)==5
%         labelll(:,i)=[0;0;0;0;1];
%     end 
% end
% [ReduceTrain,FisherCoeff] = fisherface(coeff,KnownGroups');
% x=coeff;
%
%%
% Competitive layers learn to classify input vectors into a given number of 
% classes, according to similarity between vectors, with a preference for 
% equal numbers of vectors per class.
% competlayer(numClasses,kohonenLR,conscienceLR)
% inputs = x;
net = selforgmap(5, 100, 3, 'hextop', 'linkdist');% dimensions, coverStepsm, initNeighbor, topologyFcn, distanceFcn
net.trainParam.epochs = 500;
net = train(net,x);
view(net)
y = net(x);
classes = vec2ind(y);
%%
for i = 1 : length(classes)
    if  lable{1,i} == "business"
        KnownGroups(i) = 1;
    elseif  lable{1,i} == "entertainment"
        KnownGroups(i) = 2;
    elseif  lable{1,i} == "politics"
        KnownGroups(i) = 3;
    elseif  lable{1,i} == "sport"
        KnownGroups(i) = 4;
    elseif  lable{1,i} == "tech"
        KnownGroups(i) = 5;
    end
end
C = confusionmat(KnownGroups,classes);
confusionchart(C)


