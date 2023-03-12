import UIKit

//let url = URL(string: "https://www.apple.com")!
//url.scheme
//url.baseURL
//url.absoluteURL
//url.description
//url.query

//let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

//var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
//urlComponents.queryItems = [
//    "api_key": "DEMO_KEY",
//    "date": "2013-07-16"
//].map { URLQueryItem(name: $0.key, value: $0.value)}
//
//Task {
//    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
//
//    let jsonDecoder = JSONDecoder()
//
//    if let httpResponse = response as? HTTPURLResponse,
//       httpResponse.statusCode == 200,
////       let photoDictianory = try? jsonDecoder.decode([String:String].self, from: data)
//       let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data)
//    {
//        print(photoInfo)
//    }
//}

// Create error enum to throw if Photo fetch data wont succeed
enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
}

func fetchPhotoInfo() async throws -> PhotoInfo {
    // Forming URL request with URLCompontnts
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = [
        "api_key": "DEMO_KEY"
    ].map { URLQueryItem(name: $0.key, value: $0.value)}
    
    // Using URLSession data method to fetch data
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    // Checking that code == 200 (OK response status), if not: throwing an error
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw PhotoInfoError.itemNotFound
    }
    
    // Declaring JSON decoder
    let jsonDecoder = JSONDecoder()
    
    // Decoding JSON to PhotoInfo structure
    let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
    return photoInfo
}

// Calling fetching method in asynchronous way
Task {
    do {
        let photoInfo = try await fetchPhotoInfo()
        print("Success fetch: \(photoInfo)")
    } catch {
        print("Something went wrong: \(error)")
    }
}
