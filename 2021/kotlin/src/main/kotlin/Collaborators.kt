// invoke Github REST API in kotlin
// identify all repos the authenticated user has collaborated on and list all others who have worked on the same repos.
// cerner_2tothe5th_2021
// Run with args <your-user-name> <your-password> <github-v3-api-endpoint>
import okhttp3.OkHttpClient
import retrofit2.*
import retrofit2.http.*
import retrofit2.converter.moshi.MoshiConverterFactory
import java.util.function.Function
import java.util.stream.Collectors

// service interface
interface GitHubService {
    @GET("user/repos?per_page=100&sort=pushed&order=desc")
    fun getUserRepos(): Call<List<Repo>>

    @GET("repos/{owner}/{repo}/contributors?per_page=100")
    fun getRepoContributors(@Path("owner") owner: String, @Path("repo") repo: String): Call<List<User>> }

// data classes
data class User(val login: String, val contributions: Int)
data class Repo(val full_name: String)

fun main(args: Array<String>) {
    val authToken = "Basic " + java.util.Base64.getEncoder().encode("${args[0]}:${args[1]}".toByteArray()).toString(Charsets.UTF_8)
    val httpClient = OkHttpClient.Builder().addInterceptor { chain ->
            val request = chain.request().newBuilder().header("Accept", "application/vnd.github.v3+json").header("Authorization", authToken).build()
            chain.proceed(request) }.build()

    val service = Retrofit.Builder().baseUrl(args[2]).addConverterFactory(MoshiConverterFactory.create()).client(httpClient).build().create(GitHubService::class.java)
    val request = service.getUserRepos().execute()
    val uniqueCollaborators = ArrayList<String>()

    // pick first 100 repos which are recently pushed - paginate this to get all repos where you might have worked on
    println("Found ${request.body()!!.size} repositories where you have collaborated")
    for (repo in request.body()!!){
        println(repo.full_name)
        val splits = repo.full_name.split( "/", ignoreCase = false, limit = 0)
        service.getRepoContributors(splits[0], splits[1]).execute().body()!!.forEach { collaborator -> uniqueCollaborators.add(collaborator.login) }
    }
    // identify collaborators on above repos - sorted by most repos where you have worked together on.
    println("Collaborators on repos which you have contributed - sorted by most interactions..")
    println(uniqueCollaborators.stream().collect(Collectors.groupingBy(Function.identity(), Collectors.counting())).toList().sortedByDescending { (_, value) -> value }.take(10))
}
