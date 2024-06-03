%% SetOptimTagert
% Descripción: cuentra las posciciones Optimas de los pastores de Acuerdo al enjambre
%              y optimiza la distancia euclidiana  
% Autor: Edson Macias C
% Fecha de Creación: MAR-2024
% Versión: 1.0
% Dependencias: optimproblem

%Inputs
%positions:  posiciones ovejas (n,2) array n filas 2 columnas
%side     : 'L','R','U','D' hacia donde quiero mi funcion Objetivo
%pos_s    : posicion inicial pastor (x,y)
%Outputs
%target   : Posicion(x,y) del pastor

function [target] = setOptimTarget(positions,side,pos_s,dmin)

        problem1 = optimproblem("Description","Distancias Optimas Pastores");
        x = optimvar("x");
        y = optimvar("y");
        
        X = positions(:,1)';
        Y = positions(:,2)';
        d = sqrt((x-X).^2 + (y-Y).^2);
        initialGuess.x = pos_s(1);
        initialGuess.y = pos_s(2); 
        dTotal = sum(d);
        problem1.Constraints.dmin = d >= dmin;
        problem1.Objective = dTotal;


    if side == 'L'  
        rx = min(X);        
        problem1.Constraints.cx0  = x <= rx - 0.5;
        problem1.Constraints.cx1  = x <= -1;
        [sol,~] = solve(problem1,initialGuess);
        target = [sol.x sol.y];

    elseif side == 'R'
        rx = max(X);
        problem1.Constraints.cx0  = x >= rx + 0.5;
        problem1.Constraints.cx1  = x >= 1;
        [sol,~] = solve(problem1,initialGuess);
        target = [sol.x sol.y];

    elseif side == 'U'
        ry = max(Y);
        problem1.Constraints.cy0  = y >= ry + 0.5;
        problem1.Constraints.cy1  = y >= 1;
        [sol,~] = solve(problem1,initialGuess);
        target = [sol.x sol.y];

    elseif side == 'D'
        ry = min(Y);
        problem1.Constraints.cy0  = y <= ry - 0.5;
        problem1.Constraints.cy1  = y <= -1;
        [sol,~] = solve(problem1,initialGuess);
        target = [sol.x sol.y];

    else
        target = [0 0];
    end
    
end