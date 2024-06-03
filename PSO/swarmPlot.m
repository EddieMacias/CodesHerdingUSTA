function  Mobile_Graph = swarmPlot(population)
global  Swarm;

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

robotPatch = Swarm.Agent5Vertex;
robotPatch(1,:)=robotPatch(1,:)+ population(5,1);
robotPatch(2,:)=robotPatch(2,:)+ population(5,2);
Mobile_Graph(5) = patch('Faces',Swarm.Agent5Faces,'Vertices',robotPatch','FaceColor', [0.3 0.75 0.93],'EdgeColor','none');