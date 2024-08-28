# Unified Shader Language (USL)

**USL** is a high-performance shader transpiler written in the Mojo programming language, designed to unify various shader languages into a single cohesive language. With USL, developers can write shaders in a standardized language and deploy them seamlessly across multiple platforms and graphics engines. The primary goal is to facilitate a smooth transition from WebGL to WebGPU.

## Features

- **Unified Language**: Write shaders once and deploy them anywhere.
- **High Performance**: Supa-fast translation and execution.
- **Extensible**: Supports multiple shader types, including vertex, fragment, and geometry.
- **Cross-Platform**: Compatible with various graphics engines and platforms.
- **Smooth Transition**: Eases the migration from WebGL to WebGPU.
- **One Shader to Rule Them All**: Consolidate all shader languages into a single, universal language.

## Sharp Edges

While USL aims to provide a seamless experience, there are some areas that may require caution:

* **Experimental Features**: Certain advanced features are still experimental and may not be fully stable.
* **Platform-Specific Bugs**: Some platform-specific issues may arise, especially during the transition from WebGL to WebGPU.
* **Performance Overheads**: While USL is optimized for speed, some complex shaders may introduce performance overheads during translation.

## Sample Shader

USL:

```ruby
# Import necessary modules with aliases
import trignometry
import calculas
import noise
import abstracted_datastructs

# Function to create an identity matrix of a given size
fn create_matrix(size) {
    return IdentityMatrix(size, size)
}

# Vertex shader function
# This function sets up the vertex shader with a 4x4 identity matrix
fn my_vertex_shader() {
    # shader logic
    return create_matrix(4)
}

# Fragment shader function
# This function sets the fragment shader color to white
fn my_fragment_shader() {
    # shader logic
    return Color4DHex(hex(ffffff))
}

# Specify shaders for each stage
@Shaderlib VERTEX my_vertex_shader
@Shaderlib FRAGMENT my_fragment_shader

```
GLSL:

```c
// Vertex Shader
#version 450

// Function to create a 4x4 identity matrix
mat4 create_matrix(int size) {
    return mat4(1.0);
}

// Main vertex shader function
void main() {
    // shader logic
    mat4 matrix = create_matrix(4);
    
    // Typical vertex shader operations (e.g., transforming positions)
    gl_Position = matrix * vec4(0.0, 0.0, 0.0, 1.0); // Example operation
}

// Fragment Shader
#version 450

// Function to return a color from a hex code
vec4 Color4DHex(int hex) {
    float r = float((hex >> 16) & 0xFF) / 255.0;
    float g = float((hex >> 8) & 0xFF) / 255.0;
    float b = float(hex & 0xFF) / 255.0;
    return vec4(r, g, b, 1.0);
}

// Main fragment shader function
void main() {
    // shader logic
    vec4 color = Color4DHex(0xFFFFFF);
    
    // Assign the color to the output
    gl_FragColor = color; // Example operation
}
```