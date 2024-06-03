function [index] = searchCoordinateOnTable(coord,tabla_coordenadas_coppelia,factor)
   
    for i=1:length(tabla_coordenadas_coppelia)
        if coord(1) > tabla_coordenadas_coppelia(i,1)-factor  &&  coord(1) < tabla_coordenadas_coppelia(i,1)+factor
            valor_aprox_x = tabla_coordenadas_coppelia(i,1);
        end
       if coord(2) > tabla_coordenadas_coppelia(i,2)-factor  &&  coord(2) < tabla_coordenadas_coppelia(i,2)+factor
            valor_aprox_y = tabla_coordenadas_coppelia(i,2);
       end
    end

    index = 0;
    for i =1:length(tabla_coordenadas_coppelia)
        if( valor_aprox_x==tabla_coordenadas_coppelia(i,1) && valor_aprox_y==tabla_coordenadas_coppelia(i,2))
            index = i;
            break
        end
    end

end