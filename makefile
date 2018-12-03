index.html: main.fnl sample.html ; fennel/fennel main.fnl > index.html
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

HTML := tutorial.html api.html reference.html lua-primer.html index.html

# TODO: upgrade to pandoc 2.0+ and add --syntax-definition fennel-syntax.xml
tutorial.html: fennel/tutorial.md ; pandoc -H head.html -A foot.html -o $@ $^
api.html: fennel/api.md ; pandoc -H head.html -A foot.html -o $@ $^
reference.html: fennel/reference.md ; pandoc -H head.html -A foot.html -o $@ $^
lua-primer.html: fennel/lua-primer.md ; pandoc -H head.html -A foot.html -o $@ $^

html: $(HTML)
clean: ; rm $(HTML)

upload: $(HTML) init.lua repl.fnl fennel.css fengari-web.js .htaccess \
		fennel/fennel.lua fennel/test.lua fennel/test-macros.fnl \
		fennelview.lua generate.lua
	rsync $^ fenneler@fennel-lang.org:fennel-lang.org/

conf/2018.html: conf/2018.fnl ; fennel/fennel $^ > $@
conf/2019.html: conf/2019.fnl ; fennel/fennel $^ > $@
conf/thanks.html: conf/thanks.fnl ; fennel/fennel $^ > $@
conf/signup.cgi: conf/signup.fnl
	echo "#!/usr/bin/env lua" > $@
	fennel/fennel --compile $^ >> $@
	chmod 755 $@

uploadconf: conf/2019.html conf/2018.html conf/thanks.html conf/.htaccess \
			fennelview.lua conf/signup.cgi
	rsync $^ fenneler@fennel-lang.org:conf.fennel-lang.org/

pullsignups:
	rsync -rv fenneler@fennel-lang.org:conf.fennel-lang.org/signups/*fnl signups/
