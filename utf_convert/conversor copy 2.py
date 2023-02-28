
import chardet

tmpfile = "C:/Users/re92950z/Desktop/utf_convert/zt004_20221108_114120.txt"
tmpfile1 = "C:/Users/re92950z/Desktop/utf_convert/ansi.txt"

with open(tmpfile, 'rb') as sourceFile:
    content_bytes = sourceFile.read()
    detected = chardet.detect(content_bytes)
    encoding = detected['encoding']
    print(f"{tmpfile}: detected as encode: {encoding}.")


infile = open(tmpfile, 'rb')
outfile = open(tmpfile1, 'wb')
BLOCKSIZE = 1048576 # experiment with size
while True:
    block = infile.read(BLOCKSIZE)
    if not block: break
    outfile.write(block.decode('latin1').encode('utf8'))
infile.close()
outfile.close()