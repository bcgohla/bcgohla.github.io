pandocopts = -t html5 -S -c pandoc.css -s
blogentries = $(patsubst %.blog.md,%.blog.html,$(wildcard *.blog.md))

all: index.html $(blogentries)

index.html: index.md blogindex.md
	(cat $<;\
	 echo ;\
	 echo ;\
	 cat blogindex.md) | pandoc $(pandocopts) -s -o $@

blogindex.md: $(blogentries)
	ls -1t *.blog.md |\
	 while read name; do\
	 sed -e 's/\(.*\).md/* [\1](\1.html)\n/' <<< $$name;\
	 done > $@

%.blog.html: %.blog.md
	pandoc $(pandocopts) -o $@ $< 

clean:
	rm *.html blogindex.md

