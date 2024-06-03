function  SwarmFcn

load('crazyflie.mat');
global Swarm;

scale = 1/10;

Swarm.Agent1Vertex = cube.vertices'*scale;
Swarm.Agent1Faces = cube.faces;

Swarm.Agent2Vertex = cube.vertices'*scale;
Swarm.Agent2Faces = cube.faces;

Swarm.Agent3Vertex = cube.vertices'*scale;
Swarm.Agent3Faces = cube.faces;

Swarm.Agent4Vertex = cube.vertices'*scale;
Swarm.Agent4Faces = cube.faces;

Swarm.Agent5Vertex = cube.vertices'*scale;
Swarm.Agent5Faces = cube.faces;





