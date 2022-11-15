uniform vec3 ambientColor;
uniform float kAmbient;

uniform vec3 diffuseColor;
uniform float kDiffuse;

uniform vec3 specularColor;
uniform float kSpecular;
uniform float shininess;

uniform mat4 modelMatrix;

uniform vec3 spherePosition;

// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 viewPosition;
in vec3 worldPosition;


vec3 calculateAmbient(){
    return ambientColor*kAmbient;
}

vec3 calculateDiffuse(vec3 normal, vec3 lightDirection){
    return diffuseColor*max(0.0, dot(normal, normalize(spherePosition - worldPosition)))*kDiffuse;
}


vec3 calculateSpecular(vec3 normal, vec3 lightDirection){
    // HINT: Make sure to use the Jim Blinn's modification to the Phong Model (Blinn-Phong reflectance)
    // See textbook, Section 14.3

    vec3 toV = -normalize(vec3(viewPosition));
    vec3 h = normalize(toV - lightDirection); // halfway vector

    return kSpecular*pow(max(0.0, dot(h, normalize(mat3(modelMatrix)*normal))), shininess)*specularColor;
}

void main() {



    vec3 normal = normalize(mat3(transpose(inverse(modelMatrix))) * interpolatedNormal);


    vec3 lightDirection = normalize(spherePosition - worldPosition);

    // HINT: Implement the following 3 functions
    vec3 out_Ambient = calculateAmbient();
    vec3 out_Diffuse = calculateDiffuse(normal, lightDirection);
    vec3 out_Specular = calculateSpecular(normal, lightDirection);

    vec3 out_Color = out_Ambient + out_Specular + out_Diffuse;

    gl_FragColor = vec4(clamp(out_Color, 0.0, 1.0), 1.0);
}
