from shaderlab import repeatStr
import sys

struct ProgramSource:
    var shader: String
    var shaderSourceArray: List[String]

    def __init__(inout self, shader:String):
        self.shader = shader.strip()
        self.shaderSourceArray = shader.strip().split("\n")

        
    @staticmethod
    def throw(self:ProgramSource,  line:Int, errorMsg:String) -> None:
        line -= 1
        var string : String = ""
        if (self.shaderSourceArray[line - 1]):
            string += "\t|" + str(line) + "|" + self.shaderSourceArray[line - 1] + "\n"
        var error = "\t\b→|" + str(line + 1) + "|" + self.shaderSourceArray[line] + "\n"
        string += error + "\t" + "|" + repeatStr("*", len("|" + str(line+1) + "|") - 2) + "|" + repeatStr("^", len(error) - len("|" + str(line+1) + "|") - 2) + "\n"
        if (self.shaderSourceArray[line + 1]):
            string += '\t|' + str(line + 2) + "|" + self.shaderSourceArray[line + 1] + "\n"
        print("\x1b[31mTranspilation Failed, Line: " + str(line + 1) + ":\n" + string + "\nWith Error: \n\t╰→ " + errorMsg + "\x1b[0m")
        sys.exit()
        ...