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

    @deprecated("from_PythonObject is a really unsafe function, will be removed soon")
    @staticmethod
    fn from_PythonObject(object: PythonObject) raises -> Token:
        try:
            return Token(object.type, object.value)
        except:
            print("Invalid Object, it is incomplete and incompatible with Token Class")
            raise
        ...
    
    fn __copyinit__(inout self, existing: Self):
        self.value = existing.value
        self.type = existing.type

    
    fn __moveinit__(inout self, owned existing: Self):
        self.type = existing.type
        self.value = existing.value
        ...

    fn __init__(inout self, type: String, value: String):
        self.type = type
        self.value = value

    fn __repr__(inout self) -> String:
        return "Token(" + self.type +", " + self.value + ")"
