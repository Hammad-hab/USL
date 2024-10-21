from .ShaderChunk import USLShaderChunk


struct USLVariableShader:
    var var_name: String
    var bakus_naur : USLShaderChunk
    
    fn __init__(inout self, var_name: String):
        self.var_name = var_name
        self.bakus_naur = USLShaderChunk()

        self.bakus_naur.setShaderTypeGLSL()
        self.bakus_naur.defineShaderStructure("<var_type> <var_name> = <var_value>")
        self.bakus_naur.insertBakusNaurTag('var_name', self.var_name)
    
    fn set_var_type(inout self, borrowed type: String):
        self.bakus_naur.insertBakusNaurTag('var_type', type)

    fn set_val(inout self, borrowed value: String):
        self.bakus_naur.insertBakusNaurTag('var_value', value)

    fn afterCompileSafety(inout self) raises:
        if '<var_value>' in self.bakus_naur.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Variable value  has not been specified')
        if '<var_type>' in self.bakus_naur.structure:
            raise Error('Error at USLFunctionShader.afterCompileSafety. Return type has not been specified')
