;; A *very* basic HTML generation library.
;; No escaping features; never use this on user input!

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

(fn html [doc]
  (if (= (type doc) "string")
      doc
      (let [[tag-name attrs & body] doc]
        (.. (tag tag-name attrs)
            (table.concat (map html body) " ")
            "</" tag-name ">"))))
