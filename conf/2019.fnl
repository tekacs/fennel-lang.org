(local html (require :html))
(local style (require :conf.style))

(-> [:html {:lang "en"}
     [:head {} [:title {} "FennelConf 2019"]
      (unpack style)]
     [:body {}
      [:h1 {} "FennelConf 2019"]
      [:p {} [:b {} "Location:"]
       [:a {:href "https://centrloffice.com/locations/oregon-portland-downtown"}
        "Centrl Office"]
       "Downtown Portland, OR"]
      [:p {} [:b {} "Time:"] "16 March 2019"]
      [:p {} [:b {} "Topic:"] "The "
       [:a {:href "https://fennel-lang.org"} "Fennel programming language"]]
      [:p {} [:b {} "Discussion:"]
       "The" [:tt {} "#fennelconf"] "IRC channel on freenode"]

      [:img {:src "2019.jpg" :width 800 :alt "Fennel Conf 2019"}]

      [:h3 {} "Schedule"]
      [:ul {}
       [:li {} [:b {} "9:00"] "Meet up at"
        [:a {:href "https://www.heartroasters.com/pages/locations"}
         "Heart Coffee westside"] "before the conference, if you like."]
       [:li {} [:b {} "10:00"]
        [:i {} "Making a functional HTTP server with Fennel:"]
        [:a {:href "https://bakpakin.com/"} "Calvin Rose"]]
       [:li {} [:b {} "11:00"]
        [:i {} "Art is failure over time:"]
        "Justin Smith"
        "[" [:a {:href "/v/fennelconf-2019-smith.mp4"} "video"] "]"]
       [:li {} [:b {} "12:00"] "Lunch"]
       [:li {} [:b {} "13:00"]
        [:i {} "Full Stack Fennel; or, Overengineering as an Art Form:"]
        [:a {:href "https://benaiah.me/about"} "Benaiah Mischenko"]
        "[" [:a {:href "/v/fennelconf-2019-mischenko.mp4"} "video"] "]"]
       [:li {} [:b {} "14:00"]
        [:i {} "Interactive development in 80kb of RAM:"]
        [:a {:href "https://technomancy.us/colophon"} "Phil Hagelberg"]
        "[" [:a {:href "/v/fennelconf-2019-hagelberg.mp4"} "video"] "]"]
       [:li {} [:b {} "13:00"] "Hack afternoon!"]
       [:li {} [:b {} "18:00"] "End of conference"]]

      [:hr {}]
      [:h3 {} "See how much fun we had in: " [:a {:href "/2018"} "2018"]]

      [:p {} [:a {:href (.. "https://github.com/technomancy/"
                            "fennel-lang.org/tree/master/conf")}
              "source"]]]]
    (html)
    (print))
