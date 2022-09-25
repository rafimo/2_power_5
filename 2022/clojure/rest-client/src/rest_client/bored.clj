"run using lein"
"prints out an activity to do when bored"
"cerner_2tothe5th_2022"
(ns rest-client.bored
  (:gen-class)
  (:require [clj-http.client :as client])
  )

(defn -main
  "the main method"
  [& args]
  (println (:activity (:body (client/get "https://www.boredapi.com/api/activity" {:as :json})))))
