from python import Python, PythonObject
from shaderlab import errorToString, pprint
from shaderlab import ProgramSource
from shaderlab.libglsl.libglsl_gen import libglsl_gen
from shaderlab.shader_bind import ShaderBind
from sys import exit


fn LexicalSyntacticAnalyser(Program: ProgramSource,) raises -> PythonObject:
    """
        This is a crude implementation of a Lexer/Tokenizer.
        It is built primarily in Python and has been bridged
        to Mojo via `import_module` since Mojo doesn't support
        Regular Expressions.

        Future versions will be written in pure Mojo

        Takes in a program source object which is basically
        a better structural alternative to a bare string. 
        
        See shaderlab/libutils/program_source.mojo
    """
    try:


        if Program.programDidError:
            print('\x1b[31mExiting Program at Lexer due to the above error\x1b[0m')
            return PythonObject()
        

        Python.add_to_path("./python_bindings")
        var module = Python.import_module("lex")
        var libprs = Python.import_module('parser')
        var lex_result = module.lex(Program.shader)
        var prs_result = libprs.SyntacticAnalysis(lex_result)
        return prs_result
    except e:
        var error_comp = errorToString(e)
        var error_line = error_comp[0]

        var error_string = error_comp[1]
        ProgramSource.throw(Program, error_line, error_string)
        return PythonObject()

fn main() raises:
    var prgm = ProgramSource("""
        @Shaderbind VERTEX vertex
        @Shaderbind FRAGMENT fragment

        fn phong(): void {
        }

        fn vertex(): Vector4 {
            phong()
        }

        fn fragment(): ShaderOutput {
        }
        
    """)
    var tks = LexicalSyntacticAnalyser(prgm)
    var trackers = ShaderBind(tks, prgm)
    pprint(trackers)
    
