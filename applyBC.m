% Function that reduces the stiffness and load matricies by eliminating
% constrained elements and relevant rows and columns
% Author: Declan Walsh
% Last Modified: 13/08/2016

% INPUTS
% kGlobal = global stiffness matrix of 2nx2n
% P = vector of 2n loads applied to n nodes (x, y directions)
% noDoF = vector containing the w constrained node indices 

% OUTPUTS
% kGlobal = reduced global stiffness matrix of (2n-w)x(2n-w)
% P = reduced vector of 2n-2 loads applied to n-w unconstrained nodes (x, y directions)

function [ kGlobal, P ] = applyBC(kGlobal, P, noDoF)

    % sorts the list of constrained nodes in descending order
    % necessary to maintain correct order of subsequent nodes in list
    noDoF = sort(noDoF, 2, 'descend');

    for j = 1:length(noDoF)
        
        % extract displcament index of constrained node
        idx = noDoF(j);
        
        % remove rows and columns from the stiffness matrix
        kGlobal(:, idx) = [];
        kGlobal(idx, :) = [];
        
        % remove row from the load vector
        P(idx, :) = [];
    end

end

