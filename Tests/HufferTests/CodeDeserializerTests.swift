import Foundation
import Testing
@testable import HufferLib

struct CodeDeserializerTests {

    func createTestingClasses() -> CodeDeserializer {
        let deserializer = CodeDeserializer()
        return deserializer
    }

    @Test func deserialize() async throws {
        let deserializer = createTestingClasses()
        let input: [UInt8] = [
            // HF and version 1.0
            0x48, 0x46, 0x01, 0x00,
            // length codes
            0x00, 0x00, 0x00, 0x0c,
            // codes, b is written first
            // ["1100" : "a", "0011" : "b"]
            0x30, 0x30, 0x31, 0x31, 0x3a, 0x62,
            0x31, 0x31, 0x30, 0x30, 0x3a, 0x61,
            // char count
            0x00, 0x00, 0x00, 0x04,
            0b11000011, 0b00111100,
        ]

        let inputSequence = UInt8ArrayAsyncSequence(array: input)

        let result = try await deserializer.deserialize(inputSequence)

        #expect(result == "abba")
    }

    @Test func parseHuffmanCodesLastBytesFilledUpWithNulls() async throws {
        let codes: [String : Character] = ["100" : "😎", "1100" : "🌯", "01" : "⯿"]
        let input: [UInt8] = [
            0b1001_1000, 0b1000_0000,
        ]
        let inputSequence = UInt8ArrayAsyncSequence(array: input)
        var iterator = inputSequence.makeAsyncIterator()
        let deserializer = createTestingClasses()
        let result = try await deserializer.parseHuffmanCodes(codes, 3, &iterator)

        #expect(result == "😎🌯⯿")
    }

    @Test func parseHuffmanCodesLastBytesFilledUpWithNulls_OnlyNCharsTaken() async throws {
        let codes: [String : Character] = ["00" : "t", "10" : "a"]
        let input: [UInt8] = [
            0b1000_0000,
        ]
        let inputSequence = UInt8ArrayAsyncSequence(array: input)
        var iterator = inputSequence.makeAsyncIterator()
        let deserializer = createTestingClasses()
        let result = try await deserializer.parseHuffmanCodes(codes, 2, &iterator)

        #expect(result == "at")
    }
}

struct UInt8ArrayAsyncSequence: AsyncSequence {
    typealias Element = UInt8
    let array: [UInt8]

    struct AsyncIterator: AsyncIteratorProtocol {
        let array: [UInt8]
        var currentIndex = 0

        mutating func next() async -> UInt8? {
            guard currentIndex < array.count else { return nil }
            let element = array[currentIndex]
            currentIndex += 1
            return element
        }
    }

    init(array: [UInt8]) {
        self.array = array
    }

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(array: array)
    }
}
