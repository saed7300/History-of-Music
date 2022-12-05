#!/usr/bin/env python
# coding: utf-8

# In[71]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.svm import SVC
import graphviz 
from sklearn.metrics import confusion_matrix
from sklearn.tree import DecisionTreeClassifier
from sklearn import tree
import matplotlib.pyplot as plt
import numpy as np
from sklearn.naive_bayes import MultinomialNB
from sklearn import preprocessing
from sklearn.metrics import accuracy_score


# In[3]:


url = 'https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv'

df = pd.read_csv(url)
df.head()


# In[89]:


genre_model = df.drop(['key','Decade', 'key_character', 'duration','mode', 'mode_char', 'Artist', 'Song.Title', 'Year', 'Rank', 'energy', 'speechiness', 'time_signature' ], axis=True)
print(genre_model.head())
decade_model = df.drop(['key','Genre', 'key_character', 'duration','mode', 'mode_char', 'Artist', 'Song.Title', 'Year', 'Rank', 'energy', 'speechiness', 'time_signature' ], axis=True)
decade_model.head()


# In[75]:


down_sample =genre_model
down_sample = down_sample.loc[down_sample['Genre'].isin(['Rock', 'Pop', 'R&B/Soul'])]
down_sample['Genre'].nunique()
down_sample.head()


# In[76]:


rock_features = down_sample[down_sample['Genre'] == 'Rock']
pop_features = down_sample[down_sample['Genre'] == 'Pop']
rb_features = down_sample[down_sample['Genre'] == 'R&B/Soul']
print(rock_features.shape)
print(pop_features.shape)
print(rb_features.shape)
rb_features.head()


# In[77]:


from sklearn.utils import resample
rock_downsample = resample(rock_features,
             replace=True,
             n_samples=len(rock_features),
             random_state=42)
pop_downsample = resample(pop_features,
             replace=True,
             n_samples=len(rock_features),
             random_state=42)
rb_downsample = resample(rb_features,
             replace=True,
             n_samples=len(rb_features),
             random_state=42)

print(rock_downsample.shape)
print(pop_downsample.shape)
print(rb_downsample.shape)
rock_downsample.head()


# In[79]:


data_downsampled = pd.concat([rock_downsample, pop_downsample, rb_downsample])
print(data_downsampled["Genre"].value_counts())
data_downsampled['loudness'] = data_downsampled['loudness'].abs()

data_downsampled.head()


# In[64]:





# In[80]:


from sklearn.model_selection import train_test_split

train_df, test_df = train_test_split(data_downsampled, test_size=0.25)
print(train_df)


# In[81]:


test_labels=test_df["Genre"]
test_df = test_df.drop(["Genre"], axis=1)
test_df = preprocessing.normalize(test_df)
train_labels=train_df["Genre"]
train_df = train_df.drop(["Genre"], axis=1)
train_df = preprocessing.normalize(train_df)


# In[34]:





# In[82]:


nb_model = MultinomialNB()
nb_model.fit(train_df, train_labels)


# In[83]:


predict = nb_model.predict(test_df)
print('NB prediction:')
print(predict)
print('Actual Labels:')
print(test_labels)


# In[84]:


cnf_matrix = confusion_matrix(test_labels, predict)
print("The confusion matrix is:")
print(cnf_matrix)
print("The probabilities")
print(np.round(nb_model.predict_proba(test_df),2))

acc_score = accuracy_score(test_labels, predict)
print("Accuracy:")
print(acc_score)


# In[103]:


down_sample =decade_model
down_sample = down_sample.loc[down_sample["Decade"] != '2022s']
down_sample['Decade'].nunique()
down_sample.head()


# In[105]:


down_sample['loudness'] = down_sample['loudness'].abs()
down_sample.head()


# In[106]:


from sklearn.model_selection import train_test_split

train_df, test_df = train_test_split(down_sample, test_size=0.25)
print(train_df)


# In[111]:


test_labels=test_df["Decade"]
test_df = test_df.drop(["Decade"], axis=1)
test_df = preprocessing.normalize(test_df)
train_labels=train_df["Decade"]
train_df = train_df.drop(["Decade"], axis=1)
train_df = preprocessing.normalize(train_df)


# In[108]:


nb_model = MultinomialNB()
nb_model.fit(train_df, train_labels)


# In[109]:


predict = nb_model.predict(test_df)
print('NB prediction:')
print(predict)
print('Actual Labels:')
print(test_labels)


# In[110]:


cnf_matrix = confusion_matrix(test_labels, predict)
print("The confusion matrix is:")
print(cnf_matrix)
print("The probabilities")
print(np.round(nb_model.predict_proba(test_df),2))

acc_score = accuracy_score(test_labels, predict)
print("Accuracy:")
print(acc_score)


# In[ ]:




