public struct CodeGenerator {
    public init() {}

    public func generateCode(frequencies: [Character : Int]) -> [Character : String] {
        let treeBuilder = TreeBuilder()
        let tree = treeBuilder.buildTree(frequencies: frequencies)
        var codes: [Character : String] = [:]
        walkTree(tree.root.left, &codes, "0")
        walkTree(tree.root.right, &codes, "1")
        return codes
    }

    func walkTree(_ node: Node?, _ codes: inout [Character : String],_ currentCode: String) {
        guard let node = node else { return }
        
        if let characterNode = node as? CharacterNode {
            codes[characterNode.character] = currentCode
            return
        }

        walkTree(node.left, &codes, currentCode + "0")
        walkTree(node.right, &codes, currentCode + "1")
    }
}
