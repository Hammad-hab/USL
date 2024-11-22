from python import Python, PythonObject
from . import ProgramSource
from .libutils import Tracker


fn __shader_bind_call_check(
    token: PythonObject, owned tracker: Tracker
) raises -> Bool:
    if token["type"] == "CallExpression":
        # Shaders don't support recursion! and they probably shouldn't
        # DISABLED:
        # if subtkn['name'] == token['name']:
        # prgm.warn(subtkn['line'] + 1, 'Recrusion is quite dangerous and can produce problems. Using it is not recommended and doing so will be prevented in future versions. If you want iterative behavior, try using functions from libloops.');
        # WOW! A function, Let's see if it has been declared before:
        if tracker.hasTracker(token["name"]):
            return True
        # OUCH! You seem to be referencing a function that doesn't exist, RAISE THE ALARMS!
        return False
    return False
    ...


fn __shader_bind_idntf_check(
    token: PythonObject, owned tracker: Tracker
) raises -> Bool:
    if token["type"] == "IdentifierRef":
        # Found a variable, let's see if it has been tracked
        if tracker.hasTracker(token["name"]):
            return True
        else:
            # OUCH! You seem to be referencing a function that doesn't exist, RAISE THE ALARMS!
            return False
    return False


fn __shader_bind_fn_contents_check(
    token: PythonObject,
    owned tracker: Tracker,
    prgm: ProgramSource,
    vertex_fn: String,
    fragment_fn: String,
) raises:
    if token["type"] == "CallExpression":
        var res = __shader_bind_call_check(token, tracker)
        if not res:
            prgm.throw(
                prgm,
                token["line"] + 1,
                "Attempting to call undefined function '"
                + str(token["name"])
                + "'",
            )
        for subtkn in token["args"]:
            __shader_bind_fn_contents_check(
                subtkn, tracker, prgm, vertex_fn, fragment_fn
            )

    if token["type"] == "IdentifierRef":
        # Found a variable, let's see if it has been tracked
        var res = __shader_bind_idntf_check(token, tracker)
        if not res:
            # OUCH! You seem to be referencing a function that doesn't exist, RAISE THE ALARMS!
            prgm.throw(
                prgm,
                token["line"] + 1,
                "Attempting to reference undefined variable '"
                + str(token["name"])
                + "'",
            )

    if token["type"] == "VariableDeclaration":
        # Nevermind, the found function wasn't the main function, You should still track it though...
        var var_value = token["value"]
        if var_value["type"] == "CallExpression":
            var dtype = tracker.getTrackerType(var_value["name"])
            if dtype != str(token["vartype"]):
                prgm.throw(
                    prgm,
                    var_value["line"] + 1,
                    "Type mismatched. Function returns '"
                    + dtype
                    + "' but the variable expects '"
                    + str(token["vartype"])
                    + "'",
                )
            tracker.addTracker("VARIABLE", str(token["name"]), dtype)
            for subtkn in var_value["args"]:
                __shader_bind_fn_contents_check(
                    subtkn, tracker, prgm, vertex_fn, fragment_fn
                )
        else:
            tracker.addTracker("VARIABLE", str(token["name"]), "nxqt")


fn _shader_bind_checks(
    prs_result: PythonObject,
    vertex_fn: String,
    fragment_fn: String,
    prgm: ProgramSource,
) raises:
    var main_tracker = Tracker()

    for token in prs_result:
        if token["type"] == "CONSTRUCT" and token["name"] == "supposedef":
            main_tracker.addTracker(
                str(token["arg0"]), str(token["arg1"]), "nxqt"
            )
            continue
            ...

        if token["type"] == "FunctionDeclaration":
            main_tracker.addTracker(
                "FUNCTION", str(token["name"]), str(token["dtype"])
            )
            # You found the shader's main function, keep it in mind....
            for subtkn in token["body"]:
                __shader_bind_fn_contents_check(
                    subtkn, main_tracker, prgm, vertex_fn, fragment_fn
                )
                ...


fn ShaderBind(
    prs_result: PythonObject, prgm: ProgramSource
) raises -> Tuple[String, String]:
    var shader_a = prs_result[0]
    var shader_b = prs_result[1]
    var vertex_fn: PythonObject = ""
    var fragment_fn: PythonObject = ""

    if shader_a["type"] != "CONSTRUCT" or shader_b["type"] != "CONSTRUCT":
        prgm.throw(
            prgm,
            0,
            (
                "No shader types defined. You need to bind functions for"
                " fragment and vertex shader."
            ),
        )

    if shader_a["arg0"] == "VERTEX":
        vertex_fn = shader_a["arg1"]
        fragment_fn = shader_b["arg1"]
    else:
        vertex_fn = shader_b["arg1"]
        fragment_fn = shader_a["arg1"]

    # This function breaks the transpilation process
    _shader_bind_checks(prs_result, str(vertex_fn), str(fragment_fn), prgm)

    return Tuple[String, String](str(vertex_fn), str(fragment_fn))
