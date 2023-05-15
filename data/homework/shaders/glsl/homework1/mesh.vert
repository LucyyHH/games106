#version 450

layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inColor;
layout (location = 4) in vec4 inTangent;
layout (location = 5) in vec4 inJointIndices;
layout (location = 6) in vec4 inJointWeights;

layout (set = 0, binding = 0) uniform UBOScene
{
	mat4 projection;
	mat4 view;
	vec4 lightPos;
	vec4 viewPos;
	vec3 camPos;
} uboScene;

layout(push_constant) uniform PushConsts {
	mat4 model;
} primitive;

layout(std430, set = 1, binding = 0) readonly buffer JointMatrices {
	mat4 jointMatrices[];
};

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec2 outUV;
layout (location = 3) out vec3 outViewVec;
layout (location = 4) out vec3 outLightVec;
layout (location = 5) out vec3 outWorldPos;
layout (location = 6) out vec4 outTangent;

void main() 
{
	outColor = inColor;
	outUV = inUV;

	outWorldPos = vec3(primitive.model * vec4(inPos.xyz, 1.0));
	gl_Position = uboScene.projection * uboScene.view * primitive.model * vec4(inPos.xyz, 1.0);

	outNormal = mat3(primitive.model) * inNormal;
	outTangent = vec4(mat3(primitive.model) * inTangent.xyz, inTangent.w);

	outLightVec = uboScene.lightPos.xyz - outWorldPos;
	outViewVec = uboScene.viewPos.xyz - outWorldPos;
}