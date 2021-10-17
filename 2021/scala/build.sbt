name := "spark"

version := "0.1"

scalaVersion := "2.12.8"
val sparkVersion = "3.1.2"

libraryDependencies += "org.apache.spark" %% "spark-core" % sparkVersion
libraryDependencies += "org.apache.spark" %% "spark-sql" % sparkVersion
