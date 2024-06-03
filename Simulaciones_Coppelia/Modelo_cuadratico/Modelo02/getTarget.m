function [target_R, target_L, target_D, target_U] = getTarget(positions, poi)

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
    
    DL =  (target_L(1) - poi(1));
    if (DL >= 0)
        target_L(1) = -1.2;
    elseif(DL < 0 && DL >= -0.65)
        target_L(1) = -2.2;
    elseif DL < -0.65 && DL > -0.9
        target_L(1) = -1/DL^2;
    elseif DL < -0.9
        target_L(1) = target_L(1) - 0.4;
    end
    
    DR =  (target_R(1) - poi(1));
    if (DR <= 0)
        target_R(1) = 1.2;
    elseif(DR > 0 && DR <= 0.65)
        target_R(1) = 2.2;
    elseif DR > 0.65 && DR < 0.9
        target_R(1) = 1/DR^2;
    elseif DR >= 0.9
        target_R(1) = target_R(1) + 0.4;
    end
    
    DD =  (target_D(2) - poi(2));
    if (DD >= 0)
        target_D(2) = -1.2;
    elseif(DD < 0 && DD >= -0.65)
        target_D(2) = -2.2;
    elseif DD < -0.65 && DD > -0.9
        target_D(2) = -1/DD^2;
    elseif DD < -0.9
        target_D(2) = target_D(2) - 0.4;
    end
    
    DU =  (target_U(2) - poi(1));
    if (DU <= 0)
        target_U(2) = 1.2;
    elseif(DU > 0 && DU <= 0.65)
        target_U(2) = 2.2;
    elseif DU > 0.65 && DU < 0.9
        target_U(2) = 1/DU^2;
    elseif DU >= 0.9
        target_U(2) = target_U(2) + 0.4;
    end
end