function documents = preprocessText(textData)
% Tokenize the text.
documents = tokenizedDocument(textData);
documents = addPartOfSpeechDetails(documents);
documents = removeStopWords(documents);
documents = normalizeWords(documents,'Style','stem');
% documents = normalizeWords(documents,'Style','lemma');
% documents = normalizeWords(documents,'language','en');
documents = erasePunctuation(documents);
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);
end