# from shaderlab import is_reserved

def is_reserved(any:str):
    return False

class Token:
    def __init__(self, type, value, line):
        self.type = type
        self.value = value
        self.line = line
    def __repr__(self):
        return f"Token({self.type}, \"{self.value}\")"


def SyntacticAnalysis(tokens: list[Token]):
    """
        This is an implementation of a Parser/Syntactic analyser.
        It is built purely in mojo and has various measures to ensure
        that the syntax is correct (unlike croton). 
        There are countless checks to ensure that strange and/or weird
        code doesn't make it to the actual transpiler.

        Takes in a list of tokens (See lexer.mojo)
       
        Currently supports: FunctionDeclarations, Variable Declarations
    """
    read_head = 0
    hasErrored = False
    operations = []
    
    
    while read_head < len(tokens) and not hasErrored:
        token = tokens[read_head]

        if token.type == 'Number':
            operations.append({'type': 'Number', 'value': token.value, 'line': token.line})
            read_head += 1
            continue

        if token.type == 'CONSTRUCT':
            construct_name = tokens[read_head + 1]
            if construct_name.value != 'Shaderbind':
                raise Exception(f'{construct_name.line + 1}: Reference to unknown construct @{construct_name.value}')
            argument_0 = tokens[read_head + 2]
            argument_1 = tokens[read_head + 3]

            if argument_0.value != 'VERTEX' and argument_0.value != 'FRAGMENT':
                raise Exception(f'{argument_0.line + 1}: Attempt to bind shader functions to unknown shader type {argument_0.value}')

            read_head += 4
            operation = {
                'type': 'SHADERBIND', 
                         'name': construct_name,
                         'arg0': argument_0,
                         'arg1': argument_1
            }
            operations.append(operation)
            continue

        if token.type == 'LEFT_BRACE_CUR' or token.type == 'RIGHT_BRACE_CUR':
            raise Exception(f'{token.line + 1}: Illegal use of token "{token.value}" at an unexpected place')


        if token.type == 'NAME' and token.value == 'var':
            var_name = tokens[read_head + 1]
            if is_reserved(var_name.value):
                raise Exception(f'{var_name.line + 1}: Illegal use of reserved keyword {var_name.value}')
                
            read_head += 3
            value = SyntacticAnalysis(tokens[read_head:])[0]
            read_head += 1
            operation = {'type': 'VariableDeclaration', 'name': var_name.value, 'value': value}
            operations.append(operation)
            continue
        
        if token.type == 'NAME' and token.value == 'fn':
            fn_name = tokens[read_head + 1]

            if is_reserved(fn_name.value):
                raise Exception(f'{fn_name.line + 1}: Illegal use of reserved keyword {fn_name.value}')

            if fn_name.type != 'NAME':
                raise Exception(f'{fn_name.line + 1}: Syntax Error: Function name missing after declaration')

            read_head += 2

            args = []
            contents = []

            if tokens[read_head].value != '(':
                raise Exception(f'{tokens[read_head].line + 1}: Syntax Error: Missing "(" after function declaration')
            
            read_head += 1
            while tokens[read_head].value != ')':
                tk = tokens[read_head]
                if tk.type == 'Number': 
                    raise Exception(f'{tk.line + 1}: Syntax Error: Got number as argument name')

                if tk.type == 'SYMB_COMA': 
                    read_head += 1
                    continue
                
                args.append(tk)
                read_head += 1
            
            read_head += 2

            if tokens[read_head - 1].value != '{':
                raise Exception(f'{tokens[read_head - 1].line + 1}: Syntax Error: Missing "\x7B" after function declaration')
            
            while tokens[read_head].value != '}':
                contents.append(tokens[read_head]) 
                read_head += 1
            
            
            if len(args) % 2 == 1:
                raise Exception(f'{args[-1].line + 1}: Syntax Error: Missing Type for Argument {args[-1].value}')
            
            read_head += 1
            operation = {'type': 'FunctionDeclaration', 'name': fn_name.value, 'args': args, 'body': SyntacticAnalysis(contents)}
            operations.append(operation)
            continue
        
        raise Exception(f'0: SNAFU: Unrecognised token found {token}. Kindly report at https://github.com/Hammad-hab/USL/issues with code sample')
    

    return operations