from ShaderChunk import USLShaderChunk
from utils_methods import btos
fn main():
    print("Running Test: ShaderChunk.test\n")
    var chunk = USLShaderChunk()
    var testsSuccess = 0
    var totalTests = 3

    try:
        # Should Raise error
        chunk.afterCompileSafety()
        print("1. Error Check: Failed")
    except: 
        print("1. Error Check: Success")
        testsSuccess += 1
    
    chunk.setShaderTypeGLSL()
    if not chunk.isGLSL:
        print("2. Checking Chunk Type Failed, Check setShaderTypeGLSL")

    else:
        testsSuccess += 1
        print("2. Checking Chunk Type: Success")

    chunk.defineShaderStructure("<type> <name>(<arguments[]>) { <code_line> };")
    chunk.insertBakusNaurTag("<type>", "void")
    chunk.insertBakusNaurTag("<name>", "main")
    chunk.insertBakusNaurTag("<arguments[]>", "")
    chunk.insertBakusNaurTag("<code_line>", "printf('Hello world!')")

    if chunk.getStructure() !=  "void main() { printf('Hello world!') };":
        print("3. Structure Chunk Check failed, check code")
    else:
        print("3. Structure Chunk Check Succeeded.")
        testsSuccess += 1

    print("\nSuccessful Tests:")
    print(testsSuccess)
    print("\nFailed Tests:")
    print(totalTests - testsSuccess)