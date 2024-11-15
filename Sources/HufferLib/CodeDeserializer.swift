import Foundation

public struct CodeDeserializer {

    public func deserialize<S: AsyncSequence>(_ sequence: S) async throws -> String where S.Element == UInt8 {
        var iterator = sequence.makeAsyncIterator()
        let idAndVersion = try await iterator.next(4)

        if idAndVersion != [0x48, 0x46, 0x01, 0x00] {
            print("id or version wrong")
            exit(4)
        }

        let lengthCodesHex = try await iterator.next(4)
        let lengthCodes = bytesToNum(lengthCodesHex)

        let codesHex = try await iterator.next(lengthCodes)
        let codesMaybe = String(data: Data.init(codesHex), encoding: .utf8)

        guard let codesString = codesMaybe else {
            print("could not parse to utf8")
            print(codesHex)
            exit(3)
        }

        let codes = codesString.codes

        let lengthHuffHex = try await iterator.next(4)
        let lengthHuffBlock = bytesToNum(lengthHuffHex)
        let result = try await parseHuffmanCodes(codes, &iterator)

        if result.count != lengthHuffBlock {
            print("length don't match \(result.count) <-> \(lengthHuffBlock)")
            exit(5)
        }

        return result
    }

    func bytesToNum(_ bytes: [UInt8]) -> Int {
        guard bytes.count == 4 else {
            print("input must be 4 bytes")
            exit(2)
        }

        var num = 0
        for b in bytes {
            num <<= 8
            num |= Int(b)
        }

        return num
    }

    func parseHuffmanCodes<I: AsyncIteratorProtocol>(_ codes: [String : Character], _ bytes: inout I) async throws -> String  where I.Element == UInt8 {
        var result = ""
        var currentBuffer = ""

        while let byte = try await bytes.next() {
            let binary = toBinaryString(byte)
            for bit in binary {
                currentBuffer.append(bit)
                if let char = codes[currentBuffer] {
                    result.append(char)
                    currentBuffer = ""
                }
            }
        }

        return result
    }

    func toBinaryString(_ byte: UInt8) -> String {
        let binaryString = String(byte, radix: 2)
        return String(repeating: "0", count: 8 - binaryString.count) + binaryString
    }
}

extension AsyncIteratorProtocol where Element == UInt8{
    mutating func next(_ count: Int) async throws -> [UInt8] {
        var result: [UInt8] = []
        for _ in 0..<count {
            guard let element = try await next() else { break }
            result.append(element)
        }
        return result
    }
}
