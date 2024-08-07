from python import Python
from shaderlab import Token


fn tokenize(Shader: String) -> List[Token]:
    """
        This is a crude implementation of a Lexer/Tokenizer.
        It is built primarily in Python and has been bridged
        to Mojo via `import_module` since Mojo doesn't support
        Regular Expressions.

        Future versions will be written in pure Mojo
    """
    print("USL_LOG: Version 0.02 will require an ExceptionHandler as first parameter, not a shader.")
    try:
        Python.add_to_path("./python_bindings")
        var module = Python.import_module("lex")
        var lex_result = module.lex(Shader)
        var list_rsult = List[Token](Token("CARTEXCP", "NIL"))
        for result in lex_result:
            list_rsult.append(Token.from_PythonObject(result))
        return list_rsult
    except:
        ...
        return List[Token](Token("CARTEXCP", "NIL"))
