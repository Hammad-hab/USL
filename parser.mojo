from ExceptionTracer import ProgramSource
from shaderlab import Token, ShaderOperationVar
from shaderlab import is_reserved


fn SyntacticAnalysis(tokens: List[Token], Program: ProgramSource) raises -> List[ShaderOperationVar]:
    """
        This is an implementation of a Parser/Syntactic analyser.
        It is built purely in mojo and has various measures to ensure
        that the syntax is correct (unlike croton).


        Takes in a ProgramSource (See ExceptionTracer.mojo) object and a list of tokens (See lexer.mojo)
       
        Currently supports : FunctionDeclarations, Variable Declarations
    """
    var read_head = 0
    var hasErrored = False
    var operations: List[ShaderOperationVar] = List[ShaderOperationVar]()
    while read_head < len(tokens) and not hasErrored:
        var token = tokens[read_head]

        if token.type == 'LEFT_BRACE_CUR' or token.type == 'RIGHT_BRACE_CUR':
            ProgramSource.throw(Program, token.line + 1, 'Illegal use of token "' + token.value + '" at an unexpected place')
            hasErrored = True
            break

        if (token.type == 'NAME' and token.value == 'var'):
            var var_name = tokens[read_head + 1]
            if is_reserved(var_name.value):
                ProgramSource.throw(Program, var_name.line + 1, 'Illegal use of reserved keyword ' + var_name.value)
                hasErrored = True
                break
                
            read_head += 3
            var value = tokens[read_head]
            read_head += 1
            var rz = List[Token]()
            var operation = ShaderOperationVar(List[Token](value), var_name.value, rz, 'VariableDeclaration')
            operations.append(operation)
            continue
        
        if (token.type == 'NAME' and token.value == 'fn'):
            var fn_name = tokens[read_head + 1]

            if is_reserved(fn_name.value):
                ProgramSource.throw(Program, fn_name.line + 1, 'Illegal use of reserved keyword ' + fn_name.value)
                hasErrored = True
                break

            if fn_name.type != 'NAME':
                ProgramSource.throw(Program, fn_name.line + 1, 'Syntax Error: Function name missing after declaration')
                hasErrored = True
                break

            read_head += 2

            var args : List[Token] = List[Token]()
            var contents : List[Token] = List[Token]()

            if (tokens[read_head].value != '('):
                ProgramSource.throw(Program, tokens[read_head].line + 1, 'Syntax Error: Missing "(" after function declaration ')
                hasErrored = True
                break
            read_head += 1
            while tokens[read_head].value != ')':
                var tk = tokens[read_head]
                if tk.type == 'Number': 
                    ProgramSource.throw(Program, tk.line + 1, 'Syntax Error: Got number as argument name')
                    hasErrored = True
                    break
                

                if tk.type == 'SYMB_COMA': 
                    read_head += 1
                    continue
                
                args.append(tk)
                read_head += 1
            read_head += 2

            if (tokens[read_head - 1].value != '{'):
                ProgramSource.throw(Program, tokens[read_head -1].line + 1, 'Syntax Error: Missing "{" after function declaration ')
                hasErrored = True
                break
            while tokens[read_head].value != '}':
                contents.append(tokens[read_head]) 
                read_head += 1
                ...
            if hasErrored:
                break
            
            if len(args) % 2 == 1:
                ProgramSource.throw(Program, args[-1].line + 1, 'Syntax Error: Missing Type for Argument ' + args[-1].value)
                hasErrored = True
                break
            read_head += 1
            var operation = ShaderOperationVar(contents, fn_name.value, args, 'FunctionDeclaration')
            operations.append(operation)
            continue
        
        read_head += 1
    
    if hasErrored:
        print('\x1b[31mExiting Program at Parser due to the above error\n')
        raise Error('ProgramSource breakage')
        #    var contents: List[Token] = List[Token]()
        #    while value.value != '=':
        #          contents.append(value)
        #          read_head += 1
        #          value = tokens[read_head]
        #    print(contents[0].value, contents[1].value, contents[2].value)
        #    continue
        # read_head += 1
    return operations