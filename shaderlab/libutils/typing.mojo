from utils import Variant
alias NULL = 'null'

trait Referable(CollectionElement):
    """
        Basically anything that can have a name is referable.
    """
    fn setName(inout self, name: String):...
    fn getName(inout self) -> String: ...


trait PPrintable:
    fn repr(inout self) -> String: ...

trait Callable(Referable):
    """
        Anything that can be called.
    """
    fn setArguments(inout self, arguments: List[Float32]): ...

@value
struct Literal[T: CollectionElement](Referable):

    var name: String
    var value: T

    def __init__(inout self, value: T):
        self.name = NULL
        self.value = value

    fn setName(inout self, name:String):
        ...
    
    fn getName(inout self,) -> String:
       return NULL

@value
struct Variable[T:Referable](Referable, PPrintable):

    var name: String
    var value: T

    fn __init__(inout self, name: String, value : T):
        self.name = ""
        self.value = value

    fn setName(inout self, name: String):
        self.name = str(name)

    fn getName(inout self) -> String:
        return self.name

    fn setValue(inout self, owned value: T):
        self.value = value

    fn repr(inout self) -> String:
        return "Variable(name=" + self.getName() + ")"

alias USLStringLiteral = Literal[String]
alias USLIntLiteral = Literal[Int32]
alias USLFloatLiteral = Literal[Float32]

alias USLAnyLiteral = Variant[USLStringLiteral,USLIntLiteral,USLFloatLiteral]