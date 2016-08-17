% Function that calculates trigonometric information about each element from its nodes' positions
% Author: Declan Walsh
% Last Modifed: 13/08/2016

% INPUTS 
% x, y = cartesian co-ordinates of 
% lines = 2xn vector

% OUTPUTS
% lenBar = length vector of each elements length
% cosBar, sinBar = cosine/sine vector of each elements trig relationships

function [ lenBar, cosBar, sinBar ] = trussParam( x, y, lines )

    % parameters calculated for each element in the line vector
    numElements = length(lines);

    % setup vectors to be populated
    lenBar = zeros(1, numElements);
    cosBar = zeros(1, numElements);
    sinBar = zeros(1, numElements);

    for i = 1:numElements

        % break each element into its x and y distances
        nodeA = lines(i, 1);
        nodeB = lines(i, 2);
        xDiff = x(nodeB) - x(nodeA);
        yDiff = y(nodeB) - y(nodeA);

        % calcuate length and trig relationships from distances
        lenBar(i) = sqrt(xDiff^2 + yDiff^2);
        cosBar(i) = xDiff/lenBar(i);
        sinBar(i) = yDiff/lenBar(i);
    end

end

