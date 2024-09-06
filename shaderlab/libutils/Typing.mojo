
fn is_reserved(keyword:String) -> Bool:
    var reserved: List[String] = List[String](str('fn'), str('var'))
    if keyword in reserved:
        return True
    else:
        return False

@value
struct TokenBasedString:
    var value: String
    var type: String


@value
struct TokenBasedNumber:
    var value: Float32
    var type: String

    

struct Token(CollectionElement):
    var type : String
    var value : String
    var line: Int

    # @deprecated("from_PythonObject is a really unsafe function, will be removed soon")
    @staticmethod
    fn from_PythonObject(object: PythonObject) raises -> Token:
        try:
            return Token(object.type, object.value, object.line)
        except:
            print("Invalid Object, it is incomplete and incompatible with Token Class")
            raise
        ...
    
    fn __copyinit__(inout self, existing: Self):
        self.value = existing.value
        self.type = existing.type
        self.line = existing.line

    
    fn __moveinit__(inout self, owned existing: Self):
        self.type = existing.type
        self.value = existing.value
        self.line = existing.line
        ...

    fn __init__(inout self, type: String, value: String, line: Int):
        self.type = type
        self.value = value
        self.line = line
        

    fn __repr__(inout self) -> String:
        return "Token(" + self.type +", " + self.value + ")"


trait PPrintable:
    fn repr(inout self) -> String:...


@value
struct ShaderOperationVar(PPrintable):
    var tokens: List[Token]
    var name: String
    var arguments: List[Token]
    var type: String

    fn getName(inout self) -> String:
        return self.name
    
    fn setName(inout self, name:String) :
        self.name = name
   

    fn repr(inout self) -> String:
       return 'ShaderOperationVar(name=' + self.name + ', type=' + self.type + ')'