from utils_methods import btos

struct USLShaderChunk:
    var structure : String
    var isGLSL: Bool
    var isHLSL: Bool
    var isWSGL: Bool

    fn __init__(inout self):
        self.isGLSL = False
        self.isHLSL = False
        self.isWSGL = False
        self.structure = "NULL"

    fn defineShaderStructure(inout self, owned shaderStructure:String):
        """
            Shader Structures are string literals with <key-value> form that
            is similar to the Bakus-Naur format. It is a command given to the 
            transpiler so that it can be converted into the corresponding Language.
        """
        self.structure = shaderStructure
        ...

    fn insertBakusNaurTag(inout self, tag: String, replace: String):
        self.structure = self.structure.replace(tag, replace)

    
    fn setShaderTypeGLSL(inout self):
        self.isGLSL = True
    
    fn setShaderTypeHLSL(inout self):
        self.isHLSL = True

    fn setShaderTypeWSGL(inout self):
        self.isWSGL = True

    fn afterCompileSafety(inout self) raises:
        """
            Has to be called after every USLShaderChunk is compiled to ensure that
            no invalid or weird type is passed into the system.
            Raises error if there is an invalid statement.
        """

        if self.structure != "NULL" and len(self.structure.strip()) > 0 and (self.isGLSL or self.isHLSL or self.isWSGL):
           return
        else:
           raise Error("Error at USLShaderChunk.afterCompileSafety. Check the following fields: \n\t" + self.structure + "\n\t" +  btos(self.isGLSL) + "\n\t" + btos(self.isHLSL) + "\n\t" + btos(self.isWSGL))
        
    fn getStructure(inout self) -> String:
        return self.structure