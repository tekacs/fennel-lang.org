;; A *very* basic HTML generation library.
;; Basic escaping features only; never use this on user input!

(local map (fn [f tbl]
             (let [out {}]
               (each [i v (ipairs tbl)]
                 (tset out i (f v)))
               out)))

(local map-kv (fn [f tbl]
                (let [out {}]
                  (each [k v (pairs tbl)]
                    (table.insert out (f k v)))
                  out)))

(local to-attr (fn [k v]
                 (if (= v true) k
                     (.. k "=\"" v"\""))))

(local tag (fn [tag-name attrs]
             (assert (= (type attrs) "table") "Missing attrs table")
             (let [attr-str (table.concat (map-kv to-attr attrs) " ")]
               (.. "<" tag-name " " attr-str">"))))

(local entity-replacements {"&" "&amp;" ; must be first!
                            "<" "&lt;"
                            ">" "&gt;"
                            '"' "&quot;"})

(local entity-search (let [result []]
                       (each [k _ (pairs entity-replacements)]
                             (table.insert result k))
                       (.. "[" (table.concat result "") "]")))

(local escape (fn [s]
                  (assert (= (type s) "string"))
                  (: s :gsub entity-search entity-replacements)))

(fn html [doc]
  (if (= (type doc) "string")
      (escape doc)
      (= (. doc 1) :NO-ESCAPE)
      (. doc 2)
      (let [[tag-name attrs & body] doc]
        (.. (tag tag-name attrs)
            (table.concat (map html body) " ")
            "</" tag-name ">"))))
