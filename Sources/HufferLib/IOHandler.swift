import Foundation

public protocol IOHandler {
    func write<T>(contentsOf data: T) throws where T : DataProtocol
}
