@value
struct ShaderOperation:
    var args: List[ShaderOperation]
    var body: List[ShaderOperation]
    var name: String
    var value: String
    var line: Int
    var type: String

