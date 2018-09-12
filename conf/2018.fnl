(local html (require :html))

(print (html [:html {:lang "en"}
              [:head {}
               [:style {:type "text/css"}
                "body{margin:40px auto;max-width:650px;line-height:1.6;"
                "font-size:18px;color:#444;padding:0 10px}"
                "h1,h2,h3{line-height:1.2}"]
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
               [:p {} [:a {:href (.. "https://github.com/technomancy/"
                                     "fennel-lang.org/tree/master/conf")}
                       "source"]]]]))
