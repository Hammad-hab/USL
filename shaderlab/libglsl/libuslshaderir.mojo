from .. import USLShaderChunk, USLVariableShader, USLFunctionShader
from python import PythonObject
from .glsl_typing import *

fn libusl_shader_ir_gen(tokens: PythonObject) raises:
    """
        Converts USL code (parsed using the python function in python_bindings), to a JSON
        like object repersentation that can be traversed and compiled into any shader language.
    """
    var program = USLShaderChunk()
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


        if token['type'] == 'FunctionDeclaration':
            var ffn: USLFunctionShader = USLFunctionShader(str(token['name']))
            ffn.set_ret_type(GLSL_VOID)
            ffn.afterCompileSafety()
            program.superDangerousAppend(ffn.bakus_naur.getStructure())
        