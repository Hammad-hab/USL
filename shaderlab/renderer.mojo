from python import Python, PythonObject

struct Renderer:
    var screen: PythonObject
    var display: PythonObject
    var modgl_ctx: PythonObject
    var quad: PythonObject

    fn __init__(inout self, version:Int=330) raises:
        var modgl = Python.import_module('moderngl')
        var pygame = Python.import_module('pygame')
        var array = Python.import_module('array')

        pygame.init()
        pygame.display.gl_set_attribute(pygame.GL_CONTEXT_MAJOR_VERSION, 3)
        pygame.display.gl_set_attribute(pygame.GL_CONTEXT_MINOR_VERSION, 3)
        pygame.display.gl_set_attribute(pygame.GL_CONTEXT_PROFILE_MASK, pygame.GL_CONTEXT_PROFILE_CORE)
        pygame.display.gl_set_attribute(pygame.GL_CONTEXT_FORWARD_COMPATIBLE_FLAG, True)

        self.screen = pygame.display.set_mode((800, 600), pygame.OPENGL | pygame.DOUBLEBUF)
        self.display = pygame.Surface((800, 600))
        self.modgl_ctx = modgl.create_context(version)

        self.quad =  self.modgl_ctx.buffer(data=array.array('f',
            -1.0, 1.0, 0.0, 0.0,  # topleft
            1.0, 1.0, 1.0, 0.0,   # topright
            -1.0, -1.0, 0.0, 1.0, # bottomleft
            1.0, -1.0, 1.0, 1.0,  # bottomright
        ))

