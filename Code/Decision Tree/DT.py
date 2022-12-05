#!/usr/bin/env python
# coding: utf-8

# In[3]:


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


# In[4]:


dec_tree=DecisionTreeClassifier(criterion='entropy', ##"entropy" or "gini"
                            splitter='best',  ## or "random" or "best"
                            max_depth=None, 
                            min_samples_split=40, 
                            min_samples_leaf=10, 
                            min_weight_fraction_leaf=0.0, 
                            max_features=3, 
                            random_state=None, 
                            max_leaf_nodes=None, 
                            min_impurity_decrease=0.0, 
                            min_impurity_split=None, 
                            class_weight=None)


# In[5]:


url = 'https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv'

df = pd.read_csv(url)
df.head()


# In[6]:


clean_df = df.drop(['key', 'duration','mode_char', 'mode', 'Artist', 'Song.Title', 'Year', 'Rank', 'energy', 'speechiness', 'time_signature' ], axis=True)
clean_df.head()


# In[7]:


down_sample = clean_df.loc[clean_df['Genre'].isin(['Rock', 'Pop', 'R&B/Soul'])]
down_sample['Genre'].nunique()


# In[8]:


rock_features = down_sample[down_sample['Genre'] == 'Rock']
pop_features = down_sample[down_sample['Genre'] == 'Pop']
rb_features = down_sample[down_sample['Genre'] == 'R&B/Soul']
print(rock_features.shape)
print(pop_features.shape)
print(rb_features.shape)


# In[9]:


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


# In[10]:


data_downsampled = pd.concat([rock_downsample, pop_downsample, rb_downsample])
print(data_downsampled["Genre"].value_counts())


# In[41]:





# In[42]:





# In[11]:


from sklearn.model_selection import train_test_split

train_df, test_df = train_test_split(data_downsampled, test_size=0.25)
print(train_df)


# In[12]:


test_labels=test_df["Genre"]
test_df = test_df.drop(["Genre"], axis=1)
train_labels=train_df["Genre"]
train_df = train_df.drop(["Genre"], axis=1)


# In[13]:


test_df = pd.get_dummies(test_df, drop_first=True)
train_df = pd.get_dummies(train_df, drop_first=True)


# In[14]:



temp1=str("train_df")   ##  TrainDF1
temp2=str("train_labels")  #Train1Labels
temp3=str("test_df")  #TestDF1
temp4=str("test_labels") # Test1Labels

## perform DT
#MyDT.fit(TrainDF1, Train1Labels)
dec_tree.fit(eval(temp1), eval(temp2))
## plot the tree
fig = plt.figure(figsize=(25,20))
tree.plot_tree(dec_tree)
plt.savefig(temp1)
print("\nActual for DataFrame: ", "\n")
print(eval(temp2))
print("Prediction\n")
DT_pred=dec_tree.predict(eval(temp3))
print(DT_pred)
## Show the confusion matrix
bn_matrix = confusion_matrix(eval(temp4), DT_pred)
print("\nThe confusion matrix is:")
print(bn_matrix)
FeatureImp=dec_tree.feature_importances_   
indices = np.argsort(FeatureImp)[::-1]

score = dec_tree.score(eval(temp3), eval(temp4))
print("\nThe accuracy is:")
print(score)


# In[ ]:




