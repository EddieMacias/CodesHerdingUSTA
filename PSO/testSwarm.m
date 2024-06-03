% crear poblacion
objFun = @(x1,x2) x1^2 + x2^2 + sin(x1)*cos(x2);

Np = 5;
Min = [-20 -20];
Max = [20 20];
pop = createParticles(Np,Min,Max);

nd      = ndims(Max);
maxIter = 40;
cmin    = [0.5 0.5];
cmax    = [2.5 2.5];
wmin    = 0.4;
wmax    = 0.9;
alpha   = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scene=figure;                                                               % new figure
tam = [1 1 800 600];
set(scene,'position',[tam(1) tam(2) tam(3) tam(4)]);                        % position and size figure in the screen

axis equal;                                                                 % Set axis aspect ratios
axis([-20 20 -20 20 -10 10]);                                               % Set axis limits 
view([135 35]); 
grid on;  
grid minor;                                                                 % Display axes grid lines
SwarmFcn;                                                                   % Parameters of robot
M1=swarmPlot(pop);                                                          % Plot robot in initial position hx,hy and phi orientation
camlight('rigth');
%material('dull');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FA = fcnAdaptPSO(objFun,pop);

vi = 0; 
Vel = velInitPso(Np,nd,vi);

iter  =1;
pBest = pop;
[velmin,posmin]=min(FA);
gBest = pop(posmin,:);

% figure(iter)
% plot(pop(:,1), pop(:,2), 'ro')
% grid on
% grid minor
% axis([Min(1) Max(1) Min(2) Max(2)])

matC1 = zeros(maxIter,1);
matc2 = zeros(maxIter,1);
matw  = zeros(maxIter,1);

V = Vel;
X = pop;

while iter <= maxIter
    delete (M1)
    W   = calcWPSO(wmin,wmax,iter,maxIter);
    matw(iter,1)  = W;
    c1  = calcC1PSO(cmin(1),cmax(1),iter,maxIter);
    matC1(iter,1) = c1;
    c2  = calcC2PSO(cmin(2),cmax(2),iter,maxIter);
    matc2(iter,1) = c2;
    
    [V] = calcVelPSO(X,W,V,c1,c2,pBest,gBest);
    [X] = calcPosPSO(X,V);
    [F] = fcnAdaptPSO(objFun,X);

    [pBest, FOBest] = pMejores(objFun,pBest,X,F);
    
    [v,p] = min(FOBest) ;
    gBest = pBest(p,:);

    
    % plot(X(:,1),X(:,2),'ro')
    % grid on
    % grid minor
    % axis([Min(1) Max(1) Min(2) Max(2)])

    iter = iter+1;
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     M1 = swarmPlot(X);
     pause(0.5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end