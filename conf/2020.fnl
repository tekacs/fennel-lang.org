(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} [:title {} "FennelConf 2020"]
               (unpack style)]
              [:body {}
               [:h1 {} "FennelConf 2020"]
               [:p {} [:b {} "Location:"] "Portland, OR, probably?"]
               [:p {} [:b {} "Time:"] "???"]
               [:p {} "Geez, hold your horses. Let us finish "
                [:a {:href "/2019"} "2019"] " first."]
               [:hr {}]
               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
