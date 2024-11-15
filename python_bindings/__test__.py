from lex import lex
from parser import SyntacticAnalysis

lexed = lex("""   var l = 10.20
    var n = 3
    fn Supacool() {
        var hey = 10
        fn hia() {
            var x = 9
        }
    }
    """)

parsed = SyntacticAnalysis(lexed)
print(parsed)