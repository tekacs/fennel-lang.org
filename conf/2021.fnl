(local html (require :html))
(local style (require :conf.style))

(-> [:html {:lang "en"}
     [:head {} [:title {} "FennelConf 2021"]
      (table.unpack style)]
     [:body {}
      [:h1 {} "FennelConf 2021"]
      [:p {} [:b {} "Location:"] "Portland, OR"]
      [:p {} [:b {} "Time:"] "???"]
      [:p {} "Hopefully in late summer, if the vaccine is widespread enough "
       "for it to be safe."]
      [:hr {}]
      [:p {} "The "
       [:a {:href
            "https://git.sr.ht/~technomancy/fennel/tree/main/CODE-OF-CONDUCT.md"}
        "code of conduct"] " for Fennel applies at FennelConf."]
      [:p {} [:a {:href (.. "https://git.sr.ht/~technomancy/fennel-lang.org/"
                            "tree/main/conf/2021.fnl"
                            )}
              "source"]]]]
    (html)
    (print))
