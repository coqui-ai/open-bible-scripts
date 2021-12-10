# utility script for cleaning bible text from biblica for use with montreal-forced-aligner

0. clone this repo

```
$ git clone https://github.com/coqui-ai/open-bible-scripts.git
```

1. run the main script `run.sh`

```
$ cd open-bible-scripts
open-bible-scripts$ ./run.sh yoruba yo
```

4. generate alignments with [`mfa train`](https://montreal-forced-aligner.readthedocs.io/en/latest/user_guide/workflows/train_acoustic_model.html)

```
$ docker run -it --mount "type=bind,src=/home/ubuntu/open-bible-scripts,dst=/mnt" mmcauliffe/montreal-forced-aligner
(base) root@d8095c794d5f:/# conda activate aligner
(aligner) root@d8095c794d5f:/# mfa train --config_path /mnt/MFA_CONFIG /mnt/yoruba/data /mnt/yoruba/dict.txt /mnt/yoruba/data/mfa-output
```

5. use `grep-verse-from-textgrid.sh` to get best alignments (i.e. with silence on both sides)
6. use `split-audio.sh` to cut audio into verse-sized chunks
