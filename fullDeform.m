% Function that adds in constrained nodes back into the displacment vector
% Constrained nodes are initially removed to simplify the computation and are needed for full results
% Author: Declan Walsh
% Last Modified: 13/08/2016

% INPUTS
% qLimited = 2n-w vector containing the displacements of each of the unconstrained nodes (ordered x1, y1, x2, ... skipping constrained nodes)
% noDoF = vector containing the w constrained node indices 

% OUTPUTS
% qFull = 2n vector containing the displacements of each of the n nodes (ordered x1, y1, x2, ...)

function [ qFull ] = fullDeform( qLimited, noDoF )

    % sorts constrained nodes to insert from bottom up and avoid breaking order
    noDoF = sort(noDoF, 2, 'ascend');
    idxDoF = 1;

    % total number of displacment indicies required for system (2n for n nodes)
    numElements = length(qLimited) + length(noDoF);
    idxQ = 1;

    % create qFull to be populated
    qFull = zeros(1, numElements);

    for i =1:numElements
        % if index is in constrained list the displacment is set to zero
        if(i == noDoF(idxDoF))
            qFull(i) = 0;
            idxDoF = idxDoF + 1;
        % else the displacment is set as the next dispacement in the list
        else
            qFull(i) = qLimited(idxQ);
            idxQ = idxQ + 1;
        end
    end

end

