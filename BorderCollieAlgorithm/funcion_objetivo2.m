% Función objetivo
function distancia_total = funcion_objetivo2(ovejas, pastores, radio_objetivo)
    distancia_total = 0;
    for i = 1:size(ovejas, 1)
        distancias_pastores = zeros(1, size(pastores, 1));
        for j = 1:size(pastores, 1)
            distancias_pastores(j) = norm(ovejas(i,:) - pastores(j,:));
        end
        distancia_minima = min(distancias_pastores);
        distancia_total = distancia_total + max(0, distancia_minima - radio_objetivo);
    end
end
