function d = distance(vector1,vector2)
    delta = vector1 - vector2;
    d = sqrt((real(delta)^2)+imag(delta)^2);
end