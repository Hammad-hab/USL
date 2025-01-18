from .. import ProgramSource, USLVariableChunk, USLShaderChunk, USLFunctionChunk
from python import PythonObject
from .glsl_typing import *
from ..libutils.tracker import TrackerPairs

fn libglsl_gen(tokens: PythonObject, prgm: ProgramSource, trackers:TrackerPairs) raises -> USLShaderChunk:

    var program = USLShaderChunk()
    program.nullify() # Prevent the afterCompileSafety from causing issues if the function has no body
    program.setShaderTypeGLSL()
    for token in tokens:
        print(token)
        # if token['type'] == 'VariableDeclaration':
        #     var ffn: USLVariableChunk = USLVariableChunk(str(token['name']))
        #     # Handling integer and float values 
        #     if str(token['value']['type']) == 'NumberFloat':
        #         ffn.set_var_type(GLSL_FLOAT)
        #     else:
        #         ffn.set_var_type(GLSL_INT)
        #     ffn.set_val(str(token['value']['value']))
        #     ffn.afterCompileSafety()
        #     program.superDangerousAppend(ffn.structure.getStructure())


        # if token['type'] == 'FunctionDeclaration':
        #     print('FN DEC')
        #     if is_nested:
        #         prgm.throw(prgm, token['line'] + 1, "Illegal function declaration in local scope. All functions must be declared in global scope.")
        #     var ffn: USLFunctionChunk = USLFunctionChunk(str(token['name']))
        #     var parsedBody = libglsl_gen(token['body'], True, prgm)
        #     ffn.add_chunk(parsedBody)
        #     ffn.set_ret_type(GLSL_VOID)
        #     ffn.afterCompileSafety()
        #     program.superDangerousAppend(ffn.structure.getStructure())

        # if token['type'] == 'CallExpression':
        #     ...

        
    program.afterCompileSafety()
    return program