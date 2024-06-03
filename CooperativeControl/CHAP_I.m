% Número de agentes
N = 10;

% Posiciones iniciales aleatorias
x = rand(2,N);

% Velocidades iniciales aleatorias
v = rand(2,N);

% Radio de evasión de colisiones
r_c = 0.1;

% Radio de interacción
r_a = 0.2;

% Ganancias de control
c = 1;
a = 1;

% Tiempo de simulación
t_final = 10;
dt = 0.01;
t = 0:dt:t_final;

% Bucle de simulación
for i = 1:length(t)
    
    % Calcular distancias entre agentes
    dx = x(:,:,i) - x(:,:,i)';
    dist = sqrt(sum(dx.^2, 1));
    
    % Construir grafo de comunicación
    A = (dist < r_a) - eye(N);
    
    % Ley de control de evasión de colisiones
    u_c = zeros(2,N);
    for j = 1:N
        idx = find(dist(:,j) < r_c);
        u_c(:,j) = -c*sum(dx(:,idx,j),2);
    end
    
    % Ley de control de centrado
    u_a = zeros(2,N);
    for j = 1:N
        idx = find(A(:,j) == 1);
        u_a(:,j) = a*sum(dx(:,idx,j),2);
    end
    
    % Ley de control total
    u = u_c + u_a;
    
    % Actualizar velocidades
    v(:,:,i+1) = v(:,:,i) + dt*u;
    
    % Actualizar posiciones
    x(:,:,i+1) = x(:,:,i) + dt*v(:,:,i+1);
end

% Graficar trayectorias
figure;
plot(squeeze(x(1,:,:)), squeeze(x(2,:,:)));
xlabel('x');
ylabel('y');
title('Trayectorias de los agentes');