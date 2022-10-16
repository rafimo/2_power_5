name := "spark"

version := "0.1"

scalaVersion := "2.12.8"
val sparkVersion = "3.2.2"

libraryDependencies += "org.apache.spark" %% "spark-core" % sparkVersion
libraryDependencies += "org.apache.spark" %% "spark-sql" % sparkVersion
libraryDependencies += "com.softwaremill.sttp.client3" %% "core" % "3.8.2"
libraryDependencies += "com.lihaoyi" %% "os-lib" % "0.8.1"

