// simple analysis of submissions using spark-sql - cerner_2tothe5th_2021
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions.{array, countDistinct, explode, substring_index}

object SubmissionAnalysis {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder.appName("2^5 Submission Analysis") // name things!
      .config("spark.master", "local") // run locally
      .config("spark.eventLog.enabled", value = false) // don't log spark events
      .getOrCreate()

    // results.json is ignored in this commit - if necessary invoke below and save as results.json
    // https://api.github.com/search/code searching for the contest identifier
    // could fetch this dynamically also from above API
    val dataframe = spark.read.option("multiline", "true").json("results.json")

    import spark.implicits._
    val dataset = dataframe.withColumn("items", explode($"items")).withColumn("file_name", $"items"("name"))
      .withColumn("repository", explode(array($"items"("repository")))) // explode repository model
      .withColumn("owner", explode(array($"repository"("owner")))) // explode owner model
      .withColumn("login", $"owner"("login"))
      .withColumn("extension", substring_index($"file_name", ".", -1)) // guess the language by extension
      .filter("file_name != 'README.md'") // ignore readme files
      .drop("incomplete_results", "total_count", "items", "repository", "owner") // prune the dataset of unnecessary columns

    // dataset.createOrReplaceTempView("results") - use this in case you want to run custom sql queries.

    // group by most submissions
    dataset.groupBy("login").count().sort($"count".desc).show()

    // group by users with distinct "extensions"
    dataset.groupBy("login").agg(countDistinct($"extension")).sort($"count(extension)".desc).show()

    // group by "extensions"
    dataset.groupBy("extension").count().sort($"count".desc).show()

    spark.stop()
  }
}
