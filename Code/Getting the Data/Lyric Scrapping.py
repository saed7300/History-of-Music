#!/usr/bin/env python
# coding: utf-8

# In[1]:


import lyricsgenius
import json
import requests
import pandas as pd
import re
import nltk
import string
from nltk.corpus import stopwordsh
import csv
import os


# In[2]:


'''
Song import
'''
#First thing is to import all top 50 songs per year by decade mannually created

song_ranks_60s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 60s.xlsx')
#print (song_ranks_df)
del song_ranks_60s_df["Title-Unclean"]
display(song_ranks_60s_df.head())
#print (song_ranks_df)

song_ranks_70s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 70s.xlsx')
#print (song_ranks_df)
del song_ranks_70s_df["Title-Unclean"]
display(song_ranks_70s_df.head())

song_ranks_80s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 80s.xlsx')
#print (song_ranks_df)
del song_ranks_80s_df["Title-Unclean"]
display(song_ranks_80s_df.head())

song_ranks_90s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 90s.xlsx')
#print (song_ranks_df)
del song_ranks_90s_df["Title-Unclean"]
display(song_ranks_90s_df.head())

song_ranks_2000s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2000s.xlsx')
#print (song_ranks_df)
del song_ranks_2000s_df["Title-Unclean"]
display(song_ranks_2000s_df.head())

song_ranks_2010s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2010s.xlsx')
#print (song_ranks_df)
del song_ranks_2010s_df["Title-Unclean"]
display(song_ranks_2010s_df.head())

song_ranks_2020s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2020s.xlsx')
#print (song_ranks_df)
del song_ranks_2020s_df["Title-Unclean"]
display(song_ranks_2020s_df.head())


#for index, row in artist_song_df.iterrows():
   # print(row['Artist'], row['Song Title'])


# In[3]:


'''
Create empty csv and list
'''

sixtys_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_60s.csv'
seventys_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_70s.csv'
eightys_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_80s.csv'
nintys_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_90s.csv'
twothousand_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2000s.csv'
twoten_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2010s.csv'
twotwo_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2020s.csv'

sixtys_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_60s.txt'
seventys_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_70s.txt'
eightys_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_80s.txt'
nintys_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_90s.txt'
twothousand_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_2000s.txt'
twoten_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_2010s.txt'
twotwo_txt = r'C:\Users\sneaz\Documents\ML\song_lyrics_2020s.txt'

with open(sixtys_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(sixtys_txt, "w") as empty_txt:
    pass


with open(seventys_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(seventys_txt, "w") as empty_txt:
    pass


with open(eightys_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(eightys_txt, "w") as empty_txt:
    pass


with open(nintys_sheet, "w") as my_em9pty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(nintys_txt, "w") as empty_txt:
    pass


with open(twothousand_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(twothousand_txt, "w") as empty_txt:
    pass


with open(twoten_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(twoten_txt, "w") as empty_txt:
    pass


with open(twotwo_sheet, "w") as my_empty_csv:
  # now you have an empty file already
  pass  # or write something to it already

with open(twotwo_txt, "w") as empty_txt:
    pass


# In[4]:


column_names = ['sixtys', 'seventys', 'eightys', 'nintys', 'twothousand', 'twoten', 'twotwo']

excel_dict = {
    'sixtys': [sixtys_sheet, sixtys_txt, song_ranks_60s_df],
    'seventys': [seventys_sheet, seventys_txt, song_ranks_70s_df],
    'eightys': [eightys_sheet, eightys_txt, song_ranks_80s_df],
    'nintys': [nintys_sheet, nintys_txt, song_ranks_90s_df],
    'twothousand': [twothousand_sheet, twothousand_txt, song_ranks_2000s_df],
    'twoten': [twoten_sheet, twoten_txt, song_ranks_2010s_df],
    'twotwo': [twotwo_sheet, twotwo_txt, song_ranks_2020s_df]}
excel_df = pd.DataFrame(excel_dict)

display(excel_df['sixtys'][0])

for i in column_names:
    decade = excel_dict[i]
    print(decade[0])
    print(decade[1])
    display(decade[2].head())


# In[5]:


'''
Definitions
'''

def remove_first_n_char(org_str, n):
    """ Return a string by deleting first n
    characters from the string """
    mod_string = ""
    for i in range(n, len(org_str)):
        mod_string = mod_string + org_str[i]
    return mod_string

def retreive_lyrics(title, artist_name):
    #print(title)
    len_title = len(title) + len("Lyrics") +1
    #print(len_title)
    genius = lyricsgenius.Genius("A078LmgK2AIXmmRVRgiZtgoUzX-CogEmkiG0CYy-pEGElmQr5YAoMFdKtMeWq2Mp")
    artist = genius.search_artist(artist_name, max_songs=0)
    #print(artist)
    song_search = genius.search_song(title, artist.name)
    artist.add_song(song_search)
    #print(artist)
    #print(song_search)
    #print(type(song_search))
    aux=artist.save_lyrics(filename='artist.json', overwrite=True,verbose=True)

    with open("artist.json") as f:
        j = json.load(f)
        #print(j)
    lyrics_string = j['songs'][0]['lyrics']
    lyrics_string = remove_first_n_char(lyrics_string, len_title)
    #print(lyrics_string)
    
    with open(r'C:\Users\sneaz\Documents\ML\song_lyrics.json', 'w') as f:
        json.dump(lyrics_string, f)
    #out_file = open(r'C:\Users\sneaz\Documents\ML\song_lyrics.json', 'w')
    #json.dumps(lyrics_string, out_file, indent = 4, sort_keys = False)
    #out_file.close()   
    return print('complete')

stop_words = stopwords.words("english")
def text_cleaning(text_to_clean):
    text_to_clean = str(text_to_clean)
    #text_to_clean = re.sub(r"[\([{})\]]", "", text_to_clean)
    text_to_clean = re.sub("[\(\[].*?[\)\]]", "", text_to_clean)
    text_to_clean = text_to_clean.lower()
    text_to_clean = text_to_clean.encode('ascii', 'ignore').decode()
    text_to_clean = re.sub(r'\'\w+', '', text_to_clean)
    text_to_clean = re.sub('[%s]' % re.escape(string.punctuation), ' ', text_to_clean)
    text_to_clean = re.sub(r'\w*\d+\w*', '',text_to_clean)
    text_to_clean = re.sub(r'\s{2,}', ' ', text_to_clean)
    text_list = text_to_clean.split()
    text_to_clean = [w for w in text_list if not w.lower() in stop_words]
    print(text_to_clean)
    #text_to_clean = re.sub("([\(\[]).*?([\)\]])", "\g<1>\g<2>", text_to_clean)  
    return text_to_clean

def song_lyrics_scrape(data, folder, txt):
    song_lyric_list = []
    data = data
    folder = folder
    txt = txt
    display(data.head())
    for index, row in data.iterrows():
        #print(index)
        #print(row['Artist'], row['Song Title'])
        song_title = row['Song Title']
        #print(song_title)
        artist_name = row['Artist']
        #print(artist_name)
        try:
            #print(row['Rank'])
            #print(row['Artist'], row['Song Title'])
            song_title = row['Song Title']
            print(song_title)
            artist_name = row['Artist']
            print(artist_name)
            retreive_lyrics(title = row['Song Title'], artist_name = row['Artist'])
            #print(retreive_lyrics)
            #print("here")
            with open(r'C:\Users\sneaz\Documents\ML\song_lyrics.json', encoding='utf-8') as inputfile:
                df = json.load(inputfile)
                #print(df)
                #print(type(df))
                df_list = text_cleaning(df)
                print(type(df_list))

                song_lyric_list.extend(df_list)
                

                with open(folder, 'a') as f:
                    writer = csv.writer(f)
                    writer.writerow(df_list)                    
                
        except:
            print("error")
            
    song_lyric_string = ' '.join(song_lyric_list)
    #print(song_lyric_string)
    text_file = open(txt, 'a')
    n = text_file.write(' ')
    n = text_file.write(song_lyric_string)
    text_file.close()
            
    if os.path.exists(r'C:\Users\sneaz\Machine Learning\lyrics_one_song.json'):
        os.remove(r'C:\Users\sneaz\Machine Learning\lyrics_one_song.json')
    return print('all files made')


# In[ ]:



   for i in column_names:
    decade = excel_dict[i]
    folder = decade[0]
    print(folder)
    txt = decade[1]
    data = decade[2]
    song_lyrics_scrape(data=data, folder=folder, txt=txt)

    

