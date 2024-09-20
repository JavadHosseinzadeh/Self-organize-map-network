clc
clear all
close all
%% data importation
totalNumOfInputs = 2;
[~,origTable,~] = xlsread('bbc-text.csv');
origTable(1,:)=[];% Removes the titles
myList = {} ;
lable = origTable(:,1)';
% Importing Stopwords
FID = fopen('stopwords.txt');
data = textscan(FID,'%s');
fclose(FID);
myStopWords = string(data{:});
%% preprocessing
for i = 1: totalNumOfInputs
    textData = strsplit(string(origTable(i,2)));
    % Remove all non-letter characters from the documents.
    Len = length(textData);
    count = 1;
    while count <= Len
       if isletter(textData(count))==0  
          textData(count) = [];
          Len = Len -1;
          if count > 3
                count = count - 3;
          else
              count = 1;   
          end
       end
       count = count + 1;
    end
    
    % Remove all stop words.
    Len = length(textData);
    count = 1;
    while count <= Len
        for s = 1: length(myStopWords)
           if textData(count) == myStopWords(s,1)   
              textData(count) = [];
              Len = Len -1;
              if count > 3
                count = count - 3;
              else
                count = 1;   
              end
              break;
           end
        end
       count = count + 1;
    end

    % Remove all "."
    Len = length(textData);
    for count = 1 : Len
        textData(1,count) = erase(textData(1,count),".");
    end
    
    
    % Remove all punctuations ('-', '(', ...)
    Len = length(textData);
    count = 1;
    while count <= Len
        str = textData(1,count);
        textData(1,count) = regexprep(str,'[^a-zA-Z\s]','');
        count = count + 1;
    end   
    
    % Remove the short words (length ≤ 2).
    Len = length(textData);
    count = 1;
    while count <= Len
       if strlength(textData(count)) <= 2   
          textData(count) = [];
          Len = Len -1;
          if count > 3
                count = count - 3;
          else
              count = 1;   
          end
       end
       count = count + 1;
    end
    
    myList{i} = textData;
    i
end

for i = 1 : totalNumOfInputs
    ss(i,1) = strjoin([myList{i}]);
end

%% Create a Term Frequency–Inverse Document Frequency (tf-idf) matrix from a bag-of-words model.
textData = split(ss,newline);
documents = tokenizedDocument(textData);
bag = bagOfWords(documents) 
TFWeight = 'log';% Set the TF factor to 1 + log(bag.Counts).
IDFWeight = 'normal';% log(N/NT),where N is the number of documents in the input data and NT is the number of documents in the input data containing each term.
TF_IDF = tfidf(bag);
%%
bag.Vocabulary(2)
bag.Counts(2,1)
%% Creating Self organizing Map Network for Clustering
y = TF_IDF';
x = full(y);
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