num_iterations = 300;
err = zeros(1,6);
ok = zeros(1,6);
CM = zeros(num_iterations,3);

for i = 1:num_iterations

    if (trajectory01(i,1) < -1 || trajectory01(i,1) >  1 || ...
        trajectory01(i,2) < -1 || trajectory01(i,2) >  1)
        err(1) = err(1)+1;
    else
        ok(1) = ok(1) +1;
    end

    if (trajectory02(i,1) < -1 || trajectory02(i,1) > 1  || ...
        trajectory02(i,2) < -1 || trajectory02(i,2) > 1)
        err(2) = err(2)+1;
    else
        ok(2) = ok(2) +1;
    end

    if (trajectory03(i,1) < -1 || trajectory03(i,1) > 1  || ...
        trajectory03(i,2) < -1 || trajectory03(i,2) > 1)
        err(3) = err(3)+1;
    else
        ok(3) = ok(3) +1;
    end

    if (trajectory04(i,1) < -1 || trajectory04(i,1) > 1  || ...
        trajectory04(i,2) < -1 || trajectory04(i,2) > 1)
        err(4) = err(4)+1;
    else
        ok(4) = ok(4) +1;
    end

    if (trajectory05(i,1) < -1 || trajectory05(i,1) > 1  || ...
        trajectory05(i,2) < -1 || trajectory05(i,2) > 1)
        err(5) = err(5)+1;
    else
        ok(5) = ok(5) +1;
    end

    CM(i,:) = (trajectory01(i,:)+ ...
               trajectory02(i,:)+ ...
               trajectory03(i,:)+ ...
               trajectory04(i,:)+ ...
               trajectory05(i,:))/5;

    if (CM(i,1) < -1 || CM(i,1) > 1  || ...
        CM(i,2) < -1 || CM(i,2) > 1)
        err(6) = err(6)+1;
    else
        ok(6) = ok(6) +1;
    end


end


% Definir los datos
Ovejas = {'1', '2', '3', '4', '5', 'CM'};
valores = err;
figure;
bar(valores);
set(gca, 'XTickLabel', Ovejas); % Establecer etiquetas de las categorías en el eje x
xlabel('Ovejas');
ylabel('Errores');
title('Ejemplo de Gráfico de Barras Boids vs Boids');
grid on;
grid minor
ylim([0 300]);


% figure
% xlabel = 1:num_iterations;
% s_lim = ones(num_iterations);
% i_lim = s_lim*-1;
% 
% plot(xlabel,trajectory01(:,1))
% hold on
% plot(xlabel,trajectory01(:,2))
% plot(xlabel,s_lim);
% plot(xlabel,i_lim);
% grid on
% grid minor
