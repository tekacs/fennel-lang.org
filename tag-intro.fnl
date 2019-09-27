(let [version (: (. arg 1) :gsub "/.*" "")] 
  (print (.. "---\n"
             "pagetitle: Documentation for " version "\n"
             "---\n"
             "\n"
             "[Fennel](/) documentation for " version "\n"
             "=========================================\n")))
