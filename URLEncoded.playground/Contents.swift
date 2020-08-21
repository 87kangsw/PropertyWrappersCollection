import UIKit
import Foundation

@propertyWrapper
struct URLEncoded {
    private(set) var value: String = ""
    var wrappedValue: String {
        get { value }
        set {
            if let url = newValue.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                self.value = url
            }
        }
    }
}

struct Query {
    @URLEncoded
    var city: String
    
    var url: String {
        return "https://www.timeanddate.com/weather/?query=\(city)"
    }
    
    init(city: String) {
        self.city = city
    }
}

let koreanQuery = Query(city: "서울")
print(koreanQuery.url) // https://www.timeanddate.com/weather/?query=%EC%84%9C%EC%9A%B8

let newyorkQuery = Query(city: "New York")
print(newyorkQuery.url) // https://www.timeanddate.com/weather/?query=new%20york

