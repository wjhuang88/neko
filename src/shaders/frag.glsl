#version 450
layout(location = 0) in vec2 tex_coords;
layout(location = 0) out vec4 f_color;
layout(set = 0, binding = 0) uniform sampler2D tex;

float srgb_to_linear(float cs) {
    float cl;
    if (cs >= 1.0) {
        cl = 1.0;
    } else if (cs <= 0.0) {
        cl = 0.0;
    } else if (cs <= 0.04045) {
        cl = cs / 12.92;
    } else {
        cl = pow(((cs + 0.0555) / 1.055), 2.4);
    }

    return cl;
}
float linear_to_srgb(float cl) {
    float cs;
    if (cl >= 1.0) {
        cs = 1.0;
    } else if (cl <= 0.0) {
        cs = 0.0;
    } else if (cl <= 0.0031308) {
        cs = 12.92 * cl;
    } else {
        cs = 1.055 * pow(cl, 0.41666) - 0.055;
    }

    return cs;
}

void main() {
    vec4 cfin = texture(tex, tex_coords);
    vec4 cfout;
    cfout.x = linear_to_srgb(cfin.x);
    cfout.y = linear_to_srgb(cfin.y);
    cfout.z = linear_to_srgb(cfin.z);
    cfout.w = linear_to_srgb(cfin.w);

    f_color = cfout;
}