"""
    This package contains functions and types centred around transpiling USL to glsl.
    Following are descriptions of the corresponding files:

    - glsl_types.mojo : String Aliases for GLSL Types, providing accessibility for anyone who wants to interact with the
                        toolkit provided by the transpiler.
                        
    - libglsl_gen.mojo : For every supported shader langauge there is a lib<shader_language_name> folder along with a
                         lib<shader_language_name>_gen.mojo file containing a function that takes an AST and generates
                         the sourcecode of it's respective shader language
"""
