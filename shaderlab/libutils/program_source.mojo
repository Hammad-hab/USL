"""
    TODO: Implement transpiler errors in mojo
"""
from shaderlab import repeatStr
from shaderlab.config import *

struct ProgramSource:
    
    var shader: String
    var shaderSourceArray: List[String]
    var programDidError: Bool

    fn __init__(inout self, shader:String) raises:
        self.shader = shader.strip()
        self.shaderSourceArray = str(shader.strip()).split("\n")
        self.programDidError = False

    fn __copyinit__(inout self, existing: Self):
        self.shader = existing.shader
        self.shaderSourceArray = existing.shaderSourceArray
        self.programDidError = existing.programDidError

    @staticmethod
    def throw(self:ProgramSource,  line:Int, errorMsg:String) -> None:
        line -= 1
        self.programDidError = True
        var string : String = ""
        if (self.shaderSourceArray[line - 1]):
            string += "\t|" + str(line) + "|" + self.shaderSourceArray[line - 1] + "\n"
        var error = "\t\b→|" + str(line + 1) + "|" + self.shaderSourceArray[line] + "\n"
        string += error + "\t" + "|" + repeatStr("*", len("|" + str(line+1) + "|") - 2) + "|" + repeatStr("^", len(error) - len("|" + str(line+1) + "|") - 2) + "\n"
        if (self.shaderSourceArray[line + 1]):
            string += '\t|' + str(line + 2) + "|" + self.shaderSourceArray[line + 1] + "\n"
        print("\x1b[31mTranspilation Failed, Line: " + str(line + 1) + ":\n" + string + "\nWith Error: \n\t╰→ " + errorMsg + "\x1b[0m")
        if ERROR_MODE != 'compiler':
            raise Error('Exiting Transpiler due to above error.')
        ...

    def warn(self:ProgramSource,  line:Int, errorMsg:String) -> None:
        line -= 1
        self.programDidError = True
        var string : String = ""
        if (self.shaderSourceArray[line - 1]):
            string += "\t|" + str(line) + "|" + self.shaderSourceArray[line - 1] + "\n"
        var error = "\t\b→|" + str(line + 1) + "|" + self.shaderSourceArray[line] + "\n"
        string += error + "\t" + "|" + repeatStr("*", len("|" + str(line+1) + "|") - 2) + "|" + repeatStr("^", len(error) - len("|" + str(line+1) + "|") - 2) + "\n"
        if (self.shaderSourceArray[line + 1]):
            string += '\t|' + str(line + 2) + "|" + self.shaderSourceArray[line + 1] + "\n"
        print("\x1b[33mTranspilation Raised Warning, Line: " + str(line + 1) + ":\n" + string + "\nWith Warning: \n\t╰→ " + errorMsg + "\x1b[0m")
        ...

    def endProgram(inout self):
        if self.programDidError and ERROR_MODE == 'compiler':
            raise Error("Transpilation Failed due to the above errors.")
        ...