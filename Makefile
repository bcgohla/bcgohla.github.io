pandocopts = -t html5 --highlight-style=kate


all: blogentries blogindex.html index.html

blogentries: $(patsubst %.blog.md,%.blog.html,$(wildcard *.blog.md))

index.html: index.md blogindex.md 
	(cat $<;\
	 echo ;\
	 echo ;\
	 cat blogindex.md) | pandoc $(pandocopts) -s -o $@

blogindex.md: blogentries
	ls -1t *.blog.md |\
	 while read name; do\
	 sed -e 's/\(.*\).md/* [\1](\1.html)\n/' <<< $$name;\
	 done > $@

%.blog.html: %.blog.md
	pandoc $(pandocopts) -s -o $@ $< 

%.html: %.md
	pandoc $(pandocopts) -s -o $@ $< 

clean:
	rm *.html blogindex.md
 
