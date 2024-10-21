from python import PythonObject

fn is_reserved(keyword:String) -> Bool:
    var reserved: List[String] = List[String]('fn', 'var', 'VERTEX', 'FRAGMENT', 'Shaderbind')
    if keyword in reserved:
        return True
    else:
        return False

fn is_construct(keyword:String) -> Bool:
    var reserved_constructs = List[String]('Shaderbind')
    if keyword in reserved_constructs:
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
            return Token(str(object.type), str(object.value), object.line)
        except:
            print("Invalid Object, it is incomplete and incompatible with Token Class")
            raise
        ...

    @staticmethod
    fn to_PythonObject(object: Token) raises -> PythonObject:
        try:
            var obj = PythonObject()
            obj.type = object.type
            obj.value = object.value
            obj.line = object.line
            return obj
        except:
            print("Invalid Token, it is incomplete and incompatible with PythonObject Class " + object.type)
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

