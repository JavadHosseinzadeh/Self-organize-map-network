SOM below clusters the articles from the BBC-text dataset into five categories, such as business, entertainment, politics, sport, and tech. After that, it preprocesses the text data by tokenizing the text, removing stop words and punctuation, and lemmatizing or stemming the words. Next, it forms a bag-of-words model and then applies TF-IDF to the documents for feature extraction. Principal Component Analysis was conducted to further optimize the input data using a dimensionality reduction.

The SOM was trained by the function `selforgmap`, while the network classified the documents in the five categories. Once trained, the results are considered on a confusion matrix that compares predicted clusters versus actual categories. A confusion matrix is used to visualize the classification accuracy, and it gives a view of the performance of a SOM.

Key scripts included: `FinalProject.m`, which is responsible for SOM training and classification, and `MyPreprocessing.m` for text data preprocessing. Now, the tokenization, stop word removal, and TF-IDF are performed by the custom function `preprocessText.m`.

This project describes unsupervised learning of a SOM for text data classification. Also, applying a dimensionality reduction on the input features makes the SOM grasp the documents much better and visualizes a very clear performance review in the form of a confusion matrix.
