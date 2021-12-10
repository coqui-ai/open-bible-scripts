# utility script for cleaning bible text from biblica for use with montreal-forced-aligner
1;95;0c
1. run the main script `run.sh` (e.g. `./run.sh hausa ha`)
4. generate alignments with `MFA` (with `mfa train`)
5. use `grep-verse-from-textgrid.sh` to get best alignments (i.e. with silence on both sides)
6. use `split-audio.sh` to cut audio into verse-sized chunks
