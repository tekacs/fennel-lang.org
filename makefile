index.html: main.fnl sample.html ; fennel/fennel main.fnl > index.html
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

conf/2018.html: conf/2018.fnl ; fennel/fennel --searcher $^ > $@

upload: index.html init.lua repl.fnl fennel.css fengari-web.js .htaccess \
		fennel/fennel.lua fennel/test.lua fennel/test-macros.fnl \
		fennelview.lua generate.lua
	rsync $^ fenneler@fennel-lang.org:fennel-lang.org/

uploadconf: conf/2018.html conf/.htaccess
	rsync $^ fenneler@fennel-lang.org:conf.fennel-lang.org/
