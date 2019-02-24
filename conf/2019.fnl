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
       [:a {:href "https://fennel-lang.org"} "Fennel programming language."]]

      [:hr {}]
      [:h3 {} "Schedule"]
      [:ul {}
       [:li {} [:b {} "8:30"] "Meet up at"
        [:a {:href "https://www.heartroasters.com/pages/locations"}
         "Heart Coffee westside"] "before the conference."]
       [:li {} [:b {} "9:00"] "Riding the coat-tails of Lua integration:"
        "Jesse Wertheim"]
       [:li {} [:b {} "9:50"] "Making a functional HTTP server with Fennel: "
        [:a {:href "https://bakpakin.com/"} "Calvin Rose"]]
       [:li {} [:b {} "10:40"] "Coffee/snack Break"]
       [:li {} [:b {} "11:10"] "Using fennel as a glue in systems programming: "
        "Justin Smith"]
       [:li {} [:b {} "12:00"] "Lunch"]
       [:li {} [:b {} "13:00"]
        "Full Stack Fennel; or, Overengineering as an Art Form: "
        [:a {:href "https://benaiah.me/about"} "Benaiah Mischenko"]]
       [:li {} [:b {} "13:50"] "Interactive development in 80kb of RAM: "
        [:a {:href "https://technomancy.us/colophon"} "Phil Hagelberg"]]
       [:li {} [:b {} "14:40-17:00"] "Hack afternoon!"]
       ]

      ;; [:h3 {} "Tickets"]
      ;; [:p {} "Attendance is free! Please sign up so we can plan"
      ;;  " for the event."]
      ;; [:form {:id "signup" :action "signup.cgi" :method "post"}
      ;;  [:p {}
      ;;   [:input {:type "hidden" :name "year" :value "2019"}]
      ;;   [:input {:type "text" :name "name" :placeholder "name"}]
      ;;   [:input {:type "text" :name "email" :placeholder "email"}]]
      ;;  [:p {}
      ;;   "If you'd like to give a presentation, please write"
      ;;   " a bit about that:"]
      ;;  [:textarea {:placeholder "talk abstract" :name "abstract"
      ;;              :rows "6" :cols "60"}]
      ;;  [:p {}
      ;;   [:input {:type "submit" :value "sign up"}]]]

      [:hr {}]
      [:h3 {} "See how much fun we had in: " [:a {:href "/2018"} "2018"]]

      [:p {} [:a {:href (.. "https://github.com/technomancy/"
                            "fennel-lang.org/tree/master/conf")}
              "source"]]]]
    (html)
    (print))
