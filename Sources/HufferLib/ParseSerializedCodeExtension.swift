import Foundation

// https://www.swiftbysundell.com/articles/string-parsing-in-swift/
extension String {
    var codes: [Character : String] {
        var key: Character?
        var partialCode: String?
        var parsed: [Character : String] = [:]

        func parse(_ character: Character) {
            if key == nil {
                key = character
            }
            else if character == ";" {
                parsed[key!] = partialCode!
                key = nil
                partialCode = nil
            }
            else if var currentCode = partialCode {
                currentCode.append(character)
                partialCode = currentCode
            }
            else {
                partialCode = String(character)
            }
        }

        forEach(parse)

        return parsed
    }
}
