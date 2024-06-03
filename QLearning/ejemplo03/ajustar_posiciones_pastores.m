% Función para verificar y ajustar las posiciones de los pastores
function estados_pastores = ajustar_posiciones_pastores(estados_pastores, estados_ovejas, num_filas, num_columnas, area_objetivo,num_pastores,num_estados)
    posiciones_unicas = unique(estados_pastores);
    while length(posiciones_unicas) < num_pastores || any(ismember(estados_pastores, estados_ovejas))
        for i = 1:num_pastores
            if sum(estados_pastores == estados_pastores(i)) > 1 || ismember(estados_pastores(i), estados_ovejas)
                estados_pastores(i) = randi(num_estados);
                [fila_pastor, columna_pastor] = ind2sub([num_filas, num_columnas], estados_pastores(i));
                while ismember(fila_pastor, area_objetivo(:, 1)) && ismember(columna_pastor, area_objetivo(:, 2))
                    estados_pastores(i) = randi(num_estados);
                    [fila_pastor, columna_pastor] = ind2sub([num_filas, num_columnas], estados_pastores(i));
                end
            end
        end
        posiciones_unicas = unique(estados_pastores);
    end
end