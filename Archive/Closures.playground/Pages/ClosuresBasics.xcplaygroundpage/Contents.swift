import UIKit

/// Пример использования `closure` в качестве аргумента функции
struct Track {
    var trackNumber: Int
}

let tracks = [Track(trackNumber: 3), Track(trackNumber: 2), Track(trackNumber: 1), Track(trackNumber: 4)]

let sortedTracks = tracks.sorted { firsTrack, secondTrack -> Bool in
    return firsTrack.trackNumber < secondTrack.trackNumber
}

print(sortedTracks)

/// Пример метода `map()`

// Initial array
let names = ["Anton", "Sashka", "Tair", "Yar"]

// Creates empty array that will be used to store full names
var fullNamesForIn: [String] = []

// For-in loop example
for name in names{
    let fullName = name + " Smith"
    fullNamesForIn.append(fullName)
}

// `map()` example
// verbose example
let fullNamesMap = names.map { name -> String in
    return name + " Smith"
}

// Shortened example
let fullNamesMapShort = names.map { $0 + " Smith" }


/// Пример метода `filter()`

let numbers = [4, 8, 15, 16, 23, 52]
var numbersLessThan20: [Int] = []

// For-in loop example
for number in numbers {
    if number < 20 {
        numbersLessThan20.append(number)
    }
}

// Filter example
/* verbose example
let numbersLessThan20Filter = numbers.filter { (number) -> Bool in
    return number < 20
}
*/

// Shortened example
let numbersLessThan20Filter = numbers.filter{$0 < 20}

/// Пример использования метода `reduce()`

// Take numbers list from filter() example
var total = 0

// For-in example
for number in numbers {
    total += number
}

print(total)
// 118

// Reduce example
// Verbose version
let totalReduceVerbose = numbers.reduce(0) { partialResult, newValue -> Int in
    return partialResult + newValue
}

print(totalReduceVerbose)
// 118

// Short version
let totalReduceShort = numbers.reduce(0) {$0 + $1}
print(totalReduceShort)
// 118
