import UIKit
import Foundation

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





struct TestModel {
    @UserDefaultsWrapper("firstLoad", defaultValue: false)
    var firstLoad: Bool
    @UserDefaultsWrapper("repeatCount", defaultValue: 1)
    var repeatCount: Int
}

var model = TestModel()
print(model.firstLoad)
print(model.repeatCount)

model.repeatCount += 1

print(model.repeatCount)
