#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform float u_brightness;

void main()
{
    vec4 textureColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
    gl_FragColor = vec4((textureColor.rgb * u_brightness), textureColor.w);

}