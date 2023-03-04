// Объявление расширения для UIColor и создание статичной переменной с рандомным цветом
import UIKit

extension UIColor {
    static var random: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Расширение типа String для добавления функции трансформации во множественное число
extension String {
    func pluralize() -> String {
        return self + "'s"
    }
}

let apple = "Apple"
let sashka = "Sashka"

print(apple.pluralize())
print(sashka.pluralize())

// Также расширения можно использовать для задания собственных инициализаторов для существующих типов
extension String {
    init?(passwordSafeString: String) {
        guard passwordSafeString.rangeOfCharacter(from: .uppercaseLetters) != nil
                &&
                passwordSafeString.rangeOfCharacter(from: .lowercaseLetters) != nil
                &&
                passwordSafeString.rangeOfCharacter(from: .punctuationCharacters) != nil
                &&
                passwordSafeString.rangeOfCharacter(from: .decimalDigits) != nil
        else {
            return nil
        }
        self = passwordSafeString
    }
}

let unsafePassword = String(passwordSafeString: "hi")
print(unsafePassword ?? "Unsafe password")
let safePassword = String(passwordSafeString: "1Hi,")
print(safePassword!)
