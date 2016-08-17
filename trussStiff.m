function [ k ] = trussStiff( lenEl, cosEl, sinEl, A, E )

ROT_SIZE= 4;

numEl = length(lenEl);
k = zeros(ROT_SIZE, ROT_SIZE, numEl);

for i = 1:numEl
    c = cosEl(i);
    s = sinEl(i);
    k(:, :, i) = (A*E/lenEl(i))*[c^2, c*s, -c^2, -c*s; c*s, s^2, -c*s, -s^2; -c^2, -c*s, c^2, c*s; -c*s, -s^2, c*s, s^2];
end

