from .. import USLShaderChunk, USLVariableShader, USLFunctionShader, ProgramSource
from python import PythonObject
from .glsl_typing import *

fn libglsl_gen(tokens: PythonObject, is_nested:Bool, prgm: ProgramSource) raises -> USLShaderChunk:
    """
        Converts USL code (parsed using the python function in python_bindings), to a JSON
        like object repersentation that can be traversed and compiled into any shader language.
    """
    var program = USLShaderChunk()
    program.setShaderTypeGLSL()
    for token in tokens:
        if token['type'] == 'VariableDeclaration':
            var ffn: USLVariableShader = USLVariableShader(str(token['name']))

            # Handling integer and float values 
            if str(token['value']['type']) == 'NumberFloat':
                ffn.set_var_type(GLSL_FLOAT)
            else:
                ffn.set_var_type(GLSL_INT)
            ffn.set_val(str(token['value']['value']))
            ffn.afterCompileSafety()
            program.superDangerousAppend(ffn.bakus_naur.getStructure())


        if token['type'] == 'FunctionDeclaration' and not is_nested:
            var ffn: USLFunctionShader = USLFunctionShader(str(token['name']))
            var parsedBody = libglsl_gen(token['body'], True, prgm)
            ffn.add_chunk(parsedBody)
            ffn.set_ret_type(GLSL_VOID)
            ffn.afterCompileSafety()
            program.superDangerousAppend(ffn.bakus_naur.getStructure())
        elif token['type'] == 'FunctionDeclaration' and is_nested:
            prgm.throw(prgm, token['line'] + 1, "Illegal function declaration in local scope. All functions must be declared in global scope.")
            
    program.afterCompileSafety()
    return program