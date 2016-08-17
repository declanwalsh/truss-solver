close all
clear all
clc

% x co-ordinates of each section
LENGTH_1 = 41;
LENGTH_2 = 39;
LENGTH_3 = 37 + 32 + 28 + 25.75 + 25.25;

% y co-ordinates of each section
HEIGHT_TOP = 48;
HEIGHT_BOTTOM = 0;

x = [0, LENGTH_1/2, LENGTH_1, LENGTH_1, LENGTH_1 + LENGTH_2/2, LENGTH_1 + LENGTH_2, LENGTH_1 + LENGTH_2, LENGTH_1 + LENGTH_2 + LENGTH_3, 0, LENGTH_1 + LENGTH_2 + LENGTH_3];
y = [HEIGHT_TOP, 0, 0, HEIGHT_TOP, HEIGHT_TOP/2, 0, HEIGHT_TOP, HEIGHT_TOP, 0, 0.8*HEIGHT_TOP];

elements = [1, 2; 2, 3; 2, 4; 3, 4; 1, 4; 4, 7; 7, 6; 3, 6; 3, 5; 5, 6; 5, 7; 7, 8; 6, 8; 1, 9; 2, 9; 10, 8; 10, 6];

plotTruss(x, y, elements, 1, 0);
