clc
clear all
close all
tic 
%% data importation
% number of input
totalNumOfInputs = 2225;
% open Csv file and get data
[~,origTable,~] = xlsread('bbc-text.csv');
% Removes the titles
origTable(1,:) = [];
% extract lable and news from csv file
lable = origTable(:,1)';
news = origTable(:,2);
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
documents = tokenizedDocument(documents);
% Creating bag of word
bag = bagOfWords(documents) 
% Set the TF factor to 1 + log(bag.Counts).
TFWeight = 'log';
% log(N/NT),where N is the number of documents in the input data and NT is 
% the number of documents in the input data containing each term.
IDFWeight = 'normal';
TF_IDF = tfidf(bag,'TFWeight','log','IDFWeight','normal');
%% Creating Self organizing Map Network for Clustering
% creating input
y = TF_IDF';
x = full(y);
% create som network
net = selforgmap(5, 100, 3, 'hextop', 'linkdist');% dimensions, coverStepsm, initNeighbor, topologyFcn, distanceFcn
net.trainParam.epochs = 500;
net = train(net,x);
view(net)
y = net(x);
% creating number idicator to number of that class
classes = vec2ind(y);
%%
% Creating True Lable & compare them with clustered data
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
toc
%% checking competetive layer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Antoher Network%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Competitive layers learn to classify input vectors into a given number of 
% classes, according to similarity between vectors, with a preference for 
% equal numbers of vectors per class.
% competlayer(numClasses,kohonenLR,conscienceLR)
% to run another network please uncomment this section
% CODE:

% y = TF_IDF';
% x = full(y);
% net = competlayer(5);
% net = train(net,x);
% view(net)
% outputs = net(x);
% classes = vec2ind(outputs);
% figure,
% C = confusionmat(KnownGroups,classes);
% confusionchart(C)
