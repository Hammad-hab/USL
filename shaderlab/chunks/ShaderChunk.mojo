from ..libutils.utils import btos

@value
struct USLShaderChunk:
    var structure : String
    var isGLSL: Bool
    var isHLSL: Bool
    var isWSGL: Bool
    var isCompiled: Bool


    fn __init__(inout self):
        self.isGLSL = False
        self.isHLSL = False
        self.isWSGL = False
        self.structure = "NULL"
        self.isCompiled = False
    
    fn __copyinit__(inout self, copied: Self):
        self.structure = copied.structure
        self.isGLSL = copied.isGLSL
        self.isHLSL = copied.isHLSL
        self.isWSGL = copied.isWSGL
        self.isCompiled = copied.isCompiled
        


    fn defineShaderStructure(inout self, owned shaderStructure:String):
        """
            Shader Structures are string literals with <key-value> form that
            is similar to the Bakus-Naur format. It is a command given to the 
            transpiler so that it can be converted into the corresponding Language.
        """
        self.structure = shaderStructure
        ...

    fn insertTag(inout self, tag: String, replace: String):
        self.structure = self.structure.replace('<' + tag + '>', replace)

    fn insertArrayTags(inout self, tag: String, replace: String, lastElement: Bool):
        if not lastElement:
            self.structure = self.structure.replace('<' + tag + '[]>', replace + '<' + tag + '[]>')
        else:
            self.structure = self.structure.replace('<' + tag + '[]>', replace)

    
    fn setShaderTypeGLSL(inout self):
        self.isGLSL = True
    
    fn setShaderTypeHLSL(inout self):
        self.isHLSL = True

    fn setShaderTypeWSGL(inout self):
        self.isWSGL = True
    
    fn nullify(inout self):
        self.structure = ''
        
    fn afterCompileSafety(inout self) raises:
        """
            Has to be called after every USLShaderChunk is compiled to ensure that
            no invalid or weird type is passed into the system.
            Raises error if there is an invalid statement.
        """ 
        if self.structure != "NULL" and (self.isGLSL or self.isHLSL or self.isWSGL):
           self.isCompiled = True
           return
        else:
           raise Error("Error at USLShaderChunk.afterCompileSafety. Check the following fields: \n\t" + self.structure + "\n\t" +  btos(self.isGLSL) + "\n\t" + btos(self.isHLSL) + "\n\t" + btos(self.isWSGL))
        
    fn getStructure(inout self) -> String:
        var st = self.structure
        return st


    fn superDangerousAppend(inout self, owned append: String):
        if self.structure == 'NULL':
            self.structure = ''
        self.structure += append + ';\n'

    fn superDangerousPrepend(inout self, owned prepend: String):
        self.structure = prepend + self.structure + ';\n'