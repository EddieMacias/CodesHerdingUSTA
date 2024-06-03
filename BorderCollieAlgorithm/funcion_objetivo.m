% Función objetivo
function distancia_total = funcion_objetivo(ovejas, pastor_izquierdo, pastor_superior, pastor_inferior)
    distancia_total = 0;
    for i = 1:size(ovejas, 1)
        distancia_izquierdo = norm(ovejas(i,:) - pastor_izquierdo);
        distancia_superior = norm(ovejas(i,:) - pastor_superior);
        distancia_inferior = norm(ovejas(i,:) - pastor_inferior);
        distancia_total = distancia_total + min([distancia_izquierdo, distancia_superior, distancia_inferior]);
    end
end
