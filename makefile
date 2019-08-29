index.html: main.fnl sample.html ; fennel/fennel main.fnl > index.html
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

.DEFAULT_GOAL := build
HTML := tutorial.html api.html reference.html lua-primer.html changelog.html index.html
LUA := generate.lua fennelview.lua

# TODO: upgrade to pandoc 2.0+ and add --syntax-definition fennel-syntax.xml
PANDOC=pandoc -H head.html -A foot.html -T "Fennel"

%.html: fennel/%.md ; $(PANDOC) -o $@ $^

TAGS := 0.1.0 0.1.1 0.2.0 0.2.1
fennel/v%: ; git clone --branch $* fennel $@
fennel/master: ; git clone --branch master fennel $@
tags: $(addprefix fennel/v,$(TAGS)) ; $(foreach tag, $(TAGS), mkdir -p v${tag})

# TODO: this expands to master/tutorial.html, but for some reason it doesn't match
# the %.html rule we defined above??
TAGDOCS := $(foreach tag, $(TAGS), $(addprefix v${tag}-, $(HTML))) \
	$(addprefix master/, $(HTML))

build: $(HTML) $(LUA)
html: $(HTML)
tagdocs: tags $(TAGDOCS)
lua: $(LUA)
clean: ; rm -f $(HTML) $(LUA)

upload: $(HTML) $(LUA) $(TAGDOCS) init.lua repl.fnl fennel.css fengari-web.js .htaccess fennel
	rsync -r $^ fenneler@fennel-lang.org:fennel-lang.org/

conf/%.html: conf/%.fnl ; fennel/fennel $^ > $@

conf/thanks.html: conf/thanks.fnl ; fennel/fennel $^ > $@
conf/signup.cgi: conf/signup.fnl
	echo "#!/usr/bin/env lua" > $@
	fennel/fennel --compile $^ >> $@
	chmod 755 $@

uploadconf: conf/*.html conf/*.jpg conf/.htaccess fennelview.lua conf/signup.cgi
	rsync $^ fenneler@fennel-lang.org:conf.fennel-lang.org/

uploadv: conf/v
	rsync -r $^ fenneler@fennel-lang.org:conf.fennel-lang.org/

pullsignups:
	ls signups/ | wc -l
	rsync -rv fenneler@fennel-lang.org:conf.fennel-lang.org/signups/*fnl signups/
	ls signups/ | wc -l
	fennel signups.fnl

.PHONY: build html tags tagdocs lua clean upload uploadv uploadconf pullsignups
