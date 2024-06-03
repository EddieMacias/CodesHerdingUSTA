% Función objetivo
function distancia_total = funcion_objetivo3(ovejas, pastores, radio_objetivo, distancia_minima_pastores)
    distancia_total = 0;
    
    % Penalización por ovejas fuera del radio objetivo
    for i = 1:size(ovejas, 1)
        distancias_pastores = zeros(1, size(pastores, 1));
        for j = 1:size(pastores, 1)
            distancias_pastores(j) = norm(ovejas(i,:) - pastores(j,:));
        end
        distancia_minima = min(distancias_pastores);
        distancia_total = distancia_total + max(0, distancia_minima - radio_objetivo);
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