from . import USLShaderChunk

@value  
struct USLFunctionChunk:
    var fn_name: String
    var structure : USLShaderChunk
    
    fn __init__(inout self, fn_name: String):
        self.fn_name = fn_name
        self.structure = USLShaderChunk()

        self.structure.setShaderTypeGLSL()
        self.structure.defineShaderStructure("<ret_type> <fn_name>(<args[]>) {\n\t<code>\n}")
        self.structure.insertTag('fn_name', self.fn_name)

    fn add_argument(inout self, arg_type: String, arg_val: String):
        self.structure.insertArrayTags('args', arg_type + ' ' + arg_val, False)
    
    fn add_chunk(inout self, borrowed code_chunk: USLShaderChunk) raises:
        if not code_chunk.isCompiled:
            raise Error('Error at USLFunctionShader.add_chunk, provided chunk is unsafe. afterCompileSafety has not been called.')
        else:
            self.structure.insertTag('code', code_chunk.structure + '\t<code>\n')
    
    fn add_code(inout self, borrowed code_block: String):
        self.structure.insertTag('code', code_block + '<code>')

    fn set_ret_type(inout self, borrowed type: String):
        self.structure.insertTag('ret_type', type)

    fn afterCompileSafety(inout self) raises:
        self.structure.insertTag('code', '')
        self.structure.insertArrayTags('args', '', True)

        if '<ret_type>' in self.structure.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Return type has not been specified')
