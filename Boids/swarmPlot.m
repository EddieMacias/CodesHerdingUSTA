function  Mobile_Graph = swarmPlot(population,obstacle)
    global  Swarm;

    %% Dibujar Agentes de Enjambre
    robotPatch = Swarm.Agent1Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(1,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(1,2);
    Mobile_Graph(1) = patch('Faces',Swarm.Agent1Faces,'Vertices',robotPatch','FaceColor', [0.3 0.75 0.93],'EdgeColor','none');
    
    robotPatch = Swarm.Agent2Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(2,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(2,2);
    Mobile_Graph(2) = patch('Faces',Swarm.Agent2Faces,'Vertices',robotPatch','FaceColor', [0.3 0.75 0.93],'EdgeColor','none');
    
    robotPatch = Swarm.Agent3Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(3,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(3,2);
    Mobile_Graph(3) = patch('Faces',Swarm.Agent3Faces,'Vertices',robotPatch','FaceColor', [0.3 0.75 0.93],'EdgeColor','none');
    
    robotPatch = Swarm.Agent4Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(4,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(4,2);
    Mobile_Graph(4) = patch('Faces',Swarm.Agent4Faces,'Vertices',robotPatch','FaceColor', [0.3 0.75 0.93],'EdgeColor','none');
    
    %% Dibujar Lider de enjambre
    robotPatch = Swarm.Agent5Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(5,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(5,2);
    Mobile_Graph(5) = patch('Faces',Swarm.Agent5Faces,'Vertices',robotPatch','FaceColor', 'r','EdgeColor','none');
    
    
    %% Dibujar pastores
    
    robotPatch = Swarm.Agent6Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(6,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(6,2);
    Mobile_Graph(6) = patch('Faces',Swarm.Agent3Faces,'Vertices',robotPatch','FaceColor', [0.8 0 1],'EdgeColor','none');
    
    robotPatch = Swarm.Agent7Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(7,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(7,2);
    Mobile_Graph(7) = patch('Faces',Swarm.Agent4Faces,'Vertices',robotPatch','FaceColor', [0.8 0 1],'EdgeColor','none');
    
    robotPatch = Swarm.Agent8Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ population(8,1);
    robotPatch(2,:)=robotPatch(2,:)+ population(8,2);
    Mobile_Graph(8) = patch('Faces',Swarm.Agent5Faces,'Vertices',robotPatch','FaceColor', [0.8 0 1],'EdgeColor','none');
    
    
    %% Dibujar Arboles
    
    robotPatch = Swarm.tree1Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ obstacle(1,1);
    robotPatch(2,:)=robotPatch(2,:)+ obstacle(1,2);
    Mobile_Graph(9) = patch('Faces',Swarm.tree1Faces,'Vertices',robotPatch','FaceColor', 'k','EdgeColor','none');
    
    robotPatch = Swarm.tree2Vertex;
    robotPatch(1,:)=robotPatch(1,:)+ obstacle(2,1);
    robotPatch(2,:)=robotPatch(2,:)+ obstacle(2,2);
    Mobile_Graph(10) = patch('Faces',Swarm.tree2Faces,'Vertices',robotPatch','FaceColor', 'k','EdgeColor','none');
    
    robotPatch = Swarm.tree3Vertex ;
    robotPatch(1,:)=robotPatch(1,:)+ obstacle(3,1);
    robotPatch(2,:)=robotPatch(2,:)+ obstacle(3,2);
    Mobile_Graph(11) = patch('Faces',Swarm.tree3Faces,'Vertices',robotPatch','FaceColor', 'k','EdgeColor','none');
