//: Использование Extension'ов для организации кода

/*
 Для организации кода можно использовать расширения для разделения объявления базового кастомного
 типа и выносить в расширения его методы
 */


struct Restaurant {
  let name: String
}

extension Restaurant {
    func addRestauratntPostfix() -> String{
        return self.name + " Restaurant"
    }
}

let restaurant = Restaurant(name: "Ikuku")
print(restaurant.addRestauratntPostfix())
