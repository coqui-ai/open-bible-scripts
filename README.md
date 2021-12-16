# Align [`Open.Bible`](https://open.bible/) data

|Language|Passing|Failing|Unknown|
|---------|------|-------|-------|
|Yoruba|💚|||
|Ewe|💚|||
|Chichewa|💚|||
|Lingala|💚|||
|Hausa||💔||
|Luo||💔||
|Luganda||💔||
|Kikuyu||💔||
|Asante Twi||💔||
|Akuapem Twi||💔||
|Arabic|||❓|
|Kurdi Sorani|||❓|
|Polish|||❓|
|Vietnamese|||❓|

### Clone this repo

```
$ git clone https://github.com/coqui-ai/open-bible-scripts.git
```

## Alignment Approach 1: Use the Montreal Forced Aligner

The first alignment approach is to use MFA to align and train a new acoustic model from stratch.

### Dependencies

You need to install a couple things on your own:

[`gnu-parallel`](https://www.gnu.org/software/parallel/)
[`covo`](https://www.github.com/ftyers/commonvoice-utils)

### Start with the run script for pre-processing


Use the language name as defined in `open-bible-scripts/data/*.txt`. Use the language code as expected by [covo](https://www.github.com/ftyers/commonvoice-utils).

E.g., for Yoruba use `yoruba` and `yo`, for Ewe use `ewe` and `ee`, for Luganda `luganda` and `lg`, and so on.

```
$ cd open-bible-scripts
open-bible-scripts$ ./run-pre-alignment.sh yoruba yo
```

### Generate alignments with [`mfa train`](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/workflows/train_acoustic_model.html)

```
$ docker run -it --mount "type=bind,src=/home/ubuntu/open-bible-scripts,dst=/mnt" mmcauliffe/montreal-forced-aligner
(base) root@d8095c794d5f:/# conda activate aligner
(aligner) root@d8095c794d5f:/# mfa train --clean --num_jobs `nproc` --temp_directory /mnt/yoruba/data/mfa-tmp-dir --config_path /mnt/MFA_CONFIG /mnt/yoruba/data /mnt/yoruba/dict.txt /mnt/yoruba/data/mfa-output &> /mnt/yoruba/data/LOG &

# At this point, alignment will take a while,
# so you might want to detach from the docker container 
# with `Ctrl-P followed by Ctrl-Q`
```

### Finish with the run script for post-processing

Use the language name as defined in `open-bible-scripts/data/*.txt`.

E.g., for Yoruba use `yoruba`, for Ewe use `ewe`, for Luganda `luganda`, and so on.

```
$ cd open-bible-scripts
open-bible-scripts$ ./run-post-alignment.sh yoruba yo
```


## Alignment Approach 2: Use timing files from Biblica


### Split using timming file 

Install sox on your OS. See linux installation below
```bash
sudo apt-get install sox
sudo apt-get install libsox-fmt-mp3
sox --version
```

Run the following command from the root

```python
python split_verse.py -wav_folder data/lnOMNB20_MAT_wav/ -timing_folder data/lnOMNB20_timingfiles/timingfiles/MAT/ -book_sfm  data/lnOMNB20_USFM/41MATlnOMNB20.SFM -output /data/MAT/
```
