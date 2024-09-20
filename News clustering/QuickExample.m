textData = ["Hello, i am Javad hosseinzadeh"]
documents = tokenizedDocument(textData)
documents = addPartOfSpeechDetails(documents)
tdetails = tokenDetails(documents)
%% 
clc
clear all
textData = ["سلام  اسم من جواد حسینزاده است"]
documents = tokenizedDocument(textData)
documents=addPartOfSpeechDetails(documents)
tdetails = tokenDetails(documents);
documents = removeShortWords(documents,2)