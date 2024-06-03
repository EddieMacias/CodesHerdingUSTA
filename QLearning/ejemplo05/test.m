clc
valores  = -2.5:1/5:2.5;
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

coordenada = [-2.2 0];
for i=1:length(tabla_coordenadas_coppelia)
    if coordenada(1) > tabla_coordenadas_coppelia(i,1)-1/5  &&  coordenada(1) < tabla_coordenadas_coppelia(i,1)+1/5
        valor_aprox_x = tabla_coordenadas_coppelia(i,1);
    end
   if coordenada(2) > tabla_coordenadas_coppelia(i,2)-1/5  &&  coordenada(2) < tabla_coordenadas_coppelia(i,2)+1/5
        valor_aprox_y = tabla_coordenadas_coppelia(i,2);
   end
end

pos = 0;
for i =1:length(tabla_coordenadas_coppelia)
    if( valor_aprox_x==tabla_coordenadas_coppelia(i,1) && valor_aprox_y==tabla_coordenadas_coppelia(i,2))
        pos = i;
        break
    end
end


% % Crear una matriz de ejemplo de 25x25
% matriz = rand(26);
% 
% % Obtener las dimensiones de la matriz
% [filas, columnas] = size(matriz);
% 
% % Inicializar una tabla para almacenar las coordenadas
% tabla_coordenadas = zeros(filas*columnas, 2);
% 
% % Convertir la matriz en una tabla de coordenadas
% indice = 1;
% for col = 1:columnas
%     for fila = 1:filas
%         tabla_coordenadas(indice, :) = [filas, col];
%         indice = indice + 1;
%     end
% end
% 
% % % Mostrar la tabla de coordenadas resultante
% % %disp(tabla_coordenadas);
% % value = [-2.5, -2.5];
% % valround = round(value,1);
% % 
% % x = (-1*abs(value(1))+2.5)/5;
% % y = (abs(value(2))+2.5)/5; 
% % 
% % for i =1:length(tabla_coordenadas)
% %     if( x==tabla_coordenadas(i,1) && y==tabla_coordenadas(i,2))
% %         break
% %     end
% % end

