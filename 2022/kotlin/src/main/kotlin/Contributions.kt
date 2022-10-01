// identify most recent commits of the user specified as the first argument, fetch total contributions made on those repos
// cerner_2tothe5th_2022
// Run with args <user-name> <PAT> <org-name> <github-v3-api-endpoint>
import okhttp3.OkHttpClient
import retrofit2.*
import retrofit2.http.*
import retrofit2.converter.moshi.MoshiConverterFactory

// service interface
interface GitHubService {
    @GET("search/commits")
    fun getUserCommits(@Query("q") query: String): Call<Commits>

    @GET("repos/{owner}/{repo}/contributors?per_page=100")
    fun getRepoContributors(@Path("owner") owner: String, @Path("repo") repo: String): Call<List<User>> }

// data classes
data class User(val login: String, val contributions: Int)
data class Commits(val items: List<Commit>, val total_count: Int)
data class Commit(val html_url: String, val repository: Repository)
data class Repository(val full_name: String)

fun main(args: Array<String>) {
    val httpClient = OkHttpClient.Builder().addInterceptor { chain ->
        val request = chain.request().newBuilder().header("Accept", "application/vnd.github.v3+json").header("Authorization", "Bearer ${args[1]}").build()
        chain.proceed(request) }.build()

    val service = Retrofit.Builder().baseUrl(args[3]).addConverterFactory(MoshiConverterFactory.create()).client(httpClient).build().create(GitHubService::class.java)
    val request = service.getUserCommits("author:${args[0]} org:${args[2]} sort:author-date-desc").execute()

    val map: HashMap<String, Int?> = HashMap()

    // found recent commits, now get the repo of the commits and then fetch total contributions made by the user in that repo
    // not paginating on /contributions - so for repos with more than 100 contributors, the user contributions might not be shown!!
    println("Found ${request.body()!!.total_count} commits for user ${args[0]} for org ${args[2]}")
    for (commit in request.body()!!.items){
        val splits = commit.repository.full_name.split( "/", ignoreCase = false, limit = 0)
        if (!map.containsKey(commit.repository.full_name))
            map[commit.repository.full_name] = service.getRepoContributors(splits[0], splits[1]).execute().body()!!.find { collaborator -> collaborator.login.lowercase() == args[0].lowercase() }?.contributions
    }

    // print the repo and the user contributions in descending order
    for (key in map.toList().sortedByDescending { (_, value) -> value }.toMap().keys) { println("$key - ${map[key]}") }
}
