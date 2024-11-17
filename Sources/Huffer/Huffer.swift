import ArgumentParser
import Foundation
import HufferLib

@main
struct Huffer: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        subcommands: [Serialize.self, Deserialize.self,])
}

struct Options: ParsableArguments {
    @Option(
        help: "The file to read.")
    var readFile: String

    @Option(
        help: "The file to write.")
    var writeFile: String
}

extension Huffer {
    struct Serialize : ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Serialize a file and write the encoded content to a new file.",
            aliases: ["se"])

        @OptionGroup var options: Options

        mutating func run() throws {
            print(options.readFile)
            let contents = readFile(filePath: options.readFile)
            let freqBuilder = FrequencyBuilder()
            let frequencies = freqBuilder.getFrequency(content: contents)
            let generator = CodeGenerator()
            let codes = generator.generateCode(frequencies: frequencies)
            print(frequencies)
            print(codes)

            do {
                // replace existing content by re-creating the file
                _ = FileManager.default.createFile(atPath: options.writeFile, contents: nil, attributes: nil)

                let fileHandle = FileHandle(forWritingAtPath: options.writeFile)!
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
}

extension Huffer {
    struct Deserialize : AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Deserialize a file and write the content to a new file.",
            aliases: ["de"])

        @OptionGroup var options: Options

        mutating func run() async throws {
            do {
                guard let data = FileManager.default.contents(atPath: options.readFile) else {
                    print("file \(options.readFile) cannot be read")
                    return
                }
                let sequence = contentsAsyncSequence(data)
                let deserializer = CodeDeserializer()
                let result = try await deserializer.deserialize(sequence)
                _ = FileManager.default.createFile(atPath: options.writeFile, contents: result.data(using: .utf8), attributes: nil)
                print("File \(options.writeFile) written")
            } catch {
                print("Error deserializing: \(error)")
            }
        }

        // This helper function is necessary as the async FileHandle bytes or URL resourceBytes
        // functions seem to be not available under Windows.
        func contentsAsyncSequence(_ data: Data) -> AsyncStream<UInt8> {
            AsyncStream { continuation in
                Task {
                    for byte in data {
                        continuation.yield(byte)
                    }
                    continuation.finish()
                }
            }
        }
    }
}

enum MyError: Error {
    case fileNotFound
}
