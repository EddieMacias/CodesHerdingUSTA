% Definir la matriz de adyacencia del grafo
clc
clear all
N = 5; % Número de drones
A = rand(N) < 0.5; % Matriz de adyacencia aleatoria
A = A - diag(diag(A)); % Eliminar auto-conexiones

% Calcular la matriz Laplaciana del grafo
D = diag(sum(A, 2));
L = D - A;

% Verificar si el grafo tiene un árbol de expansión
has_spanning_tree = (rank(L) == N - 1);

if ~has_spanning_tree
    disp('El grafo no tiene un árbol de expansión. Generando nueva matriz de adyacencia...');
    while ~has_spanning_tree
        A = rand(N) < 0.5;
        A = A - diag(diag(A));
        D = diag(sum(A, 2));
        L = D - A;
        has_spanning_tree = (rank(L) == N - 1);
    end
end

% Parámetros del sistema
area_size = 5; % Tamaño del área en metros
dt = 0.01; % Paso de tiempo
t_final = 10; % Tiempo final de simulación
t = 0:dt:t_final;

% Condiciones iniciales
x0 = area_size * rand(N, 2); % Posiciones iniciales aleatorias
v0 = rand(N, 2); % Velocidades iniciales aleatorias

% Parámetros de control
kp = 1; % Ganancia de posición
kv = 0.5; % Ganancia de velocidad
gamma = 0.5; % Ganancia de amortiguamiento
kr = 0.5; % Ganancia de repulsión
d_min = 0.5; % Distancia mínima de separación

% Simulación del enjambre de drones
x = zeros(N, 2, length(t));
v = zeros(N, 2, length(t));
x(:, :, 1) = x0;
v(:, :, 1) = v0;

for i = 2:length(t)
    dx = reshape(x(:, :, i-1), [], 1);
    dv = reshape(v(:, :, i-1), [], 1);
    
    % Calcular las fuerzas de repulsión
    diff_x = reshape(x(:, :, i-1), N, 1, 2) - permute(reshape(x(:, :, i-1), N, 1, 2), [2, 1, 3]);
    diff_x = reshape(diff_x, N, N, 2);
    dist = sqrt(sum(diff_x.^2, 3));
    dist(dist == 0) = inf; % Evitar divisiones por cero
    F_rep = kr * (1 ./ dist - 1 ./ d_min) .* (diff_x ./ dist);
    F_rep(dist > d_min) = 0;
    F_rep(isnan(F_rep)) = 0; % Manejar valores NaN en F_rep
    F_rep = reshape(sum(F_rep, 2), [], 1);
    
    u = -kron(L, kp*eye(2))*dx - kron(L, kv*eye(2))*dv - gamma*kron(L, eye(2))*dv + F_rep;
    dx = dx + dt*dv;
    dv = dv + dt*u;
    
    % Verificar los límites del área y cambiar la dirección aleatoriamente si es necesario
    for j = 1:N
        if x(j, 1, i) < 0 || x(j, 1, i) > area_size
            v(j, 1, i) = -v(j, 1, i) + 0.5*rand(1) - 0.25;
        end
        if x(j, 2, i) < 0 || x(j, 2, i) > area_size
            v(j, 2, i) = -v(j, 2, i) + 0.5*rand(1) - 0.25;
        end
    end
    
    x(:, :, i) = reshape(dx, N, 2);
    v(:, :, i) = reshape(dv, N, 2);
end

% Graficar el movimiento del enjambre de drones
figure;
xlim([0, area_size]);
ylim([0, area_size]);
xlabel('Eje X (m)');
ylabel('Eje Y (m)');

for i = 1:length(t)
    plot(x(:, 1, i), x(:, 2, i), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    xlim([0, area_size]);
    ylim([0, area_size]);
    xlabel('Eje X (m)');
    ylabel('Eje Y (m)');
    title(sprintf('Enjambre de drones (t = %.2f s)', t(i)));
    drawnow;
    hold off;
end