import Foundation

struct FileHandler: IOHandler {
    var handle: FileHandle

    public init(handle: FileHandle) {
        self.handle = handle
    }

    public func write<T>(contentsOf data: T) throws where T : DataProtocol {
        try self.handle.write(contentsOf: data)
    }
}
