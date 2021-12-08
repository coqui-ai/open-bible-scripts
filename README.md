# utility script for cleaning bible text from biblica for use with montreal-forced-aligner

1. clean all bible text with `clean.sh`
2. make `dict.txt` with `make-dict.sh`
3. use `parallelize.sh` to make more parallel MFA processing
4. generate alignments with `MFA`
5. use `grep-verse-from-textgrid.sh` to get best alignments (i.e. with silence on both sides)
6. use `split-audio.sh` to cut audio into verse-sized chunks