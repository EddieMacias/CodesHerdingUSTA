function Leader_avoidance_vector = RotateLeaderPosition(actualPosition,obstacle)
    desiredAngle = randi(180);

    switch (obstacle)
        case "L"
            if desiredAngle >= 90
                desiredAngle = desiredAngle+180;
            end
        case "U"
            desiredAngle = desiredAngle + 180;
        case "R"
            desiredAngle = desiredAngle + 90;
        case "D"
            desiredAngle = randi(180);
        otherwise
            desiredAngle = 90;
    end

     angulo_rotacion = desiredAngle;
     angulo_rotacion = deg2rad(angulo_rotacion);
      
     R = [cos(angulo_rotacion) -sin(angulo_rotacion); ...
     sin(angulo_rotacion) cos(angulo_rotacion)];

    Leader_avoidance_vector = R*actualPosition';
    Leader_avoidance_vector = Leader_avoidance_vector';

end