ppt:
  pandoc slides.md --highlight-style=tango -o slides.pptx

clean:
  rm -f slides.pptx
