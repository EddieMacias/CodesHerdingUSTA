% Definir la matriz de adyacencia del grafo
A = [0 1 1 0 1;
     1 0 1 1 0;
     1 1 0 1 1;
     0 1 1 0 1;
     1 0 1 1 0];

% Calcular la matriz Laplaciana del grafo
D = diag(sum(A, 2));
L = D - A;

% Verificar si el grafo tiene un árbol de expansión
has_spanning_tree = (rank(L) == length(L) - 1);

if has_spanning_tree
    disp('El grafo tiene un árbol de expansión.');
else
    disp('El grafo no tiene un árbol de expansión.');
    return;
end

% Consenso de primer orden
x0 = rand(5, 1); % Condiciones iniciales aleatorias
dx = -L * x0;
consensus_value = sum(x0) / length(x0);
disp('Valor de consenso de primer orden:');
disp(consensus_value);

% Consenso de segundo orden
xi0 = rand(5, 1); % Posiciones iniciales aleatorias
vi0 = rand(5, 1); % Velocidades iniciales aleatorias
gamma = 0.5; % Ganancia de amortiguamiento
dx = [xi0; vi0];
A_sec = [zeros(5) eye(5); -L -gamma*L];
dt = 0.01;
t = 0:dt:10;
x = zeros(10, length(t));
x(:, 1) = dx;

for i = 2:length(t)
    x(:, i) = x(:, i-1) + dt * A_sec * x(:, i-1);
end

consensus_position = sum(xi0) / length(xi0);
consensus_velocity = sum(vi0) / length(vi0);
disp('Valor de consenso de posición de segundo orden:');
disp(consensus_position);
disp('Valor de consenso de velocidad de segundo orden:');
disp(consensus_velocity);

% Protocolo de formación de segundo orden
Delta = [0; 1; 2; 3; 4]; % Posiciones deseadas relativas al centro de formación
kp = 1; % Ganancia de posición
kv = 0.5; % Ganancia de velocidad
dx = [xi0 - Delta; vi0];
A_form = [zeros(5) eye(5); -kp*eye(5)-L -kv*eye(5)-gamma*L];
x = zeros(10, length(t));
x(:, 1) = dx;
for i = 2:length(t)
    x(:, i) = x(:, i-1) + dt * A_form * x(:, i-1);
end

% Graficar el grafo
figure;
G = digraph(A);
plot(G, 'NodeColor', 'r', 'NodeFontSize', 12, 'EdgeColor', 'b', 'LineWidth', 1.5);
title('Grafo de comunicación de los 5 agentes');