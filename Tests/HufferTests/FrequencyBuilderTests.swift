import Testing
@testable import HufferLib

struct FrequencyBuilderTests {
    var freq : FrequencyBuilder

    init() {
        freq = FrequencyBuilder()
    }

    @Test func getFrequencyWithSingleCharacter() {
        let input = "a"
        let expectedOutput = [Character("a"): 1]
        #expect(freq.getFrequency(content: input) == expectedOutput)
    }

    @Test func getFrequencyWithMultipleCharacters() {
        let input = "abcaabbbb🍿"
        let expectedOutput = [
            Character("a"): 3,
            Character("b"): 5,
            Character("c"): 1,
            Character("🍿"): 1,
        ]
        #expect(freq.getFrequency(content: input) == expectedOutput)
    }
}
