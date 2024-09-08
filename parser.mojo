# from ExceptionTracer import ProgramSource
# from shaderlab import Token, ShaderOperationVar
# from shaderlab import is_reserved
# from python import Python


# fn SyntacticAnalysis(tokens: List[Token], Program: ProgramSource) raises -> None:
#     """
#         This is an implementation of a Parser/Syntactic analyser.
#         It is built purely in mojo and has various measures to ensure
#         that the syntax is correct (unlike croton). 
#         There are countless checks to ensure that strange and/or weird
#         code doesn't make it to the actual transpiler.


#         Takes in a ProgramSource (See ExceptionTracer.mojo) object and a list of tokens (See lexer.mojo)
       
#         Currently supports : FunctionDeclarations, Variable Declarations
#     """
#     Python.add_to_path("./python_bindings")
#     var libprs = Python.import_module('parser')
#     var i = 0
#     while i < len(tokens):
#         var token = tokens[i]
#         var obj = Token.to_PythonObject(token)
#         # lst.append(obj)
#         i += 1
#     print(libprs.SyntacticAnalysis(tokens))
#     # var read_head = 0
#     # var hasErrored = False
#     # var operations: List[ShaderOperationVar] = List[ShaderOperationVar]()
#     # while read_head < len(tokens) and not hasErrored:
#     #     var token = tokens[read_head]

#     #     if token.type == 'CONSTRUCT':
#     #        var construct_name = tokens[read_head + 1]
#     #        if construct_name.value != 'Shaderbind':
#     #             ProgramSource.throw(Program, token.line + 1, 'Reference to unknown construct @' + construct_name.value)
#     #             hasErrored = True
#     #             break
#     #        var argument_0 = tokens[read_head + 2]
#     #        var argument_1 = tokens[read_head + 3]

#     #        if argument_0.value != 'VERTEX'and argument_0.value != 'FRAGMENT':
#     #             ProgramSource.throw(Program, argument_0.line + 1, 'Attempt to bind shader functions to unknown shader type ' + argument_0.value)
#     #             hasErrored = True
#     #             break


#     #        read_head += 4
#     #        var operation = ShaderOperationVar(List[Token](construct_name, argument_0, argument_1), 'SHADERBIND', List[Token](), 'CONSTRUCT')
#     #        operations.append(operation)
#     #        continue

#     #     if token.type == 'LEFT_BRACE_CUR' or token.type == 'RIGHT_BRACE_CUR':
#     #         ProgramSource.throw(Program, token.line + 1, 'Illegal use of token "' + token.value + '" at an unexpected place')
#     #         hasErrored = True
#     #         break

#     #     if token.type == 'NAME' and not is_reserved(token.value):
#     #         ProgramSource.warn(Program, token.line + 1, 'Unused and unexpected token "' + token.value + '". Such phantom entries can cause problems in transpilation.')
#     #         read_head += 1
#     #         continue

#     #     if (token.type == 'NAME' and token.value == 'var'):
#     #         var var_name = tokens[read_head + 1]
#     #         if is_reserved(var_name.value):
#     #             ProgramSource.throw(Program, var_name.line + 1, 'Illegal use of reserved keyword ' + var_name.value)
#     #             hasErrored = True
#     #             break
                
#     #         read_head += 3
#     #         var value = tokens[read_head]
#     #         read_head += 1
#     #         var rz = List[Token]()
#     #         var operation = ShaderOperationVar(List[Token](value), var_name.value, rz, 'VariableDeclaration')
#     #         operations.append(operation)
#     #         continue
        
#     #     if (token.type == 'NAME' and token.value == 'fn'):
#     #         var fn_name = tokens[read_head + 1]

#     #         if is_reserved(fn_name.value):
#     #             ProgramSource.throw(Program, fn_name.line + 1, 'Illegal use of reserved keyword ' + fn_name.value)
#     #             hasErrored = True
#     #             break

#     #         if fn_name.type != 'NAME':
#     #             ProgramSource.throw(Program, fn_name.line + 1, 'Syntax Error: Function name missing after declaration')
#     #             hasErrored = True
#     #             break

#     #         read_head += 2

#     #         var args : List[Token] = List[Token]()
#     #         var contents : List[Token] = List[Token]()

#     #         if (tokens[read_head].value != '('):
#     #             ProgramSource.throw(Program, tokens[read_head].line + 1, 'Syntax Error: Missing "(" after function declaration ')
#     #             hasErrored = True
#     #             break
#     #         read_head += 1
#     #         while tokens[read_head].value != ')':
#     #             var tk = tokens[read_head]
#     #             if tk.type == 'Number': 
#     #                 ProgramSource.throw(Program, tk.line + 1, 'Syntax Error: Got number as argument name')
#     #                 hasErrored = True
#     #                 break
                

#     #             if tk.type == 'SYMB_COMA': 
#     #                 read_head += 1
#     #                 continue
                
#     #             args.append(tk)
#     #             read_head += 1
#     #         read_head += 2

#     #         if (tokens[read_head - 1].value != '{'):
#     #             ProgramSource.throw(Program, tokens[read_head -1].line + 1, 'Syntax Error: Missing "{" after function declaration ')
#     #             hasErrored = True
#     #             break
#     #         while tokens[read_head].value != '}':
#     #             contents.append(tokens[read_head]) 
#     #             read_head += 1
#     #             ...
#     #         if hasErrored:
#     #             break
            
#     #         if len(args) % 2 == 1:
#     #             ProgramSource.throw(Program, args[-1].line + 1, 'Syntax Error: Missing Type for Argument ' + args[-1].value)
#     #             hasErrored = True
#     #             break
#     #         read_head += 1
#     #         var operation = ShaderOperationVar(contents, fn_name.value, args, 'FunctionDeclaration')
#     #         operations.append(operation)
#     #         continue
        
#     #     ProgramSource.throw(Program, 0, 'SNAFU: Unrecognised token found. Kindly report at https://github.com/Hammad-hab/USL/issues with code sample')
#     #     hasErrored = True
#     #     break
    
#     # if hasErrored:
#     #     print('\x1b[31mExiting Program at Parser due to the above error\n')
#     #     raise Error('ProgramSource breakage')
#     #     #    var contents: List[Token] = List[Token]()
#     #     #    while value.value != '=':
#     #     #          contents.append(value)
#     #     #          read_head += 1
#     #     #          value = tokens[read_head]
#     #     #    print(contents[0].value, contents[1].value, contents[2].value)
#     #     #    continue
#     #     # read_head += 1
#     # return operations