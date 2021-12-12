# Align [`Open.Bible`](https://open.bible/) data

### Clone this repo

```
$ git clone https://github.com/coqui-ai/open-bible-scripts.git
```

### Run the main script `run.sh`

Use the language name as used in the text files in `open-bible-scripts/data/`, and use the language code as expected by [covo](https://www.github.com/ftyers/commonvoice-utils). For Yoruba use `yoruba` and `yo`, for Ewe use `ewe` and `ee`, and so on.

```
$ cd open-bible-scripts
open-bible-scripts$ ./run.sh yoruba yo
```

### Generate alignments with [`mfa train`](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/workflows/train_acoustic_model.html)

```
$ docker run -it --mount "type=bind,src=/home/ubuntu/open-bible-scripts,dst=/mnt" mmcauliffe/montreal-forced-aligner
(base) root@d8095c794d5f:/# conda activate aligner
(aligner) root@d8095c794d5f:/# mfa train -j `nproc` --clean --config_path /mnt/MFA_CONFIG /mnt/yoruba/data /mnt/yoruba/dict.txt /mnt/yoruba/data/mfa-output
INFO - Setting up corpus information...
INFO - Number of speakers in corpus: 1189, average number of utterances per speaker: 1.0
INFO - Setting up training data...
INFO - Generating base features (mfcc)...
INFO - Calculating CMVN...
INFO - Initializing training for monophone...
WARNING - Subset specified is larger than the dataset, using full corpus for this training block.
INFO - Initialization complete!

# At this point, alignment will take a while,
# so you might want to detach from the docker container 
# with `Ctrl-P followed by Ctrl-Q`

```

### Extract best alignments (with silence on both sides)

```
./grep-verse-from-textgrid.sh
```

### Split verses into chunks

```
./split-audio.sh
```
