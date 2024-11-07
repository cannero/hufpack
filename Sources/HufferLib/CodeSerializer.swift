import Foundation

public struct CodeSerializer {
    var ioHandler: IOHandler

    public init(ioHandler: IOHandler) {
        self.ioHandler = ioHandler
    }

    func writeContent(_ content: String, _ codes: [Character : String]) throws {
        var stringbuffer = ""
        
        for char in content {
            stringbuffer += codes[char]!

            while stringbuffer.count >= 8 {
                let index = stringbuffer.index(stringbuffer.startIndex, offsetBy: 8)
                let nextByte = stringbuffer[..<index]
                let num = convertToUInt8(nextByte)
                try ioHandler.write(contentsOf: num)
                stringbuffer = String(stringbuffer[index...])
            }
        }

        if !stringbuffer.isEmpty {
            let rest = stringbuffer.padding(toLength: 8, withPad: "0", startingAt: 0)
            let num = convertToUInt8(rest)
            try ioHandler.write(contentsOf: num)
        }
    }

    func convertToUInt8<S: StringProtocol>(_ binary: S) -> [UInt8] {
        if let number = UInt8(binary, radix: 2) {
            return [number]
        }

        print("Cannot convert \(binary) to uint8")
        exit(1)
    }
}

enum MySerializerError: Error {
    case conversionFailed
}
