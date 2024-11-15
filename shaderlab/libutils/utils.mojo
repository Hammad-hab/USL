from . import ShaderOperation
from python import PythonObject

fn btos(boolean: Bool) -> String:
    if boolean:
        return "True"
    else:
        return "False"

fn repeatStr(string: String, ntimes:Int) -> String:
    var new_string: String = ""
    for i in range(ntimes):
        new_string += string
    return new_string

fn errorToString(error: Error) raises -> Tuple[Int, String]:
    try: 
        var arr = error._message().split(":")
        return Tuple(int(arr[0]), arr[1])
    except e:
        var a: String= "USL TRACEBACK FAILURE CRITICAL. CANNOT RETAIN ERROR FROM LEXER"
        raise error
        # return (0, a)
    ...

fn array_to_ptr(lst: List[ShaderOperation]) -> List[UnsafePointer[ShaderOperation]]:
    var list = List[UnsafePointer[ShaderOperation]]()
    for item in lst:
        var pointer: UnsafePointer[ShaderOperation] = UnsafePointer[ShaderOperation](item)
        list.append(pointer)

    return list