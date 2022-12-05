#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.svm import SVC


# In[ ]:


url = 'https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv'

df = pd.read_csv(url)
df.head()


# In[ ]:


clean_df_complex= df.drop(['key', 'mode_char', 'key_character', 'Decade', 'duration', 'mode', 'Artist', 'Song.Title', 'Year', 'Rank', 'energy', 'speechiness', 'time_signature' ], axis=True)
clean_df_complex.head()


# In[ ]:


down_sample =clean_df_complex
down_sample = down_sample.loc[down_sample['Genre'].isin(['Rock', 'Pop'])]
down_sample['Genre'].nunique()
down_sample.head()


# In[ ]:


rock_features = down_sample[down_sample['Genre'] == 'Rock']
pop_features = down_sample[down_sample['Genre'] == 'Pop']
print(rock_features.shape)
print(pop_features.shape)
rb_features.head()


# In[ ]:


from sklearn.utils import resample
rock_downsample = resample(rock_features,
             replace=True,
             n_samples=len(rock_features),
             random_state=42)
pop_downsample = resample(pop_features,
             replace=True,
             n_samples=len(rock_features),
             random_state=42)
print(rock_downsample.shape)
print(pop_downsample.shape)


# In[ ]:



data_downsampled = pd.concat([rock_downsample, pop_downsample])
print(data_downsampled["Genre"].value_counts())


# In[ ]:


data_downsampled_target= data_downsampled.iloc[:,-8]
print(data_downsampled_target)
data_downsampled_values= data_downsampled.iloc[:,1:8].values
print(data_downsampled_values)


# In[ ]:


from sklearn.model_selection import train_test_split
# Split dataset into training set and test set
X_train, X_test, y_train, y_test = train_test_split(data_downsampled_values, data_downsampled_target, test_size= 0.25,random_state=0) 


# In[ ]:





# In[ ]:


from sklearn.svm import SVC
classifier = SVC(kernel = 'linear', random_state = 0)
#Fit the model for the data

classifier.fit(X_train, y_train)

#Make the prediction
y_pred = classifier.predict(X_test)


# In[ ]:


from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
print(cm)

from sklearn.model_selection import cross_val_score
accuracies = cross_val_score(estimator = classifier, X = X_train, y = y_train, cv = 10)
print("Accuracy: {:.2f} %".format(accuracies.mean()*100))
print("Standard Deviation: {:.2f} %".format(accuracies.std()*100))


# In[ ]:


classifierirad = SVC(kernel = 'rbf', random_state = 0)
#Fit the model for the data

classifierirad.fit(X_train, y_train)

#Make the prediction
y_pred_rad = classifier.predict(X_test)


# In[ ]:


cm = confusion_matrix(y_test, y_pred_rad)
print(cm)

from sklearn.model_selection import cross_val_score
accuracies = cross_val_score(estimator = classifierirad, X = X_train, y = y_train, cv = 10)
print("Accuracy: {:.2f} %".format(accuracies.mean()*100))
print("Standard Deviation: {:.2f} %".format(accuracies.std()*100))


# In[ ]:


classifier_poly = SVC(kernel = 'poly', random_state = 0)
#Fit the model for the data

classifier_poly.fit(X_train, y_train)

#Make the prediction
y_pred_poly = classifier.predict(X_test)


# In[ ]:


cm = confusion_matrix(y_test, y_pred_poly)
print(cm)

from sklearn.model_selection import cross_val_score
accuracies = cross_val_score(estimator = classifier_poly, X = X_train, y = y_train, cv = 10)
print("Accuracy: {:.2f} %".format(accuracies.mean()*100))
print("Standard Deviation: {:.2f} %".format(accuracies.std()*100))


# In[ ]:





# In[ ]:





# In[ ]:




