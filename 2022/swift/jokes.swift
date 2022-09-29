// a swift joke
// cerner_2tothe5th_2022
import Foundation

struct Joke: Codable {
    let value: String
}
 
let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random")!)
let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
let joke = decodedResponse?.value ?? ""

print(joke)
