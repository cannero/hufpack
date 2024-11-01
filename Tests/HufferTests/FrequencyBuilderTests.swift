import Testing
@testable import HufferLib

struct FrequencyBuilderTests {
    @Test func getFrequencyWithSingleCharacter() {
        let freq = FrequencyBuilder()
        let input = "a"
        let expectedOutput = 1
        #expect(freq.getFrequency(content: input) == expectedOutput)
    }
}
