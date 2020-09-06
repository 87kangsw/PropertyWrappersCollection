import Foundation

@propertyWrapper
struct JSONBundleWrapper<T: Decodable> {
    let fileName: String
    
    var wrappedValue: T? {
        get {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
            do {
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                print(error)
                return nil
            }
        }
    }
}

struct Contribution: Codable {
    let date: String
    let contribution: Int
    let hexColor: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case contribution
        case hexColor
    }
}

struct ContributionInfo: Codable {
    let count: Int
    let contributions: [Contribution]
    
    @JSONBundleWrapper(fileName: "contributions_light")
    static var all: ContributionInfo?
    
    enum CodingKeys: String, CodingKey {
        case count
        case contributions
    }
}

print(ContributionInfo.all)
