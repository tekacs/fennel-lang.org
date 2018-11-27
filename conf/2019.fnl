(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} style
               [:title {} "FennelConf 2019"]]
              [:body {}
               [:h1 {} "FennelConf 2019"]
               [:p {} [:b {} "Location:"] "Portland, OR"]
               [:p {} [:b {} "Time:"] "March? Maybe April?"]
               [:p {} [:b {} "Topic:"] "The "
                [:a {:href "https://github.com/bakpakin/Fennel"} "Fennel"]
                " programming language."]

               [:h3 {} "See how much fun we had in: "
                [:a {:href "/2018"} "2018"]]
               [:h3 {} "Possible presentations"]
               [:ul {}
                [:li {} "The module system and how to hack reloads in it: "
                 [:a {:href "https://technomancy.us"} "Phil Hagelberg"]]]

               [:h3 {} "Tickets"]
               [:p {} "Attendance is free! Please sign up so we can plan"
                " for the event."]
               [:form {:id "signup" :action "signup.cgi" :method "post"}
                [:p {}
                 [:input {:type "hidden" :name "year" :value "2019"}]
                 [:input {:type "text" :name "name" :placeholder "name"}]
                 [:input {:type "text" :name "email" :placeholder "email"}]]
                [:p {}
                 "If you'd like to give a presentation, please write"
                 " a bit about that:"]
                [:textarea {:placeholder "talk abstract" :name "abstract"
                            :rows "6" :cols "60"}]
                [:p {}
                 [:input {:type "submit" :value "sign up"}]]]

               [:hr {}]

               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
