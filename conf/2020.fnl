(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} style
               [:title {} "FennelConf 2020"]]
              [:body {}
               [:h1 {} "FennelConf 2020"]
               [:p {} [:b {} "Location:"] "Portland, OR, probably?"]
               [:p {} [:b {} "Time:"] "???"]
               [:p {} "Geez, hold your horses. Let us finish 2019 first."]
               [:hr {}]
               [:p {} "See the page for the" [:a {:href "/2019"} "2019"]
                " conference."]
               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
