% MAIN DESIGN SCRIPT FOR MMAN4410 ASSIGNMENT 1
% TRUSS ANALYSIS OF SPIRIT OF ST LOUIS FUSELAGE UNDER GUST LOADS
% Author: Declan Walsh
% Last Modified: 13/08/2016

% operates in whatever units the data is given in
% for SSL calculations, all data is in imperial units (lb, in)

clear all
close all
clc

% x co-ordinates of each section
LENGTH_1 = 41;
LENGTH_2 = 39;
LENGTH_3 = 37 + 32 + 28 + 25.75 + 25.25;

% y co-ordinates of each section
HEIGHT_TOP = 48;
HEIGHT_BOTTOM = 0;

outerDiam = 2;
innerDiam = 1;
A = pi*((outerDiam/2)^2 - (innerDiam/2)^2); % cross sectional area of bar
E = 29*1e6; % elastic modulus of SAE 1020 mild steel - http://www.azom.com/article.aspx?ArticleID=6114
Fy = 33360; % tensile yield strength of SAE 1020 mild steel - http://www.interlloy.com.au/our-products/bright-steels/1020-bright-carbon-steel-bar-2/?output=pdf
n = 5.37; % max gust load on SSL
W = 5250; % maximum takeoff weight of SSL 
Lmax = n*W; % max dynamic loading on wings

x = [0, LENGTH_1/2, LENGTH_1, LENGTH_1, LENGTH_1 + LENGTH_2/2, LENGTH_1 + LENGTH_2, LENGTH_1 + LENGTH_2, LENGTH_1 + LENGTH_2 + LENGTH_3];
y = [HEIGHT_TOP, 0, 0, HEIGHT_TOP, HEIGHT_TOP/2, 0, HEIGHT_TOP, HEIGHT_TOP];

% basic check on input data
assert(length(x) == length(y), 'Equal number of x and ay co-ordinates required - each node needs two co-ordinates')
nodes = length(x);

% vector of bar elements (2xn with n elements)
% each row has 2 indices indicating the nodes that the element lies between
% indices correspond to node location in x, y vector
elements = [1, 2; 2, 3; 2, 4; 3, 4; 1, 4; 4, 7; 7, 6; 3, 6; 3, 5; 5, 6; 5, 7; 7, 8; 6, 8];

% can be used to check if statically determinate (i.e. no redundant members)
numJoints = nodes;
[numMembers, ~] = size(elements);

plotTruss(x, y, elements, 1, 0);
[lengthEl, cosEl, sinEl] = trussParam(x, y, elements);
[k] = trussStiff(lengthEl, cosEl, sinEl, A, E);

kGlobal = globalStiff(k, elements, nodes);

% apply load to nodes
P = zeros(nodes*2, 1);
% max load is divided by 4 as half of structure analysed with load applied to 2 nodes (1/(2*2))
P(2*1) = Lmax/4; 
P(2*4) = Lmax/4;

% DoF at nodes that are restrained by the boundary conditions
% 9, 10 are x, y constraints of CG which is considered simply supported
% 16 is y constraint of tail which is considered roller
noDoF = [9, 10, 16];

% nodes that have no applied load to them
noLoad = find(P == 0)';

% apply BC to reduce the matrix
[kGlobalReduced, PReduced] = applyBC(kGlobal, P, noDoF);

% solve for displacements of reduced matrix
q = kGlobalReduced\PReduced;
qFull = fullDeform(q, noDoF) % adds constrained nodes back in

% develop stress strain matrix relationship for each element
kStrain = strainStiff(cosEl, sinEl);

% solve for stress of each element
stressEl = trussStress(kStrain, qFull, elements, E, lengthEl)

% convert to load in each element
loadTruss = stressEl.*A

% factor of safety on failure by material yielding
SF = abs(Fy./stressEl)

%% OUTPUT RESULTS
% convert results to readable table and save as CSVs

format short g

elementNodes = strcat(num2str(elements(:,1)), '-', num2str(elements(:,2))); % break up element vector into vector of strings of each node of elements
qX = qFull(1:2:length(qFull)); % takes odd (x) elements of displacment vector
qY = qFull(2:2:length(qFull)); % takes even (y) elements of displacment vector

nameTruss = {'Truss'; 'Constituent_Nodes'; 'Load'; 'Stress'; 'FoS' };
tableTruss = table([1:numMembers]', elementNodes, round(loadTruss, 4, 'significant')', round(stressEl, 4, 'significant')', round(SF, 4, 'significant')', 'VariableNames', nameTruss);

nameNodes = {'Node', 'x_Displacement', 'y_Displacement'};
tableNodes = table([1:nodes]', round(qX, 4, 'significant')', round(qY, 4, 'significant')', 'VariableNames', nameNodes);

writetable(tableTruss, 'tableTruss.csv');
writetable(tableNodes, 'tableNodes.csv');