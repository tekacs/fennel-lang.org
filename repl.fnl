(partial fennel.repl {:readChunk (fn []
                                   (let [input (coroutine.yield)]
                                     (print (.. "> " input))
                                     (.. input "\n")))
                      :onValues (fn [xs] (print (table.concat xs "\t")))
                      :onError (fn [err x] (: js.global.console :log err x))})
