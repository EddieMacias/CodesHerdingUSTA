%% GenerarMatrizR
% Descripción: genera la matriz de recompensas para Q Learning
% Autor: Edson Macias C
% Fecha de Creación: ABR-2024
% Versión: 2.0
% Dependencias: N/A

%Inputs
%posiciones_castigos     : Posiciones de los otros Agentes,ovejas
%                          obstaculos
%posicion_recompensa     : posicion del target
%num_estados             : numero de estados en la cuadricula (10x10 =100)
%num_acciones            : acciones por el agente (UP-DOWN-LEFT-RIGHT)
%Outputs
%R                       : Matriz de recompensas y castigos para cada
%                          agente




function [R] = GenerarMatrizR(posiciones_castigos,posicion_recompensa,num_filas,num_estados, num_acciones)
    tic
    % Definir la matriz de recompensas aleatorias
    R = -1 * ones(num_estados, num_acciones);  % Costo de movimiento de -1 para cada acción

    % Generar posiciones aleatorias para los castigos
    posiciones_auxiliares = zeros(num_estados,9);
    
    for castigo=1:length(posiciones_castigos)
        dat = posiciones_castigos(castigo);
    
        if dat == 1
            posiciones_auxiliares(castigo,:)  = [dat,                dat,        dat,             ...
                                                 dat,                dat,        dat+num_filas,   ...
                                                 dat,                dat+1 ,    (dat+num_filas)+1];
    
        elseif dat == num_filas                                                 
            posiciones_auxiliares(castigo,:)  = [dat,                dat-1,     (dat+num_filas)-1, ...
                                                 dat,                dat,        dat+num_filas,    ...
                                                 dat,                dat,        dat];
    
        elseif dat  == num_filas*(num_filas-1)+1
            posiciones_auxiliares(castigo,:)  = [dat,                dat,        dat, ...
                                                 dat-num_filas,      dat,        dat, ...
                                                 dat-num_filas+1,    dat+1,      dat];
    
        elseif dat  == num_filas^2
            posiciones_auxiliares(castigo,:)  = [dat-num_filas-1,    dat-1,      dat, ...
                                                 dat-num_filas,      dat,        dat, ...
                                                 dat,                dat,        dat];
    
        elseif dat > 1 && dat < num_filas         %primera Columna 
            posiciones_auxiliares(castigo,:) = [dat,                 dat-1,      (dat+num_filas)-1,  ...
                                                dat,                 dat,        dat+num_filas,      ...
                                                dat,                 dat+1 ,     (dat+num_filas)+1];
    
        elseif dat > num_filas*(num_filas-1)      %ultima Columna                                     
            posiciones_auxiliares(castigo,:) = [(dat-num_filas)-1,  dat-1,       dat   ...
                                                 dat-num_filas,     dat,         dat   ...
                                                (dat-num_filas)+1,  dat+1 ,      dat];
    
        elseif mod(dat,num_filas) == 0             %ultima fila     
            posiciones_auxiliares(castigo,:) = [(dat-num_filas)-1,  dat-1,       (dat+num_filas)-1 ...
                                                 dat-num_filas,     dat,         dat+num_filas     ...
                                                 dat,               dat,         dat];
    
        elseif mod(dat-1,num_filas) == 0          %primera fila     
            posiciones_auxiliares(castigo,:) = [dat,            dat,                dat           ...
                                                dat-num_filas,  dat,                dat+num_filas ...
                                                dat+1,         (dat-num_filas)+1,  (dat+num_filas)+1];
    
        else                                      %valores internos 
            posiciones_auxiliares(castigo,:) = [(dat-num_filas)-1,   dat-1,         (dat+num_filas)-1 ...
                                                 dat-num_filas,      dat,            dat+num_filas    ...
                                                (dat-num_filas)+1,   dat+1,         (dat+num_filas)+1]; 
        end
    end
    
    for filas=1:length(posiciones_castigos)
        for columnas=1:width(posiciones_auxiliares)
            value = posiciones_auxiliares(filas,columnas);
            R(value,:) = -100;
        end
    end
    
    R(posicion_recompensa, :) = 100;  % Recompensa positiva en el estado objetivo
    toc
end