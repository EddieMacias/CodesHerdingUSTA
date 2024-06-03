% Función para graficar los resultados del entrenamiento
function graficar_resultados(recompensas_episodios, recompensas_promedio)
    figure;
    subplot(2, 1, 1);
    plot(recompensas_episodios, 'b-', 'LineWidth', 1);
    xlabel('Episodio');
    ylabel('Recompensa Total');
    title('Recompensa Total por Episodio');
    grid on;
    
    subplot(2, 1, 2);
    plot(recompensas_promedio, 'r-', 'LineWidth', 1);
    xlabel('Episodio');
    ylabel('Recompensa Promedio');
    title('Recompensa Promedio por Episodio');
    grid on;
end