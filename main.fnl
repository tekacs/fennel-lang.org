;; static HTML generator for the page
(local fennel (require "fennel"))
(table.insert package.loaders fennel.searcher)
(local html (require "html"))

(local repo-link (fn [text path]
                   [:a {:href (.. "https://github.com/bakpakin/Fennel/"
                                  "tree/master/" path)} text]))

(print "<!DOCTYPE html>")
(print (html [:html {:lang "en"}
              [:head {}
               [:meta {:charset "UTF-8"}]
               [:script {:src "fengari-web.js"}]
               [:script {:type "application/lua" :src "init.lua" :async true}]
               [:link {:rel "stylesheet" :href "fennel.css"}]
               [:link {:rel "stylesheet"
                       :href "https://code.cdn.mozilla.net/fonts/fira.css"}]
               [:title {} "the Fennel programming language"]]
              [:body {}
               [:h1 {} "Fennel"]
               [:p {} "Fennel is a programming language that brings together "
                "the speed, simplicity, and reach of"
                [:a {:href "https://www.lua.org"} "Lua"]
                " with the flexibility of a "
                [:a {:href (.. "https://en.wikipedia.org/wiki/"
                               "Lisp_(programming_language)")}
                 "lisp syntax and macro system."]]

               [:ul {}
                [:li {} [:b {} "Full Lua compatibilty:"] "Easily call any Lua "
                 "function from Fennel and vice-versa."]
                [:li {} [:b {} "Zero overhead:"] "Compiled code should be fast,"
                 " standalone, and just as or more efficient than hand-written"
                 " Lua."]
                [:li {} [:b {} "Compile-time macros:"]
                 "Macros exist only at compile time"
                 " and are not included in the output code."]
                [:li {} [:b {} "Embeddable:"] "Fennel is a library as well as "
                 "an executable. Embed it in other programs to support runtime "
                 "extendability and interactive development."]]

               [:p {} "Anywhere you can run Lua code, you can run Fennel code."]

               [:ul {:id "where"}
                [:li {} [:a {:href "https://luacraft.com/"} "video"]
                 [:a {:href "https://love2d.org"} "games"]]
                [:li {} [:a {:href "https://awesomewm.org/"} "window managers"]]
                [:li {} [:a {:href "https://openresty.org/en/"} "web servers"]]
                [:li {} [:a {:href "https://redis.io/commands/eval"} "databases"]]
                [:li {} [:a {:href "https://fengari.io"} "web browsers"]]
                [:li {} [:a {:href "http://www.nodemcu.com/index_en.html"}
                         "$4 microcontrollers"]]]

               [:h2 {} "Usage"]

               [:p {} "Install with"
                [:a {:href "https://luarocks.org"} "Luarocks"]
                "or grab the Fennel repository and run it from there:"]

               [:pre {}
                [:kbd {} (.. "    $ git clone https://github.com/bakpakin/Fennel"
                             " && cd Fennel"
                             "\n    $ ./fennel --compile code.fnl > code.lua"
                             "\n    $ ./fennel --repl")]]

               [:h3 {} "That's too much work!"]
               [:p {} "Fine, you can use Fennel right here without installing"
                " anything:"]

               [:div {:class "repl"}
                [:code {:id "fengari-console"}]
                [:div {:class "fengari-input-container"}
                 [:label {:id "fengari-prompt" :for "fengari-input"} "> "]
                 [:textarea {:class "lua" :id "fengari-input" :rows 1
                             :placeholder "Type code here..."}]]]

               [:h2 {} "Documentation"]
               [:ul {}
                [:li {} "Get started with"
                 (repo-link "the Tutorial." "tutorial.md")]
                [:li {} "The" (repo-link "Lua primer" "lua-primer.md")
                 "will catch you up on useful concepts in the Lua language "
                 "if you don't already know it."]
                [:li {} "The" (repo-link "Reference" "reference.md") "lists "
                 "out all built-in special forms and what they're for."]
                [:li {} "The" (repo-link "API listing" "api.md")
                 "explains how to embed Fennel into a Lua program."]]

               [:h2 {} "Development"]
               [:p {} "Fennel uses"
                [:a {:href "https://github.com/bakpakin/Fennel"} "GitHub"]
                "for development;"
                [:a {:href "https://github.com/bakpakin/Fennel/issues"}
                 "bug reports and feature requests"] "are tracked in the "
                "issue system there."]
               [:p {} "Most discussion of Fennel happens on"
                [:a {:href "https://webchat.freenode.net/"} "the #fennel"
                 " channel on Freenode."]]
               [:p {} "There is also"
                [:a {:href "https://github.com/bakpakin/Fennel/wiki"} "a wiki"]
                " for collecting ideas."]

               [:hr {}]
               [:p {} "Fennel is copyright &copy; 2016-2018 Calvin Rose and "
                [:a {:href "https://github.com/bakpakin/Fennel/graphs/contributors"}
                 "contributors."] "released under the MIT license. "
                "This website is under the same terms and also developed on"
                [:a {:href "https://github.com/technomancy/fennel-lang.org"}
                 "GitHub."]]]]))
