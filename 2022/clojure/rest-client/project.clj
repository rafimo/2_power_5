(defproject rest-client "0.1.0-SNAPSHOT"
  :description "Print out an activity to do when bored"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.1"]
    [clj-http "3.12.3"]
    [cheshire "5.11.0"]
    ]
  :main ^:skip-aot rest-client.bored
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
