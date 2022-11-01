#!/usr/bin/env python
# coding: utf-8

# In[6]:


import json
import pandas as pd
import requests
import base64
import io
import re
import nltk
import string
from nltk.corpus import stopwords
import numpy as np
import csv
import os
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import seaborn as sns


# In[7]:


'''
Pull txt the data from GitHub
'''
url_60 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_60s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_60)
txt_60=req.text

url_70 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_70s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_70)
txt_70=req.text

url_80 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_80s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_80)
txt_80=req.text

url_90 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_90s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_90)
txt_90=req.text

url_2000 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_2000s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_2000)
txt_2000=req.text

url_2010 = "https://github.com/saed7300/Music-Through-the-Decades/blob/main/Data/Song%20Lyrics/song_lyrics_2010s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_2010)
txt_2010=req.text

url_2020 = "https://raw.githubusercontent.com/saed7300/Music-Through-the-Decades/main/Data/Song%20Lyrics/song_lyrics_2020s.txt" # Make sure the url is the raw version of the file on GitHub
req = requests.get(url_2020)
txt_2020=req.text


# In[8]:


'''
Txt Dict
'''
column_names = ['sixtys', 'seventys', 'eightys', 'nintys', 'two_thousand', 'twoten', 'twotwo']

# Downloading the csv file from your GitHub account

sixtys_txt = txt_60
seventys_txt = txt_70
eightys_txt = txt_80
nintys_txt = txt_90
twothousand_txt = txt_2000
twoten_txt = txt_2010
twotwo_txt = txt_2020

#Uploading all images to own computer file
sixtys_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_60s_clean1.png'
seventys_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_70s_clean1.png'
eightys_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_80s_clean1.png'
nintys_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_90s_clean1.png'
twothousand_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_2000s_clean1.png'
twoten_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_2010s_clean1.png'
twotwo_png = r'C:\Users\sneaz\Documents\ML\song_lyrics_2020s_clean1.png'

decad_dict = {
    'sixtys': [sixtys_txt, sixtys_png, '60s Word Cloud'],
    'seventys': [seventys_txt, seventys_png, '70s Word Cloud'],
    'eightys': [eightys_txt, eightys_png, '80s Word Cloud'],
    'nintys': [nintys_txt, nintys_png, '90s Word Cloud'],
    'two_thousand': [twothousand_txt, twothousand_png, '2000s Word Cloud'],
    'twoten': [twoten_txt, twoten_png, '2010s Word Cloud'],
    'twotwo': [twotwo_txt, twotwo_png, '2020s Word Cloud']
}

decad_df = pd.DataFrame(decad_dict)


# In[9]:


def word_cloud_vis(txt, png, title):
    string = txt
    print(type(string))
    
    #Clean up a few more lyrics missed in the origional cleaning
    clean_string = string.replace('yeah ', '')
    clean_string = clean_string.replace('oh ', '')
    clean_string = clean_string.replace('da ', '')
    clean_string = clean_string.replace('na ', '')
    clean_string = clean_string.replace('o ', '')
    clean_string = clean_string.replace('ain ', '')
    clean_string = clean_string.replace('got ', '')

    word_cloud = WordCloud(collocations = False, background_color = 'azure').generate(clean_string)
# Display the generated Word Cloud
    plt.imshow(word_cloud, interpolation='bilinear')
    plt.axis("off")
    plt.title(label=title, loc="left")
    plt.savefig(png, dpi=300, bbox_inches="tight")
    plt.show()
        
    


# In[10]:



for i in column_names:
    decade = decad_df[i]
    txt = decade[0]
    #print(txt)
    png = decade[1]
    print(png)
    title = decade[2]
    word_cloud_vis(txt = txt, png = png, title = title)

