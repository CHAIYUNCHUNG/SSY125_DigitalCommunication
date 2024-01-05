function d = bpskdis(vector1,vector2)
    delta = vector1 - vector2;
    Re = abs(real(delta));
    Im = abs(imag(delta));
    d = Re + Im;
end