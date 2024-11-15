from python import Python, PythonObject
from . import ProgramSource
from .libutils import Tracker

fn  ShaderBind(prs_result: PythonObject, prgm:ProgramSource) raises:
    """
        TODO: ADD VALIDATION FOR ARGUMENTS (FUNCTION).
    """
    var shader_a = prs_result[0]
    var shader_b = prs_result[1]
    var vertex_fn: PythonObject = ''
    var fragment_fn: PythonObject = ''

    var main_tracker = Tracker()
    if (shader_a['type'] != 'Construct' or shader_b['type'] != 'Construct'):
        prgm.throw(prgm, 0, 'No shader types defined. You need to bind functions for fragment and vertex shader.')

    if (shader_a['arg0'] == 'VERTEX'):
        vertex_fn = shader_a['arg1']
        fragment_fn = shader_b['arg1']
    else:
        vertex_fn = shader_b['arg1']
        fragment_fn = shader_a['arg1']

    
    for token in prs_result:
        if token['type'] == 'Construct' and token['name'] == 'supposedef':
            main_tracker.addTracker(str(token['arg0']), str(token['arg1']))
            continue
            ...
            
        if token['type'] == 'FunctionDeclaration' and token['name'] == vertex_fn or token['name'] == fragment_fn:
            # You found the shader's main function, keep it in mind....
            for subtkn in token['body']:
                if subtkn['type'] == 'CallExperession':
                    # WOW! A function, Let's see if it has been declared before:
                    if main_tracker.hasTracker(subtkn['name']):
                        continue
                    else:
                        # OUCH! You seem to be referencing a function that doesn't exist, RAISE THE ALARMS!
                        prgm.throw(prgm, subtkn['line'] + 1, "Attempting to call undefined function '" + str(subtkn['name']) + "'")

                if subtkn['type'] == 'Variable':
                    # Found a variable, let's see if it has been tracked
                    if main_tracker.hasTracker(subtkn['name']):
                        continue
                    else:
                        # OUCH! You seem to be referencing a function that doesn't exist, RAISE THE ALARMS!
                        prgm.throw(prgm, subtkn['line'] + 1, "Attempting to reference undefined variable '" + str(subtkn['name']) + "'")

            break
        elif token['type'] == 'FunctionDeclaration':
            # Nevermind, the found function wasn't the main function, You should still track it though...
            main_tracker.addTracker('FUNCTION', str(token['name']))
            continue

        if token['type'] == 'VariableDeclaration':
            # Nevermind, the found function wasn't the main function, You should still track it though...
            main_tracker.addTracker('VARIABLE', str(token['name']))
