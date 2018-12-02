(local html (require :html))
(local style (require :conf.style))

(-> [:html {:lang "en"}
     [:head {} style
      [:title {} "FennelConf 2019"]]
     [:body {}
      [:h1 {} "FennelConf 2019"]
      [:p {} [:b {} "Location:"] "Portland, OR"]
      [:p {} [:b {} "Time:"] "16 March 2019"]
      [:p {} [:b {} "Topic:"] "The "
       [:a {:href "https://github.com/bakpakin/Fennel"} "Fennel"]
       " programming language."]

      [:h3 {} "Possible presentations"]
      [:ul {}
       [:li {} "The module system and how to hack reloads in it: "
        [:a {:href "https://technomancy.us"} "Phil Hagelberg"]]
       [:li {} "Using fennel as a glue in systems programming: "
        "Justin Smith"]
       [:li {} "Generating a cyberpunk story using Fennel, Love2D and graphs: "
        "Andrew Owen"]
       ]

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

      [:h3 {} "See how much fun we had in: " [:a {:href "/2018"} "2018"]]
      [:hr {}]

      [:p {} [:a {:href (.. "https://github.com/technomancy/"
                            "fennel-lang.org/tree/master/conf")}
              "source"]]]]
    (html)
    (print))
