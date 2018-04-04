index.html: main.fnl ; fennel/fennel main.fnl > index.html
fennel.lua: fennel/fennel.lua ; cp $^ $@
test.lua: fennel/test.lua ; cp $^ $@
fennelview.lua: fennel/fennelview.fnl ; fennel/fennel --compile $^ > $@
generate.lua: fennel/generate.fnl ; fennel/fennel --compile $^ > $@

upload: index.html repl.lua fennel.lua fennelview.lua generate.lua fennel.css fengari-web.js .htaccess
	rsync $^ fenneler@fennel-lang.org:fennel-lang.org/
