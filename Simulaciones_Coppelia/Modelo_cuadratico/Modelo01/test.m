X_pos = sort(positions(:,1));
Y_pos = sort(positions(:,2));
R_pos  = X_pos(length(positions));
L_pos  = X_pos(1);
D_pos  = Y_pos(1);
pos = find(positions(:,1)==R_pos);
target_R = [positions(pos,1)+ 0.5, positions(pos,2)];
pos = find(positions(:,1)==L_pos);
target_L = [positions(pos,1)- 0.5, positions(pos,2)];
pos = find(positions(:,2)==D_pos);
target_D = [positions(pos,1), positions(pos,2)-0.5];

positions
Target = [target_R ; target_L; target_D]



