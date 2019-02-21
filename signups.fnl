(local fennel (require :fennel))
(local view (require :fennelview))
(local lfs (require :lfs))

(each [filename (lfs.dir "signups")]
  (when (= :file (. (lfs.attributes (.. :signups/ filename)) :mode))
    (let [{:name name :email email :abstract abstract :confirmed confirmed}
         (fennel.dofile (.. "signups/" filename))
          name (.. name (: " " :rep (math.max 0 (- 8 (# name)))))]
      (print name email (if (and abstract (. arg 1)) abstract "")
             (if confirmed :confirmed (= confirmed false) :no)))))
