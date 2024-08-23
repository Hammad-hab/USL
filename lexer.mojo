from python import Python
from shaderlab import Token, errorToString
from ExceptionTracer import ProgramSource
from sys import exit

fn LexicalAnalyzer(Program: ProgramSource) raises -> List[Token]:
    """
        This is a crude implementation of a Lexer/Tokenizer.
        It is built primarily in Python and has been bridged
        to Mojo via `import_module` since Mojo doesn't support
        Regular Expressions.

        Future versions will be written in pure Mojo

        Takes in a program source object which is basically
        a better structural alternative to a bare string. 
        
        See ExceptionTracer.mojo
    """
    try:
        Python.add_to_path("./python_bindings")
        var module = Python.import_module("lex")
        var lex_result = module.lex(Program.shader)
        var list_rsult = List[Token]()
        for result in lex_result:
            list_rsult.append(Token.from_PythonObject(result))
        return list_rsult
    except e:
        var error_comp = errorToString(e)
        var error_line = error_comp[0]

        var error_string = error_comp[1]
        ProgramSource.throw(Program, error_line, error_string)
        return List[Token]()

# fn main() raises:
#     LexicalAnalyzer()