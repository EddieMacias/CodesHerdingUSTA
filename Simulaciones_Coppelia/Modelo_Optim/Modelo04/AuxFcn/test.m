close all
poi = [0 0];

escala = 5/20;
range_x  = [-2.5, 2.5];
range_y  = [-2.5, 2.5];
pastor_L = zeros(1,2); 
pastor_R = zeros(1,2);
pastor_D = zeros(1,2);
Pastor_U = zeros(1,2);

SLU = [-1  0.5];
SLD = [-0.5 -0.5];
SRU = [ 0.5  0.5];
SRD = [ 0.5 -0.5];
SRC = [ 0.0  0.0];

positions = [SLU;SLD;SRU;SRD;SRC];
positions = rand(4,2)*2-1;
center_of_mass = mean(positions);

X_pos = sort(positions(:,1));
Y_pos = sort(positions(:,2));

R_pos  = X_pos(length(positions));
L_pos  = X_pos(1);

D_pos  = Y_pos(1);
U_pos  = Y_pos(length(positions));

pos = find(positions(:,1)==R_pos);
target_R = [positions(pos(1),1), positions(pos(1),2)];

pos = find(positions(:,1)==L_pos);
target_L = [positions(pos(1),1), positions(pos(1),2)];

pos = find(positions(:,2)==D_pos);
target_D = [positions(pos(1),1), positions(pos(1),2)];

pos = find(positions(:,2)==U_pos);
target_U = [positions(pos(1),1), positions(pos(1),2)];

DHL = center_of_mass(1) - target_L(1);
pastor_L   = [(-escala + 1/(DHL)) , target_L(2)]  ;
dist_L     = norm(target_L - pastor_L) ;
if pastor_L(1) < -2.2
    target_L(1) = -2.2;
elseif (dist_L < 0.5)
        target_L(1) = pastor_L(1) - 0.3;
else
    target_L(1) = pastor_L(1);
end
if target_L(1)>0 && target_L(1)>-1
    target_L(1) = -1.2;
end

DHR = center_of_mass(1) + target_R(1);
pastor_R   = [(escala + 1/DHR) , target_R(2)] ; 
dist_R     = norm(target_R - pastor_R) ;
if pastor_R(1) > 2.2
    target_R(1) = 2.2;
elseif (dist_R < 0.5)
    target_R(1) = pastor_R(1) + 0.3;
else
    target_R(1) = pastor_R(1);
end
if target_R(1)<0
    target_R(1) = 1;
end

DVI = center_of_mass(2) - target_D(2);
pastor_D    = [target_D(1),(-escala - 1/DVI)] ; 
dist_D      = norm(target_D - pastor_D) ;
if pastor_D(2) < -2.2
    target_D(2) = -2.2;
elseif (dist_D < 0.5)
    target_D(2) = pastor_D(2) - 0.3;
else
    target_D(2) = pastor_D(2);
end
if target_D(2)>0
    target_D(2) = 1;
end

DVU = center_of_mass(2) - target_U(2);
pastor_U    = [target_U(1),(escala + 1/DVI)] ; 
dist_U      = norm(target_U - pastor_U) ;
if pastor_U(2) > 2.2
    target_U(2) = 2.2;
elseif (dist_U < 0.5)
    target_U(2) = pastor_U(2) + 0.3;
else
    target_U(2) = pastor_U(2);
end
if target_U(2)<0
    target_U(2) = 1;
end

Target = [target_R ; target_L; target_D; target_U];
center_of_mass;

scatter(positions(:,1), positions(:,2),'blue','filled');
hold on;
scatter(center_of_mass(1),center_of_mass(2),'green','filled')
scatter(Target(:,1),Target(:,2),'cyan','filled')
rectangle('Position', [-1, -1, 2, 2], 'EdgeColor', 'blue');
grid on
grid minor
xlim(range_x);
ylim(range_y);
hold off;
drawnow;           
          


