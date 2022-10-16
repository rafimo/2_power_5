// Analysis of data from GitHub API using Spark
// Run as: GitHubAnalysis <bearer-token> <keyword-to-search-for>
// cerner_2tothe5th_2022
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions.{array, explode}
import sttp.client3._

object GitHubAnalysis {
  def main(args: Array[String]): Unit = {

    // fetch data from GitHub API based on keyword in command line arg 1 and store it into a temp-file
    // TODO: paginate this..
    val request = basicRequest.response(asStringAlways).auth.bearer(args(0))
      .get(uri"https://api.github.com/search/code" .addParams(Map("q" -> args(1), "sort" -> "indexed", "per_page" -> "100")))
    val tempFile = os.temp(deleteOnExit = true)
    os.write.over(tempFile, HttpURLConnectionBackend().send(request).body)

    // pass the temp-file to a Spark session
    val spark = SparkSession.builder.appName("GitHub Analysis").config("spark.master", "local")
      .config("spark.eventLog.enabled", value = false).getOrCreate()
    val dataframe = spark.read.option("multiline", "true").json(tempFile.toString())

    // convert to a dataframe
    import spark.implicits._
    val dataset = dataframe.withColumn("items", explode($"items")).withColumn("file_name", $"items"("name"))
      .withColumn("repository", explode(array($"items"("repository"))))
      .withColumn("full_name", explode(array($"repository"("full_name"))))
      .drop("incomplete_results", "total_count", "items", "repository")

    // do any analysis here. below finds all repo names which reference the keyword the most
    dataset.groupBy("full_name").count().sort($"count".desc).show()
    spark.stop()
  }
}
