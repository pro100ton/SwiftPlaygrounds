import UIKit

var searchRequest = URLComponents(string: "https://itunes.apple.com/search")!
searchRequest.queryItems = [
    "term": "daft+punk",
    "entity": "musicArtist",
].map {URLQueryItem(name: $0.key, value: $0.value)}

Task {
    let (data, response) = try await URLSession.shared.data(from: searchRequest.url!)
    let result = String(data: data, encoding: .utf8)
    print(result)
    
}
