(local html (require :html))
(local style (require :conf.style))

(-> [:html {:lang "en"}
     [:head {} [:title {} "FennelConf 2020"]
      (table.unpack style)]
     [:body {}
      [:h1 {} "FennelConf 2020"]
      [:p {} [:b {} "Location: online"]]
      [:p {} [:b {} "Time:"] "2021-01-02T22:00:00Z (Saturday @ 14:00 US Pacific)"]
      [:p {} "This year FennelConf was an online session of show-and-tell."]
      [:h3 {} "Schedule"]
      [:ul {}
       [:li {} "Jeremy Penner - Interactively Programming the Apple ][ "
        "With HoneyLisp"
        "[" [:a {:href "/v/fennelconf-2020-spindleyq.mp4"} "video"] "]"]
       [:li {} "Andrey Orst - Bringing Clojure's seq-mantics into Fennel with Cljlib"
        "[" [:a {:href "/v/fennelconf-2020-andreyorst.mp4"} "video"] "]"]
       [:li {} "Phil Hagelberg -  Structural editing"
        "[" [:a {:href "/v/fennelconf-2020-technomancy.mp4"} "video"] "]"]
       [:li {} "Ramsey Nasser -  making some noise: integrating Fennel "
        "into the renoise digital audio workstation"
        "[" [:a {:href "/v/fennelconf-2020-nasser.mp4"} "video"] "]"]
       [:li {} "Jesse Wertheim - Working the internals - metadata manipulation "
        "and AST serialization"
        "[" [:a {:href "/v/fennelconf-2020-jaawerth.mp4"} "video"] "]"]
       [:li {} "Dan Kurtz - Fireverk"
        "[" [:a {:href "/v/fennelconf-2020-kurtz.mp4"} "video"] "]"]
       [:li {} "Will Sinatra - toAPK -a fennel"
        "[" [:a {:href "/v/fennelconf-2020-wsinatra.mp4"} "video"] "]"]]
      [:p {} "Yes, FennelConf 2020 will take place in 2021."]
      [:hr {}]
      [:h3 {} "See how much fun we had in: "
       [:a {:href "/2018"} "2018"]
       [:a {:href "/2019"} "2019"]]
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
