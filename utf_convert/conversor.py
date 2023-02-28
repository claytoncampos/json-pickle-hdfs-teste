import codecs

blockSize = 1048576
with codecs.open("C:/Users/re92950z/Desktop/ansi.txt","r",encoding="mbcs") as sourceFile:
  with codecs.open("C:/Users/re92950z/Desktop/utf.txt","w",encoding="UTF-8") as targetFile:
    while True:
        contents = sourceFile.read(blockSize)
        if not contents:
            break
        targetFile.write(contents)

