function [tabla_coordenadas_coppelia] = createBoardTable(value,step)
    valores  = -value:step:value;
    tam = length(valores);
    marizx = zeros(tam,tam);
    marizy = zeros(tam,tam); 
    for i=1:tam
        marizx(i,:) = valores;
        marizy(:,i) = -1*valores;
    end
    
    tabla_coordenadas_coppelia = zeros(tam*tam, 2);
    indice = 1;
    for col = 1:tam
        for fila = 1:tam
            f = marizx(fila,col);
            c = marizy(fila,col);
            tabla_coordenadas_coppelia(indice, :) = [f, c];
            indice = indice + 1;
        end
    end
end