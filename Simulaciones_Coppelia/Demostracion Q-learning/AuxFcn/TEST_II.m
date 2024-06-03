close all
poi = [0 0];
aoi = 1;

%escala = 5/20;
range_x  = [-2.5, 2.5];
range_y  = [-2.5, 2.5];
pastor_L = zeros(1,2); 
pastor_R = zeros(1,2);
pastor_D = zeros(1,2);
Pastor_U = zeros(1,2);

positions = rand(4,2)*2-1;
center_of_mass = mean(positions);

[target_R, target_L, target_D, target_U] = getTarget(positions, poi);

Target = [target_R ; target_L; target_D; target_U];
center_of_mass;

scatter(positions(:,1), positions(:,2),'blue','filled',"pentagram");
hold on;
scatter(center_of_mass(1),center_of_mass(2),'green','filled')
scatter(Target(:,1),Target(:,2),'cyan','filled',"hexagram")
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
grid on
grid minor
xlim(range_x);
ylim(range_y);
hold off;
drawnow;           
          


