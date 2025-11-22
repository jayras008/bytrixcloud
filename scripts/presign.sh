#!/bin/bash
echo "Masukkan bucket:"; read bucket
echo "Masukkan file:"; read file
echo "Expire (contoh: 7d):"; read exp
mc share download mycloud/$bucket/$file --expire ${exp:-7d}
mc share upload mycloud/$bucket/$file --expire ${exp:-7d}
