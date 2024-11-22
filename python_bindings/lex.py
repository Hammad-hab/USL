import re
from parser import SyntacticAnalysis

class Token:
    def __init__(self, type, value, line):
        self.type = type
        self.value = value
        self.line = line
    def __repr__(self):
        return f"Token({self.type}, \"{self.value}\")"

class Lexer:
    def __init__(self, text:str):
        self.text = text.replace('\n', '%')
        self.pos = 0

    def tokenize(self):
        tokens = []
        self.nl = 0
        while self.pos < len(self.text):
            char = self.text[self.pos]
            if char == '%':
                self.nl += 1
                self.pos += 1
                continue
            if char.isspace():
                self.pos += 1
                continue
            elif char == '#':
                self.skip_comment()
            elif char == '@':
                tokens.append(self.lex_construct())
            elif char.isalpha() or char == '_':
                tokens.append(self.lex_name())
            elif char.isdigit() or char == '.':
                tokens.append(self.lex_number())
            elif char in '(){}[]':
                tokens.append(self.lex_parenthesis())
            elif char in '*+-/=,:':
                tokens.append(self.lex_symbol())
            else:
                self.pos += 1  # Skip unrecognized characters
                raise Exception(f'{self.nl + 1}:Unknown Token given as input to lexer, "{char}"')
        return tokens

    def skip_comment(self):
        while self.pos < len(self.text) and self.text[self.pos] != '%':
            self.pos += 1

    def lex_construct(self):
        self.pos += 1  # Skip the '@' symbol
        return Token("CONSTRUCT", "@", self.nl)

    def lex_name(self):
        result = re.match(r'[a-zA-Z_][a-zA-Z0-9_]*', self.text[self.pos:])
        self.pos += len(result.group(0))
        return Token("NAME", result.group(0), self.nl)

    def lex_number(self):
        result = re.match(r'\d+(\.\d*)?|\.\d+', self.text[self.pos:])
        if result:
            self.pos += len(result.group(0))
            return Token("Number", result.group(0), self.nl)
        else:
            self.pos += 1
            return None

    def lex_parenthesis(self):
        char = self.text[self.pos]
        self.pos += 1
        if char == '(':
            return Token("LEFT_PAREN", char, self.nl)
        elif char == ')':
            return Token("RIGHT_PAREN", char, self.nl)
        elif char == '{':
            return Token("LEFT_BRACE_CUR", char, self.nl)
        elif char == '}':
            return Token("RIGHT_BRACE_CUR", char, self.nl)
        elif char == '[':
            return Token("LEFT_BRACKET_SQ", char, self.nl)
        elif char == ']':
            return Token("RIGHT_BRACKET_SQ", char, self.nl)

    def lex_symbol(self):
        char = self.text[self.pos]
        self.pos += 1
        if char == '*':
            return Token("SYMB_MULTIPLY", char, self.nl)
        elif char == '+':
            return Token("SYMB_PLUS", char, self.nl)
        elif char == '-':
            return Token("SYMB_MINUS", char, self.nl)
        elif char == '/':
            return Token("SYMB_DIVIDE", char, self.nl)
        elif char == '=':
            return Token("SYMB_EQUALS", char, self.nl)
        elif char == ',':
            return Token("SYMB_COMA", char, self.nl)
        elif char == ':':
            return Token("SYMB_COLON", char, self.nl)

def lex(text):
    lexer = Lexer(text)
    tokens = lexer.tokenize()
    return tokens

def exit_():
    exit(-1)

if __name__ == '__main__':
    SyntacticAnalysis(lex("""
            x(f(z()))
    """))
    
    