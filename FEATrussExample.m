close all
clear all
clc

x = [0, 40, 40, 0];
y = [0, 0, 30, 30];

assert(length(x) == length(y), 'Equal number of x and ay co-ordinates required - each node needs two co-ordinates')
nodes = length(x);

elements = [1, 2; 3, 2; 1, 3; 4, 3];

A = 1;
E = 29.5*1e6;

plotTruss(x, y, elements, 1);
[lengthEl, cosEl, sinEl] = trussParam(x, y, elements);
[kLocal] = trussStiff(lengthEl, cosEl, sinEl, A, E);

kLocal = kLocal./(29.5*1e6/600);
% account for error in worked solutions
kLocal(3, 1, 3) = 7.68;
kLocal(3, 2, 3) = 5.76;

kGlobal = globalStiff(kLocal, elements, nodes);

P = [0; 0; 20*1e3; 0; 0; -25*1e3; 0; 0];

% DoF at nodes that are restrained by the boundary conditions
noDoF = [1, 2, 4, 7, 8];
% nodes that have no applied load to them
noLoad = find(P == 0)';

[kGlobalReduced, P] = applyBC(kGlobal, P, noDoF)

q = (kGlobalReduced*(29.5*1e6/600))\P
qFull = fullDeform(q, noDoF) % adds constrained nodes back in

kStrain = strainStiff(cosEl, sinEl);
stressEl = trussStress(kStrain, qFull, elements, E, lengthEl);
stressEl = stressEl./1e3
loadTruss = stressEl./A