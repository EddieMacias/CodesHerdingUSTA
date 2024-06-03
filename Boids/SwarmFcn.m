function  SwarmFcn

    load('crazyflie.mat');
    load('arbol.mat')
    
    global Swarm;
    
    scale = 1;
    scaleTree = 10;
    
    %% Agents
    Swarm.Agent1Vertex = cube.vertices'*scale;
    Swarm.Agent1Faces  = cube.faces;
    
    Swarm.Agent2Vertex = cube.vertices'*scale;
    Swarm.Agent2Faces  = cube.faces;
    
    Swarm.Agent3Vertex = cube.vertices'*scale;
    Swarm.Agent3Faces  = cube.faces;
    
    Swarm.Agent4Vertex = cube.vertices'*scale;
    Swarm.Agent4Faces  = cube.faces;
    
    %% Leader
    Swarm.Agent5Vertex = cube.vertices'*scale;
    Swarm.Agent5Faces  = cube.faces;
    
    %% Herding
    Swarm.Agent6Vertex = cube.vertices'*scale;
    Swarm.Agent6Faces  = cube.faces;
    
    Swarm.Agent7Vertex = cube.vertices'*scale;
    Swarm.Agent7Faces  = cube.faces;
    
    Swarm.Agent8Vertex = cube.vertices'*scale;
    Swarm.Agent8Faces  = cube.faces;
    
    %% Obstacles
    Swarm.tree1Vertex = arbol.vertices'*scaleTree;
    Swarm.tree1Faces  = arbol.faces;
    
    Swarm.tree2Vertex = arbol.vertices'*scaleTree;
    Swarm.tree2Faces  = arbol.faces;
    
    Swarm.tree3Vertex = arbol.vertices'*scaleTree;
    Swarm.tree3Faces  = arbol.faces;






