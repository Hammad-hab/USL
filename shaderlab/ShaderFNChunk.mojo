from .ShaderChunk import USLShaderChunk

struct USLFunctionShader:
    var fn_name: String
    var bakus_naur : USLShaderChunk
    
    fn __init__(inout self, fn_name: String):
        self.fn_name = fn_name
        self.bakus_naur = USLShaderChunk()

        self.bakus_naur.setShaderTypeGLSL()
        self.bakus_naur.defineShaderStructure("<ret_type> <fn_name>(<args[]>) {\n\t<code>\n}")
        self.bakus_naur.insertBakusNaurTag('fn_name', self.fn_name)

    fn add_argument(inout self, arg_type: String, arg_val: String):
        self.bakus_naur.insertBakusArrayNaurTag('args', arg_type + ' ' + arg_val, False)
    
    fn add_chunk(inout self, borrowed code_chunk: USLShaderChunk) raises:
        if not code_chunk.isCompiled:
            raise Error('Error at USLFunctionShader.add_chunk, provided chunk is unsafe. afterCompileSafety has not been called.')
        else:
            self.bakus_naur.insertBakusNaurTag('code', code_chunk.structure + '\t<code>\n')
    
    fn add_code(inout self, borrowed code_block: String):
        self.bakus_naur.insertBakusNaurTag('code', code_block + '<code>')

    fn set_ret_type(inout self, borrowed type: String):
        self.bakus_naur.insertBakusNaurTag('ret_type', type)

    fn afterCompileSafety(inout self) raises:
        self.bakus_naur.insertBakusNaurTag('code', '')
        self.bakus_naur.insertBakusArrayNaurTag('args', '', True)

        if '<ret_type>' in self.bakus_naur.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Return type has not been specified')
