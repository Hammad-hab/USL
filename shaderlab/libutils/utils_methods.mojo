fn btos(boolean: Bool) -> String:
    if boolean:
        return "True"
    else:
        return "False"


fn isAlphanum(string: String) -> String:
    var alphanum = List[String](
        str("A"),
        str("a"),
        str("B"),
        str("b"),
        str("C"),
        str("c"),
        str("D"),
        str("d"),
        str("E"),
        str("e"),
        str("F"),
        str("f"),
        str("G"),
        str("g"),
        str("H"),
        str("h"),
        str("I"),
        str("i"),
        str("J"),
        str("j"),
        str("K"),
        str("k"),
        str("L"),
        str("l"),
        str("M"),
        str("m"),
        str("N"),
        str("n"),
        str("O"),
        str("o"),
        str("P"),
        str("p"),
        str("Q"),
        str("q"),
        str("R"),
        str("r"),
        str("S"),
        str("s"),
        str("T"),
        str("t"),
        str("U"),
        str("u"),
        str("V"),
        str("v"),
        str("W"),
        str("w"),
        str("X"),
        str("x"),
        str("Y"),
        str("y"),
        str("Z"),
        str("z"),
    )

    if string in alphanum:
        # print(string)
        return True
    else:
        return False

fn repeatStr(string: String, ntimes:Int) -> String:
    var new_string: String = ""
    for i in range(ntimes):
        new_string += string
    return new_string

fn errorToString(error: Error) -> Tuple[Int, String]:
    try: 
        var arr = error._message().split(":")
        return Tuple(int(arr[0]), arr[1])
    except e:
        print("USL TRACEBACK FAILURE CRITICAL. CANNOT RETAIN ERROR FROM LEXER")
        var a: String= "USL TRACEBACK FAILURE CRITICAL. CANNOT RETAIN ERROR FROM LEXER"
        return (0, a)
    ...