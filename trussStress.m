% Function that calculates the stress in each element
% Author: Declan Walsh
% Last Modified: 13/08/2016

% INPUTS
% kStrain = nx4 2d stiffness vector for n elements to convert strain to stress
% q = 2n vector containing the displacements of each of the n nodes (ordered x1, y1, x2, ...)
% elements = vector of 2xm node numbers that m elements run between
% E = elastic modulus
% lenElements = array of m lengths of each element

% OUTPUTS
% stressElements = array of m stresses of each element

function [ stressElements ] = trussStress( kStrain, q, elements, E, lenElements )

    % create stressElements to be populated
    stressElements = zeros(1, length(elements));

    for i = 1:length(elements)
        % stores the nodal indices of the 2 nodes that make up the element being analysed
        idxA = elements(i, 1);
        idxB = elements(i, 2);
        
        % extract the displaments of the 2 nodes that make up the element being analysed
        qLocal = [q(2*idxA-1); q(2*idxA); q(2*idxB-1); q(2*idxB)];
        
        % calculate the stress of the element
        stressElements(i) = (E/lenElements(i))*kStrain(i, :)*qLocal;
    end
    
end

