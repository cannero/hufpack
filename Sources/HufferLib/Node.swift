protocol Node {
    var weight: Int { get }
    var isLeaf: Bool { get }
    var left: Node? { get }
    var right: Node? { get }
}
