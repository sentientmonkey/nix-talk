code_style := "tokyo-night-storm.theme"

pdf: revealjs
  ./node_modules/puppeteer-cli/index.js print index.html slides.pdf \
    --print-background \
    --landscape \
    --margin-top 0in \
    --margin-bottom 0in \
    --margin-left 0in \
    --margin-right 0in

images:
  magick -size 500x500 \
    -density 1200 \
    -background transparent \
    img/nix-snowflake-rainbow.svg \
    img/nix-snowflake-rainbow.png

revealjs:
  pandoc -t revealjs -s -o index.html slides.md \
    -V revealjs-url=https://unpkg.com/reveal.js \
    --include-in-header=header.html \
    -V theme=moon \
    --highlight-style={{code_style}}
  echo "Slides generated at index.html"

watch:
  just revealjs && \
  fswatch -o slides.md header.html img/*.svg \
    | xargs -I{}  just revealjs

serve: revealjs
  http-server -p 8000

clean:
  rm -f slides.pdf index.html img/*.png
