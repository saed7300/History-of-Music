#!/usr/bin/env python
# coding: utf-8

# In[40]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
url = 'https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Features/clean_feature_data.csv'

df = pd.read_csv(url)
df.head()
clean_df = df.drop(['key', 'key_character','tempo', 'Decade','liveness', 'acousticness', 'instrumentalness','mode_char', 'duration', 'mode', 'Artist', 'Song.Title', 'Year', 'Rank', 'energy', 'speechiness', 'time_signature' ], axis=True)
clean_df.head()


# In[42]:


down_sample =clean_df
down_sample = down_sample.loc[down_sample['Genre'].isin(['Rock', 'Pop'])]
down_sample['Genre'].nunique()
down_sample.head()
rock_features = down_sample[down_sample['Genre'] == 'Rock']
pop_features = down_sample[down_sample['Genre'] == 'Pop']
print(rock_features.shape)
print(pop_features.shape)
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

data_downsampled = pd.concat([rock_downsample, pop_downsample])
print(data_downsampled["Genre"].value_counts())


# In[54]:


data_downsampled['Genre'] = data_downsampled['Genre'].replace('Pop',0)
data_downsampled['Genre'] = data_downsampled['Genre'].replace('Rock',1)


# In[69]:


norm_data = data_downsampled
print(clean_df)
norm_data["danceability"] = (norm_data["danceability"] - norm_data["danceability"].min()) / (norm_data["danceability"].max() - norm_data["danceability"].min()) 
norm_data["loudness"] = (norm_data["loudness"] - norm_data["loudness"].min()) / (norm_data["loudness"].max() - norm_data["loudness"].min()) 
norm_data["valence"] = (norm_data["valence"] - norm_data["valence"].min()) / (norm_data["valence"].max() - norm_data["valence"].min()) 
#print(norm_data.head())

X_norm = norm_data.iloc[:,1:3]
print(X_norm)
X_norm = np.array(X_norm)
#print(X_norm)
print(X_norm.shape)

Y_norm = norm_data.iloc[:,0]
#print(Y_norm)
Y_norm = np.array([Y_norm])
print(Y_norm.shape)
Y_norm = Y_norm.T
print(Y_norm.shape)


# In[72]:


df_colnum = 2
plt.scatter(X[:,0],X[:,1])
plt.show()


# In[74]:


#Making the weights
#Will normalize later
W = np.random.random(df_colnum)
print(W)
print(W.shape)
#make the weights an array
W=np.array([W])
print(W)
print(W.shape)
#setting inital bais
b=0
#Setting learning rate and epocs
#Setting learning rate small to not miss
lr = .0000001
epochs = 10
#Setting up error vis
errors = []
total_errors = 0
len_X = len(X_norm)
print(len_X)
#Linear Equation
Y_hat = (X_norm@W.T+b)
#print(X.shape)
print(W.shape)
#print(Y_hat)
#Errors
#Making sure to use Y transposed
Error = Y_hat-Y_norm
#print(Error)
print("Error mean")
print(np.mean(Error))
print(Error.shape)
#Derivatives
#print(np.mean(X*Error, axis=0))
dL_dW = (np.mean(X_norm*Error, axis=0))
print(dL_dW)

dL_db = np.mean(Error)
print(dL_db)
#weight and bias adjustment
W=W-(lr*dL_dW)
print(W)

b=b-(lr*dL_db)
print(b)


# In[75]:


X=X_norm
Y_T=Y_norm
for i in range (epochs):
    epochs = i
    print("epoch #")
    print(epochs)
    #linear equation
    Y_hat = (X@W.T+b)
    
    #error
    Error = Y_hat-Y_T
    #view all errors
    errors.append(Error)
    
    #derivatives
    dL_dW = (np.mean(X*Error, axis=0))
    dL_db = np.mean(Error)
    
    #weight and bias adjustments
    W=W-(lr*dL_dW)
    b=b-(lr*dL_db)
    
    #recall Y_T is the correct transposed
    print("Y_hat is \n", Y_hat)
    print("Y is: \n",Y_T)
    


# In[76]:


from tensorflow.keras import datasets, layers, models
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X_norm, Y_norm, random_state=0, train_size = .75)
print(X_train.shape)
print(y_train.shape)
print(X_test.shape)
print(y_test.shape)


# In[89]:


# importing the libraries
from keras.models import Sequential
import tensorflow as tf
from tensorflow.keras.layers import Dense, Dropout, Input
from tensorflow.keras.models import Model

#Creting the model with activation relu
model = Sequential()
model.add(Dense(units=5, input_dim=2, kernel_initializer='normal', activation='relu'))

model.summary()

model.compile(loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True), optimizer='adam', metrics=['accuracy'])
history = model.fit(X_train, y_train, epochs=10, 
                    validation_data=(X_test, y_test))


# In[91]:


import tensorflow as tf
model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              ## Using True above means you do not use one-hot-encoding
              metrics=['accuracy'])


# In[81]:


history = model.fit(X_train, y_train ,batch_size = 20, epochs = 500, verbose=1)


# In[97]:


plt.plot(history.history['accuracy'], label='accuracy')
plt.plot(history.history['val_accuracy'], label = 'val_accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.ylim([0.5, 1])
plt.legend(loc='lower right')

test_loss, test_acc = model.evaluate(X_test, y_test, verbose=2)
print(model(X_test, y_test))

print(test_acc)


# In[ ]:




