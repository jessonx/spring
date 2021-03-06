#version 410 core

uniform sampler2D reflmap_tex; // TU0
uniform sampler2D bumpmap_tex; // TU1

uniform vec2 u_forward_vec; // x,z,0,0
uniform vec3 u_gamma_expon;

in vec4 v_color_rgba;
in vec2 v_reflmap_tc;
in vec2 v_bumpmap_tc;

const vec4 bumpmap_add = vec4(-0.50, -0.50, 0.0, 0.0);
const vec2 bumpmap_mul = vec2( 0.02,  0.02          );

layout(location = 0) out vec4 f_frag_color;

void main() {
	vec4 bumpmap_texel = texture(bumpmap_tex, v_bumpmap_tc);
	vec4 reflmap_texel;

	vec2 tex_coor_ofs;
	vec4 vertex_color = v_color_rgba;

	tex_coor_ofs.x = dot(bumpmap_texel + bumpmap_add, vec4( u_forward_vec.y, u_forward_vec.x, 0.0, 0.0));
	tex_coor_ofs.y = dot(bumpmap_texel + bumpmap_add, vec4(-u_forward_vec.x, u_forward_vec.y, 0.0, 0.0));
	vertex_color.a += (tex_coor_ofs.y * 0.03);

	// dependent lookup
	reflmap_texel = texture(reflmap_tex, v_reflmap_tc + tex_coor_ofs * bumpmap_mul);
	f_frag_color = reflmap_texel * vertex_color;

	f_frag_color.rgb = pow(f_frag_color.rgb, u_gamma_expon);
}

