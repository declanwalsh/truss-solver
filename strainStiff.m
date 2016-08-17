% Function that creates the 2D stiffness vector to relate stress to strain for an element
% Author: Declan Walsh
% Last Modified: 13/08/2016

% INPUTS
% cosElements, sinElements = cosine/sine vector of each elements trig relationships

% OUTPUTS
% kStrain = nx4 2d stiffness vector for n elements to convert strain to stress

function [ kStrain ] = strainStiff( cosElements, sinElements)

    ROT_SIZE = 4;

    numElements = length(cosElements);
    
    % setup strain stiffness matrix to be populated
    kStrain = zeros(numElements, ROT_SIZE);

    % construct the strain stiffness matrix
    for i = 1:numElements
        c = cosElements(i);
        s = sinElements(i);
        kStrain(i, :) = [-c, -s, c, s];
    end

end

