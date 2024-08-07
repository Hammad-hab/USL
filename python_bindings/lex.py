import re

class Token:
    def __init__(self, type, value):
        self.type = type
        self.value = value

    def __repr__(self):
        return f"Token({self.type}, \"{self.value}\")"

class Lexer:
    def __init__(self, text):
        self.text = text
        self.pos = 0

    def tokenize(self):
        tokens = []
        while self.pos < len(self.text):
            char = self.text[self.pos]
            if char.isspace():
                self.pos += 1
                continue
            elif char.isalpha():
                tokens.append(self.lex_name())
            elif char.isdigit() or char == '.':
                tokens.append(self.lex_number())
            elif char in '(){}[]':
                tokens.append(self.lex_parenthesis())
            elif char in '*+-/=':
                tokens.append(self.lex_symbol())
            else:
                self.pos += 1  # Skip unrecognized characters
        return tokens

    def lex_name(self):
        result = re.match(r'[a-zA-Z][a-zA-Z0-9]*', self.text[self.pos:])
        self.pos += len(result.group(0))
        return Token("NAME", result.group(0))

    def lex_number(self):
        result = re.match(r'\d+(\.\d*)?|\.\d+', self.text[self.pos:])
        if result:
            self.pos += len(result.group(0))
            return Token("Number", result.group(0))
        else:
            self.pos += 1
            return None

    def lex_parenthesis(self):
        char = self.text[self.pos]
        self.pos += 1
        if char == '(':
            return Token("LEFT_PAREN", char)
        elif char == ')':
            return Token("RIGHT_PAREN", char)
        elif char == '{':
            return Token("LEFT_BRACE_CUR", char)
        elif char == '}':
            return Token("RIGHT_BRACE_CUR", char)
        elif char == '[':
            return Token("LEFT_BRACKET_SQ", char)
        elif char == ']':
            return Token("RIGHT_BRACKET_SQ", char)

    def lex_symbol(self):
        char = self.text[self.pos]
        self.pos += 1
        if char == '*':
            return Token("SYMB_MULTIPLY", char)
        elif char == '+':
            return Token("SYMB_PLUS", char)
        elif char == '-':
            return Token("SYMB_MINUS", char)
        elif char == '/':
            return Token("SYMB_DIVIDE", char)
        elif char == '=':
            return Token("SYMB_EQUALS", char)

def lex(text):
    lexer = Lexer(text)
    tokens = lexer.tokenize()
    return tokens

# Example usage
if __name__ == "__main__":
    text = "x = 3.14 * (y + 2) / [z - 1] {a + b}"
    result = lex(text)
    print(result)