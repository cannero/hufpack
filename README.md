# Huffman en-/decoding
https://codingchallenges.fyi/challenges/challenge-huffman/

Run with
```shell
swift run huffer serialize --read-file ..\sample.txt --write-file ../testfile.bin
swift run huffer deserialize --read-file ..\testfile.bin --write-file ../new.out
```

## Performance
Reading 1000 chars takes about 0.5 to 1 second.

## Remarks
- There is a problem if everything is in a huffer folder

# todo
- check https://stackoverflow.com/questions/56533917/how-do-i-write-huffman-encoded-characters-to-a-file
