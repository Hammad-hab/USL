from . import USLShaderChunk

@value
struct USLVariableChunk:
    var var_name: String
    var structure : USLShaderChunk
    
    fn __init__(inout self, var_name: String):
        self.var_name = var_name
        self.structure = USLShaderChunk()

        self.structure.setShaderTypeGLSL()
        self.structure.defineShaderStructure("<var_type> <var_name> = <var_value>")
        self.structure.insertTag('var_name', self.var_name)
    
    fn set_var_type(inout self, borrowed type: String):
        self.structure.insertTag('var_type', type)

    fn set_val(inout self, borrowed value: String):
        self.structure.insertTag('var_value', value)

    fn afterCompileSafety(inout self) raises:
        if '<var_value>' in self.structure.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Variable value  has not been specified')
        if '<var_type>' in self.structure.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Return type has not been specified')