(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} style
               [:title {} "FennelConf Signup"]]
              [:body {}
               [:h1 {} "FennelConf Signup"]
               [:h3 {} "Thanks!"]
               [:p {} "We'll be contacting you with more details."]
               [:p {} "Feel free to join" [:tt {} "#fennel"]
                "on Freenode to discuss further."]]]))
