index.html: main.fnl sample.html ; fennel/fennel main.fnl > index.html
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

.DEFAULT_GOAL := build
HTML := tutorial.html api.html reference.html lua-primer.html index.html
LUA := generate.lua fennelview.lua

PANDOC=pandoc -H head.html -A foot.html -T "Fennel"

# TODO: upgrade to pandoc 2.0+ and add --syntax-definition fennel-syntax.xml
tutorial.html: fennel/tutorial.md ; $(PANDOC) -o $@ $^
api.html: fennel/api.md ; $(PANDOC) -o $@ $^
reference.html: fennel/reference.md ; $(PANDOC) -o $@ $^
lua-primer.html: fennel/lua-primer.md ; $(PANDOC) -o $@ $^

build: $(HTML) $(LUA)
html: $(HTML)
lua: $(LUA)
clean: ; rm -f $(HTML) $(LUA)

upload: $(HTML) $(LUA) init.lua repl.fnl fennel.css fengari-web.js .htaccess fennel
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

.PHONY: build html lua clean upload uploadv uploadconf pullsignups
