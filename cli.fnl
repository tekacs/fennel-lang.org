;; This is for running repl.fnl without having to start a browser.

(set package.preload.js (fn [] {:global {:console {:log print}}}))

(global narrate (fn [...] (io.write "| ") (print ...)))

(local fennel (require :fennel))
(table.insert package.loaders fennel.searcher)
(local repl (require :repl))

(var coro (coroutine.create repl))
(coroutine.resume coro)

(local read (fn [] (io.write "> ") (io.read)))

((fn loop [input]
   (if (= input ":reload")
       (do (set coro (coroutine.create (fennel.dofile "repl.fnl")))
           (coroutine.resume coro)
           (loop (read)))
       input
       (do
         (coroutine.resume coro input)
         (loop (read))))) (read))
