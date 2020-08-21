# PropertyWrappersCollection

Useful PropertyWrappers collection

## PropertyWrapper Collections

- [@URLEncoded](#URLEncoded)
- [@UserDefaultsWrapper](#UserDefaultsWrapper)

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
