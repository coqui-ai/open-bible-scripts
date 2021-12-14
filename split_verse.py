# Imports 

import os, re
import json
import argparse
import time

from collections import defaultdict

import pandas as pd

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run verse split pipeline")
    parser.add_argument("-wav_folder", "--path_to_wavs", default="data/lnOMNB20_MAT_wav/")
    parser.add_argument("-timing_folder", "--path_to_timings", default="data/lnOMNB20_timingfiles/timingfiles/MAT/")
    parser.add_argument("-book_sfm", "--path_to_book_sfm", default="data/lnOMNB20_USFM/41MATlnOMNB20.SFM")
    parser.add_argument("-o", "--output", default="data/MAT/")

    args = parser.parse_args()
    
    path_to_wavs = args.path_to_wavs
    path_to_timings = args.path_to_timings
    path_to_book_sfm = args.path_to_book_sfm
    output = args.output
    
    if not os.path.exists(f"{output}"):
        os.makedirs(f"{output}")
    
    dict_chap_verse = defaultdict(lambda : [])
    current_chap = None
    current_verse = None
    # Open file for read
    with open(f'{path_to_book_sfm}', 'r') as f: 
        for textline in f:
            current_txt = textline.split()
            if len(current_txt) == 0:
                continue
            if current_txt[0] =='\\c':
                current_chap = current_txt[1]
                current_verse = None
                continue
            
            if current_txt[0] =='\\v':
                current_verse = current_txt[1]
                # TODO: Are we not missing some aspect of the language here ?
                content = re.sub(r"[^a-zA-Z0-9?'’‘´`-]+", ' ', textline[len(current_txt[0]+current_txt[1])+2:]).strip()
                dict_chap_verse[current_chap].append(content)
            elif len(current_txt) == 1:
                continue 
            elif current_chap and current_verse:
                content = re.sub(r"[^a-zA-Z0-9?'’‘´`-]+", ' ', textline[len(current_txt[0])+2:]).strip()
                dict_chap_verse[current_chap][int(current_verse)-1] += " " + content
                                
                
                
                
            # verse_time = textline.split("\t")
    
    
    for file in os.listdir(path_to_wavs):
        book_chap, ext = file.split('.')
        if ext != 'wav':
            continue
        book, chap = book_chap.split('_')
        
        # Global dictionary to keep verse, [time_start, time_end]
        dict_verse_time = defaultdict(lambda : [])
        # open the and read file on in the first repository             
        with open(f'{path_to_timings}{book_chap}.txt', 'r') as f:  # Open file for read
            for textline in f:
                verse_time = textline.split("\t")
                # This handles the file version case
                if len(verse_time) == 1 or len(verse_time[0].split()) == 1:
                    continue
                else:
                    # This skips the Chapter Title and Headings
                    
                    verse, number = verse_time[0].split()
                    if verse != "Verse":
                        continue 
                    else:
                        time = verse_time[1]
                        dict_verse_time[f'{verse}_{number.zfill(3)}'].append(time)
                        if int(number)-1==0:
                            pass
                        else:
                            dict_verse_time[f'{verse}_{str(int(number)-1).zfill(3)}'].append(time)
                             
                        
                        
                  
        for verse_key in dict_verse_time:
            audio = f"{path_to_wavs}{file}"  
            output_file = f"{output}{book_chap}_{verse_key}.wav"
            
            if len(dict_verse_time[verse_key])==2:
                os.system(f"sox {audio} {output_file} trim {dict_verse_time[verse_key][0]} ={dict_verse_time[verse_key][1]}")
            else:
                os.system(f"sox {audio} {output_file} trim {dict_verse_time[verse_key][0]}")
            
            with open(f'{output}{book_chap}_{verse_key}.txt', "w", encoding="utf-8") as text_file:
                text_file.write(dict_chap_verse[str(int(chap))][int(verse_key.split('_')[1])-1])
                text_file.write("\n")  
                      
        continue
    
    
    
    
    
