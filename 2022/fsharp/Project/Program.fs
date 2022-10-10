// console app in f-sharp to invoke an api and print out a response
// get nationalities of the first arg 
// run as below in the project directory
//      dotnet run <name>
// cerner_2tothe5th_2022
// For more information see https://aka.ms/fsharp-console-apps
open System
open System.Net.Http
open System.Text.Json

let getData = async {
    use httpClient = new System.Net.Http.HttpClient()
    let args = System.Environment.GetCommandLineArgs()
    let! response = httpClient.GetAsync($"https://api.nationalize.io/?name={args[1]}") |> Async.AwaitTask
    response.EnsureSuccessStatusCode () |> ignore
    let! content = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    printfn "Returned countries: %s" content // TODO: json deserialise this response..
}

// using an explicit entrypoint
[<EntryPoint>]
let main argv =
    getData
    |> Async.RunSynchronously // run the code!

    0
