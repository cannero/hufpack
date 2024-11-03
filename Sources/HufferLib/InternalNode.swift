struct InternalNode: Node {
    let weight: Int
    let isLeaf: Bool
    let left: Node?
    let right: Node?

    init(left: Node, right: Node) {
        self.weight = left.weight + right.weight
        self.left = left
        self.right = right
        self.isLeaf = false
    }
}
