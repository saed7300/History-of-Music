#!/usr/bin/env python
# coding: utf-8

# In[2]:


import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import requests
import json
import pandas as pd


# In[ ]:


'''
Spotify API Inof
'''
def get_spotify_header():
    CLIENT_ID = "5aa42a570bb3412c89e41358df34bc34"
    CLIENT_SECRET = "5143f074844b418a9826ff702322f06e"

    AUTH_URL = "https://accounts.spotify.com/api/token"
    auth_response = requests.post(AUTH_URL, {
        'grant_type': 'client_credentials',
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
    })
    #Convert response to JSON
    auth_response_data = auth_response.json()
    #Save the access token
    access_token = auth_response_data['access_token']
    #Need to pass access token into header to send properly formed GET request to API server
    headers = {
        'Authorization': 'Bearer {token}'.format(token=access_token)
    }
    return headers


# In[203]:


'''
Definitions
'''
BASE_URL = 'https://api.spotify.com/v1/'

def get_features(data, folder):
    data_df = data
    data_df_clean = data_df[['Artist', 'Song Title']]
    features_columns = {
        'Artist Name': [],
        'Song Title': [],
        'danceability': [],
        'energy': [],
        'key': [],
        'loudness': [],
        'mode': [],
        'speechiness': [],
        'acousticness': [],
        'instrumentalness': [],
        'liveness': [],
        'valence': [],
        'tempo': [],
        'type': [],
        'id': [],
        'uri': [],
        'track_href': [],
        'analysis_url': [],
        'duration_ms': [],
        'time_signature': []    
    }

    features_df = pd.DataFrame(features_columns)

    for index, row in data_df_clean.iterrows():
        try:
            headers = get_spotify_header()
            #print(index)
            artist_name = row['Artist']
            song_name = row['Song Title']
            #print(artist_name, song_name)

            r = requests.get(BASE_URL + 'search?q=track%3A%20'+song_name+'%20artist%3A%20'+artist_name+'&type=track', headers=headers)
            r = r.json()
            #print(r)
            try:
                with open('song_data.json', 'w') as outfile:
                    json.dump(r, outfile)

                with open('song_data.json') as outfile:
                    j = json.load(outfile)
                    load_in = j['tracks']['items'][0]['name']
                    #print(load_in)
                    #print(type(load_in))    
                    name_in = j['tracks']['items']
                    #print(name_in)
                    #print(type(name_in))
                    #print(len(name_in))
                    song_id = name_in[0]['id']
                    #print(song_id)
                    features = requests.get(BASE_URL + 'audio-features?ids=' + song_id, headers=headers)
                    features = features.json()
                    #print(features)
                    with open('features_song_data.json', 'w') as outfile:
                        json.dump(features, outfile)

                    with open('features_song_data.json') as outfile:
                        features_json = json.load(outfile)
                        features_load = features_json['audio_features'][0]
                        #print(features_load)
                        #print(type(features_load))
                        features_load["Artist Name"] = artist_name
                        features_load["Song Title"] = song_name
                        features_df = features_df.append(features_load, ignore_index=True)
                        #display(features_df)

            except:
                error = "not found in code"
                print(error)
            features_df.to_csv(folder)
        except:
            print('can not get track or artist')


# In[179]:


'''
import csvs

'''
song_ranks_60s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 60s.xlsx')
song_ranks_70s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 70s.xlsx')
song_ranks_80s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 80s.xlsx')
song_ranks_90s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 90s.xlsx')
song_ranks_2000s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2000s.xlsx')
song_ranks_2010s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2010s.xlsx')
song_ranks_2020s_df = pd.read_excel (r'C:\Users\sneaz\Documents\ML\Top Songs 2020s.xlsx')

sixtys_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_60s_features.csv'
seventys_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_70s_features.csv'
eightys_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_80s_features.csv'
nintys_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_90s_features.csv'
twothousand_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2000s_features.csv'
twoten_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2010s_features.csv'
twotwo_features_sheet = r'C:\Users\sneaz\Documents\ML\song_lyrics_2020s_features.csv'


# In[204]:


column_names = ['sixtys', 'seventys', 'eightys', 'nintys', 'twothousand', 'twoten', 'twotwo']

excel_dict = {
    'sixtys': [song_ranks_60s_df, sixtys_features_sheet],
    'seventys': [song_ranks_70s_df, seventys_features_sheet],
    'eightys': [song_ranks_80s_df, eightys_features_sheet],
    'nintys': [song_ranks_90s_df, nintys_features_sheet],
    'twothousand': [song_ranks_2000s_df, twothousand_features_sheet],
    'twoten': [song_ranks_2010s_df, twoten_features_sheet],
    'twotwo': [song_ranks_2020s_df, twotwo_features_sheet]
}
excel_df = pd.DataFrame(excel_dict)


# In[206]:


for i in column_names:
    decade = excel_dict[i]
    data = decade[0]
    folder = decade[1]
    get_features(data = data, folder = folder)
    

