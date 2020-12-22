(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} [:title {} "FennelConf 2018"]
               (table.unpack style)]
              [:body {}
               [:h1 {} "FennelConf 2018"]
               [:p {} [:b {} "Location:"] "Hawthorne Lucky Lab, Portland, OR"]
               [:p {} [:b {} "Time:"] "2018-03-23 19:00-23:30"]
               [:p {} [:b {} "Topic:"] "The "
                [:a {:href "https://github.com/bakpakin/Fennel"} "Fennel"]
                " programming language."]
               [:p {} [:b {} "Project:"] "Implement proof-of-concept HTML"
                "output library, used to produce this page."]
               [:img {:src "2018.jpg" :width 800 :alt "Fennel Conf 2018"}]
               [:p {} "See the page for the" [:a {:href "/2019"} "2019"]
                " conference."]
               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
