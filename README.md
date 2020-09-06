# PropertyWrappersCollection

Useful PropertyWrappers collection

## PropertyWrapper Collections

- [@URLEncoded](#URLEncoded)
- [@UserDefaultsWrapper](#UserDefaultsWrapper)
- [@JSONBundleWrapper](#JSONBundleWrapper)

### @URLEncoded

- Code

```swift
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
```

- Usage

```swift
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
```

---

### @UserDefaultsWrapper

- Code

```swift
@propertyWrapper struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
```

- Usage

```swift
struct TestModel {
    @UserDefaultsWrapper("firstLoad", defaultValue: false)
    var firstLoad: Bool
    @UserDefaultsWrapper("repeatCount", defaultValue: 1)
    var repeatCount: Int
}

var model = TestModel()
print(model.firstLoad) // false
print(model.repeatCount) // 1

model.repeatCount += 1

print(model.repeatCount) // 2
```

---

### @JSONBundleWrapper

- Code

```Swift
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
```

- Usage

```json
// contributions_light.json

{
  "count": 305,
  "contributions": [
    {
      "date": "2018-11-04",
      "contribution": 0,
      "hexColor": "#ebedf0"
    },
    {
      "date": "2018-11-05",
      "contribution": 0,
      "hexColor": "#ebedf0"
    }
  ]
}
```

```swift
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
```
