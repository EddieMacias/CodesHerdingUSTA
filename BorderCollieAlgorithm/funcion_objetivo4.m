% Función objetivo
function distancia_total = funcion_objetivo4(ovejas, pastores, radio_objetivo, distancia_minima_pastores)
    distancia_total = 0;
    centro_masa_ovejas = mean(ovejas);
    
    % Distancia del centro de masa de las ovejas al centro de la circunferencia objetivo
    distancia_centro_masa = norm(centro_masa_ovejas);
    distancia_total = distancia_total + distancia_centro_masa;
    
    % Penalización por ovejas fuera del radio objetivo
    for i = 1:size(ovejas, 1)
        distancia_oveja = norm(ovejas(i,:));
        if distancia_oveja > radio_objetivo
            distancia_total = distancia_total + (distancia_oveja - radio_objetivo);
        end
    end
    
    % Penalización por pastores demasiado cerca entre sí
    for i = 1:size(pastores, 1)
        for j = i+1:size(pastores, 1)
            distancia_pastores = norm(pastores(i,:) - pastores(j,:));
            if distancia_pastores < distancia_minima_pastores
                distancia_total = distancia_total + (distancia_minima_pastores - distancia_pastores);
            end
        end
    end
end