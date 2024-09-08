from python import Python
from shaderlab import Token, errorToString, pprint, ShaderOperationVar
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
        var list_rsult = List[Token]()
        if Program.programDidError:
            print('\x1b[31mExiting Program at Lexer due to the above error\x1b[0m')
            return list_rsult
        Python.add_to_path("./python_bindings")
        var module = Python.import_module("lex")
        var libprs = Python.import_module('parser')
        var lex_result = module.lex(Program.shader)
        var prs_result = libprs.SyntacticAnalysis(lex_result)
        for result in lex_result:
            list_rsult.append(Token.from_PythonObject(result))
        return list_rsult
    except e:
        var error_comp = errorToString(e)
        var error_line = error_comp[0]

        var error_string = error_comp[1]
        ProgramSource.throw(Program, error_line, error_string)
        return List[Token]()

fn main() raises:
    var prgm = ProgramSource("""
    var l = 10.20
    """)
    var tks = LexicalAnalyzer(prgm)