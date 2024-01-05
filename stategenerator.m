function [states,next,output] = stategenerator(G)
    [r,c] = size(G);
    r = r-1;
    states = zeros((2^r)*2,r);
    next = zeros((2^r)*2,r);
    output = zeros((2^r)*2,c);

    for i=1:2^r
        states(i,:) = flip(de2bi(i-1,r));
        states(i+2^r,:) = flip(de2bi(i-1,r));
        next(i,:) = [0, states(i,1)];
        next(i+2^r,:) = [1, states(i,1)];
        output(i,:) = mod([0,states(i,:)]*G,2);
        output(i+2^r,:) = mod([1,states(i,:)]*G,2);
    end
end