from utils import Variant
from shaderlab import Variable, Literal
fn main() raises:
    var x: List[Variant[Variable[Literal[String]], Literal[String], Literal[Int32]]] = List[Variant[Variable[Literal[String]], Literal[String], Literal[Int32]]]()
    x.append(Variable[Literal[String]]('Hello', Literal[String]('Hia')))
    x.append(Literal[Int32](10))