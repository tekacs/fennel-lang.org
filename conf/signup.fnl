(local view (require :fennelview))

(fn parse [contents]
  (fn decode [str]
    (str:gsub "%%(%x%x)" (fn [v] (string.char (tonumber v 16)))))
  (collect [k v (contents:gmatch "([^&=]+)=([^&=]+)")]
    (values (decode (k:gsub "+" " ")) (decode (v:gsub "+" " ")))))

(fn save-contents [id contents]
  (with-open [f (io.open (.. "signups/" id ".fnl") :w)]
    (f:write (view (parse contents)))
    (f:close)))

(let [contents (io.read "*all")
      id (.. (os.time) (math.random))]
  (with-open [raw (io.open (.. "signups/" id ".raw") :w)]
    (raw:write contents))
  ;; try to parse smarter, but if we can't, at least we have the raw data
  (match (pcall save-contents id contents)
    (nil err) (with-open [elog (io.open "err.log" "w")]
                (elog:write (.. err "\n"))))
  (print "status: 301 redirect")
  (print "Location: /thanks.html\n"))

