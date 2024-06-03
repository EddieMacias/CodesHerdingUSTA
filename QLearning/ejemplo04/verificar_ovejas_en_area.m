% Función para verificar si todas las ovejas están en el área objetivo
function todas_en_area = verificar_ovejas_en_area(estados_ovejas, area_objetivo, num_filas, num_columnas)
    todas_en_area = all(estados_ovejas >= sub2ind([num_filas, num_columnas], area_objetivo(1), area_objetivo(2))) & ...
                    all(estados_ovejas <= sub2ind([num_filas, num_columnas], area_objetivo(3), area_objetivo(4)));
end