(local view (require :fennelview))

(fn parse [contents]
  (fn decode [str]
    (: str :gsub "%%(%x%x)" (fn [v] (string.char (tonumber v 16)))))
  (let [params {}]
    (each [k v (: contents :gmatch "([^&=]+)=([^&=]+)")]
      (tset params
            (decode (: k :gsub "+" " "))
            (decode (: v :gsub "+" " "))))
    params))

(fn save-contents [id contents]
  (let [f (io.open (.. "signups/" id ".fnl") :w)]
    (: f :write (view (parse contents)))
    (: f :close)))

(let [contents (io.read "*all")
      id (.. (os.time) (math.random))
      fraw (io.open (.. "signups/" id ".raw") :w)]
  (: fraw :write contents)
  (: fraw :close)
  ;; try to parse smarter, but if we can't, at least we have the raw data
  (let [(ok err) (pcall save-contents id contents)]
    (when (not ok)
      (doto (io.open "err.log" "w")
        (: :write err)
        (: :close))))
  (print "status: 301 redirect")
  (print "Location: /thanks.html\n"))

