import ArgumentParser
import Foundation
import HufferLib

@main
struct Huffer: ParsableCommand {
    @Option(help: "Specify the file")
    public var file: String

    mutating func run() throws {
        print(self.file)
        let contents = readFile(filePath: self.file)
        let freqBuilder = FrequencyBuilder()
        let frequencies = freqBuilder.getFrequency(content: contents)
        let generator = CodeGenerator()
        let codes = generator.generateCode(frequencies: frequencies)
        print(frequencies)
        print(codes)

        let filePath = "../testfile.bin"
        do {
            // replace existing content by re-creating the file
            _ = FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)

            let fileHandle = FileHandle(forWritingAtPath: filePath)!
            let handler = FileHandler(handle: fileHandle)
            let serializer = CodeSerializer(ioHandler: handler, codes: codes)
            try serializer.writeHeader(contents)
            try serializer.writeContent(contents)
            try fileHandle.close()
            print("file written")
        } catch {
            print("Error writing file: \(error)")
        }
    }

    func readFile(filePath: String) -> String {
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            return fileContents
        } catch {
            print("Error reading file: \(error)")
            Huffer.exit(withError: MyError.fileNotFound)
        }
    }
}

enum MyError: Error {
    case fileNotFound
}
