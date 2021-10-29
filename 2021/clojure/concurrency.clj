;; futures in clojure cerner_2tothe5th_2021
(do
    (future
        (Thread/sleep 3000)
        (println "spawned thread"))
    (println "main program"))
