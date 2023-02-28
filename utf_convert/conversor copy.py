import codecs
import glob
import chardet

ALL_FILES = glob.glob('*.txt')

def encoding_function():
    """Check encoding and convert to UTF-8, if encoding no UTF-8."""
    for filename in ALL_FILES:
      with open(filename, 'rb') as sourceFile:   
        content_bytes = sourceFile.read()
        detected = chardet.detect(content_bytes)
        encoding = detected['encoding']
        print(f"{filename}: detected as encode: {encoding}.")
        exit(0)
        sourceFile.close()
        if encoding != 'utf-8':
          with open(filename,"w",encoding="UTF-8") as targetFile:
            while True:
              content_text = content_bytes.decode(encoding)
              if not content_text:
                break
              targetFile.write(content_text)
              print(f"{filename}: converted to: UTF-8.")            
              break
        else:
          print(f"{filename}: detected as encode: {encoding}.")


encoding_function()