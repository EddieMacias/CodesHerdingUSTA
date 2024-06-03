function Leader_avoidance_vector = RotateBoidPosition(actualPosition,desiredAngle)
    angulo_rotacion = desiredAngle;
    
    R = [cos(angulo_rotacion) -sin(angulo_rotacion); ...
         sin(angulo_rotacion) cos(angulo_rotacion)];

    Leader_avoidance_vector = R*actualPosition';
    Leader_avoidance_vector = Leader_avoidance_vector';

end