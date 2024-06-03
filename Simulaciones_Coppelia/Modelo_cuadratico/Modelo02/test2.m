   % Evitar Pastores LIDER
    Leader_shepherds_avoidance = zeros(1,2);
    for k = 1:size(shepherds, 1)
        dist_to_shepherds = norm(leader - shepherds(k,:));
        if dist_to_shepherds < shepherd_approach_distance
            Leader_shepherds_avoidance = Leader_shepherds_avoidance + (leader - shepherds(k,:)) / dist_to_shepherds^2;
        end
    end
    Leader_shepherds_avoidance = Leader_shepherds_avoidance * shepherds_avoidance_factor;