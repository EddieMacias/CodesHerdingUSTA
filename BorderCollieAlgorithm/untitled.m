% Parámetros
maxIter = 100; % Máximo de iteraciones
n = 20; % Tamaño de población 
d = 2;

% Inicialización
Pop     = rand(n,d); % Población aleatoria de n perros y ovejas
V       = zeros(n,d); % Velocidades iniciales en 0
Acc     = rand(n,d); % Aceleraciones aleatorias
Time    = rand(n,1); % Tiempos aleatorios 

% Bucle principal
for t   = 1:maxIter
    
    % Evaluar aptitud 
    fit = cec17_func(Pop); % Aptitud con función de prueba
    
    % Encontrar mejores perros
    [~,ind]     = sort(fit);
    LeadDog     = Pop(ind(1),:); % Perro líder (mejor aptitud)
    RightDog    = Pop(ind(2),:); % Perro derecho 
    LeftDog     = Pop(ind(3),:); % Perro izquierdo
    
    % Actualizar velocidad de perros (ecuaciones 1-3)
    V(ind(1),:) = sqrt(V(ind(1),:).^2 + 2*Acc(ind(1),:).*Pop(ind(1),:)); 
    V(ind(2),:) = sqrt(V(ind(2),:).^2 + 2*Acc(ind(2),:).*Pop(ind(2),:));
    V(ind(3),:) = sqrt(V(ind(3),:).^2 + 2*Acc(ind(3),:).*Pop(ind(3),:));
    
    % Actualizar velocidad y posición de ovejas
    
    % Actualizar aceleraciones (ecuación 11)
    Acc = (V - Vprev)./Time; 
    
    % Actualizar tiempo (ecuación 12)
    Time = mean(V-Vprev)./Acc;
    
    % Actualizar posiciones (ecuaciones 13-18) 
    Pop = V.*Time + 0.5.*Acc.*Time.^2;
    
    % Guardar mejor posición 
    BestSol = LeadDog;
    
    % Actualizar para siguiente iteración
    Vprev = V;
    
end

% Mostrar mejor solución
disp(BestSol)