ppt:
  pandoc slides.md --highlight-style=tango -o slides.pptx

pdf:
  pandoc slides.md --highlight-style=tango -t beamer -o slides.pdf

images:
  magick -size 500x500 \
    -density 1200 \
    -background transparent \
    img/nix-snowflake-rainbow.svg \
    img/nix-snowflake-rainbow.png

revealjs:
  pandoc -t revealjs -s -o index.html slides.md \
    -V revealjs-url=https://unpkg.com/reveal.js \
    --include-in-header=slides.css \
    -V theme=solarized
  echo "Slides generated at index.html"

watch:
  fswatch -o slides.md slides.css img/*.svg \
    | xargs -I{}  just revealjs

serve: revealjs
  http-server -p 8000

clean:
  rm -f slides.pptx slides.pdf index.html img/*.png
