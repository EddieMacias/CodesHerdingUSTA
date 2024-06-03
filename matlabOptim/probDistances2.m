%% optimizacion de distancias ejemplo de con Ovejas
% implementacion con optimproblem y fmincon


tic
problem = optimproblem("Description","Distancias");
x = optimvar("x");
y = optimvar("y");

num_boids = 5;
sheeps     = -2.5 + 5 * rand(num_boids, 2);
shepherd   = -2.5 + 5 * rand(1, 2);

X = sheeps(:,1);
Y = sheeps(:,2);

initialGuess.x = shepherd(1);
initialGuess.y = shepherd(2); 

% Funcion Objetivo
d = sqrt((x-X).^2 + (y-Y).^2); 
dTotal = sum(d);

problem.Objective = dTotal;

rx = min(X);

problem.Constraints.dmin = d >= 0.1;
problem.Constraints.dx   = x^2 + y^2 >= 1;
[sol,optval] = solve(problem,initialGuess);

toc

figure
scatter(X,Y,'filled')
hold on
scatter(sol.x,sol.y)
theta = linspace(0, 2*pi, 100);
A = cos(theta);
B = sin(theta);
plot(A,B)
