function [minvalue,minpoint] = mindist(Map,yi)
    A = zeros(length(Map));
    for i=1:length(Map)
        A(i) = distance(Map(i),yi);
    end
    [minvalue,minpoint] = min(A);
    minpoint = minpoint-1;
end