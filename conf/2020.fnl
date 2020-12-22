(local html (require :html))
(local style (require :conf.style))

(-> [:html {:lang "en"}
     [:head {} [:title {} "FennelConf 2020"]
      (table.unpack style)]
     [:body {}
      [:h1 {} "FennelConf 2020"]
      [:p {} [:b {} "Location:"] "Would have been Portland, OR"]
      [:p {} [:b {} "Time:"] "???"]
      [:p {} "Sorry everybody... next year!"]
      [:hr {}]
      [:p {} "The "
       [:a {:href
            "https://git.sr.ht/~technomancy/fennel/tree/main/CODE-OF-CONDUCT.md"}
        "code of conduct"] " for Fennel applies at FennelConf."]
      [:p {} [:a {:href (.. "https://git.sr.ht/~technomancy/fennel-lang.org/"
                            "tree/main/conf/2020.fnl"
                            )}
              "source"]]]]
    (html)
    (print))
