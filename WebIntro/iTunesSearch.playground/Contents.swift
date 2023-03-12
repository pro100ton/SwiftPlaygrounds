import UIKit

// Extension to Data to make JSON more readable
extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
                JSONSerialization.jsonObject(with: self,
                                             options: []),
            let jsonData = try?
                JSONSerialization.data(withJSONObject:
                                        jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
                                          encoding: .utf8) else {
            print("Failed to read JSON Object.")
            return
        }
        print(prettyJSONString)
    }
}

// Structure for working with results ot iTunes search
struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var description: String
    
    // CodingKeys enum для маппинга ключей получаемых из JSON к проперти полей
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
    }
    
    /* Дополнительный enum для поля description. Нужен так как маппинг для проперти
     description может быть как из поля "longDescription" так и "description".
     Для обхода этой ситуации мы объявляем этот enum который adopt'ит CodingKey и у которого
     есть case `longDescription`
     */
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    /// Так как у нас кастомный маппинг для проперти `description`, то протокол `Codable` не может
    /// автоматически создать для нас метод декодирования, поэтому надо определить кастомный инициализатор
    /// в котором будет описано как надо декодировать получаемый JSON и приводить его к виду нашей структуры
    init(from decoder: Decoder) throws {
        // Создаем контейнер значений закодированный с помощью нашего enum CodingKeys
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        /* Для полей, у которых соотношение ключей 1:1 с JSON - декодируем их с помощью
         Созданного контейнера с case'ами из enum CodingKeys
         */
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.artist = try valueContainer.decode(String.self, forKey: CodingKeys.artist)
        self.kind = try valueContainer.decode(String.self, forKey: CodingKeys.kind)
        /* Для проперти `description` необходимо сначала проверить есть ли в JSON поле
         `description`
         */
        if let description = try? valueContainer.decode(
            String.self,
            forKey: CodingKeys.description) {
            // Если есть - присвоить проперти `desctiption` значение поля `description` из JSON
            self.description = description
        } else {
            /* Если нет - объявить новый контейнер декодирования значений но теперь с enum'ом
             `AdditionalKeys` где есть кейс `longDescription`
             */
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            /* Проверяем есть ли с новым контейнером поле `longDescription`, если есть то
             присваиваем проперти `description` значение `longDescription`. Если нет - то
             присваиваем пустую строку
             */
            self.description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? "No description"
        }
    }
}

/// Структура для хранения результатов запроса в iTunes
struct SearchResponse: Codable {
    let results: [StoreItem]
}

/// ENUM для хранения ошибок, которые могут возникнуть при запросе в iTunes
enum ITunesRequestError: Error, LocalizedError {
    case somethingWentWrong
}

// MARK: TODO - заполнить throws
/// Функция для получения данных iTunes
/// - Parameter query: Словарь запроса
/// - Throws: Кейсы ENUM'a `ITunesRequestError`
/// - Returns: Массив из `StoreItem`'ов
func fetchItems(matching query: [String:String]) async throws -> [StoreItem] {
    // Создаем search request с помощью класса URLComponents
    var searchRequest = URLComponents(string: "https://itunes.apple.com/search")!
    
    // Задаем query items в соответствии с переданным в аргументе запросом
    searchRequest.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
    
    // Используя метод data делаем веб запрос
    let (data, response) = try await URLSession.shared.data(
        from: searchRequest.url!)
    
    // Проверяем валидность полученного ответа
    // В случае если ответ соответствует HTTPURLResponse и его статус код == 200 - продолжаем
    // выполнение. В противном случае бросам ошибку somethingWentWrong
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw ITunesRequestError.somethingWentWrong
    }
    
    
    // Declaring JSON decoder
    let jsonDecoder = JSONDecoder()
    
    // Пытаемся распарсить полученный JSON в объект SearchResponse
    let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
    
    return searchResponse.results
}

let query = [
    "term": "Apple",
    "media": "music",
    "limit": "10"
]

Task {
    do {
        let searchData = try await fetchItems(matching: query)
        searchData.forEach { item in
            print("""
                Name: \(item.name)
                Artist: \(item.artist)
                Kind: \(item.kind)
                Description: \(item.description)
                ----------------------------
            """)
        }
    } catch {
        print("Something went wrong: \(error)")
    }
}
