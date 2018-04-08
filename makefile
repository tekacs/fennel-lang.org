index.html: main.fnl ; fennel/fennel main.fnl > index.html
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

upload: index.html init.lua repl.fnl fennel.css fengari-web.js .htaccess \
		fennel/fennel.lua fennel/test.lua fennel/test-macros.fnl \
		fennelview.lua generate.lua
	rsync $^ fenneler@fennel-lang.org:fennel-lang.org/
