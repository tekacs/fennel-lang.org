(local html (require :html))
(local style (require :conf.style))

(print (html [:html {:lang "en"}
              [:head {} style
               [:title {} "FennelConf 2018"]]
              [:body {}
               [:h1 {} "FennelConf 2018"]
               [:p {} [:b {} "Location:"] "Hawthorne Lucky Lab, Portland, OR"]
               [:p {} [:b {} "Time:"] "2018-03-23 19:00:00-23:30"]
               [:p {} [:b {} "Topic:"] "The "
                [:a {:href "https://github.com/bakpakin/Fennel"} "Fennel"]
                " programming language."]
               [:p {} [:b {} "Project:"] "Implement proof-of-concept HTML"
                "output library, used to produce this page."]
               [:img {:src (.. "https://farm1.staticflickr.com/"
                               "803/40939667552_571e2667ee_k.jpg")
                      :width 640 :alt "Fennel Conf 2018"}]
               [:p {} "See the page for the" [:a {:href "/2019"} "2019"]
                " conference."]
               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
