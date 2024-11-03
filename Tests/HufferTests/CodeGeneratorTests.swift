import Testing
@testable import HufferLib

struct CodeGeneratorTests {
    var codeGen: CodeGenerator

    init() {
        codeGen = CodeGenerator()
    }

    //TODO: add test for single character exception

    @Test func getCodeWithTwoCharacters() {
        let expectedOutput: Dictionary<Character, String> = ["b": "0", "a": "1"]
        #expect(codeGen.generateCode(frequencies: TestHelper.getTwoFrequencies()) == expectedOutput)
    }

    @Test func getCodeWithThreeCharacters() {
        let expectedOutput: Dictionary<Character, String> = ["b": "01", "c": "00", "a": "1"]
        #expect(codeGen.generateCode(frequencies: TestHelper.getThreeFrequencies()) == expectedOutput)
    }
}
