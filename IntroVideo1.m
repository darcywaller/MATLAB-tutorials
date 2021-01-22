%% The MATLAB Basics (<- this is a section heading. Make sections by using two % signs)
% This is the script we created during an introductory video on how to use
% MATLAB, created by Darcy Diesburg for Dr. Jan Wessel's Analyzing Neural
% Field Potentials course. (<- these are comments, which you can make using
% the % sign. Comments aren't executable code, but you can use them to
% leave notes in your code to make it easier to read.)
%% Simple operators
% We can put these in a script (what this document is), or do math in the
% Command window. We can also save the answers.

% Add
A = 1+4;
% Subtract
B = 6-1;
% Multiply
C = 6*4;
% Divide
D = 6/3;
% Exponential
E = 4^2;
%% Types of MATLAB variables

% Char (letter string)
this_is_a_string = 'Hello World!';
disp(this_is_a_string);

% Double (numerical)
this_is_a_double = 456;
this_is_also_a_double = 456.876;

% Complex (includes a real and imaginary component)
this_is_a_complex = complex(2,-3);

% Logical (boolean)
this_is_a_logical = true;
this_is_also_a_logical = isequal(2,2);

% Structure
structure.boolean = true;
structure.double = 450;
structure.string = 'characters';
%% Matrices and matrix notation
% make a vector
vector = [1 2 3];

% make a vector with : 
vector_too = [4:10];

% indexing vectors
second_number = vector(2);

% make a matrix - separate rows with ;
my_matrix = [1 2; 3 4];
% make vectors into matrices
A = [4 5 6];
B = [7 8 9];
C = [A; B];
% a note about concatenating
D = [4 5 6];
E = [7 8];
F = [A; B]; % THIS WILL GENERATE AN ERROR!

% preallocating, or making matrices with zeros, NaNs, or ones
matrix_of_zeros = zeros(5,6);
matrix_of_ones = ones(5,6);
matrix_of_NaN = nan(5,6);
% indexing matrices
number_in_matrix = my_matrix(2,2);

% matrix operations
% operation across all values in a matrix
matrix_plus_10 = my_matrix+10;
matrix_to_add = [20 21; 22 23];
sum_matrix = my_matrix + matrix_to_add;

% the dot operator
squared_matrix = my_matrix.^2;
% transpose
new_matrix = [1 2 3 4; 5 6 7 8];
% indexing a matrix in a structure
transposed_matrix = new_matrix';

% cell arrays and indexing
channels = {'Fz','Cz','Pz'};
one_channel_cell = channels(1);
one_channel_string = channels{1};
one_channel_letter = channels{1}(1);
%% Loops
% if
my_double = 5;
if my_double == 5 % any logical check, <,>
    % code inside the if loop
    multiplied_variable = my_double*3;
    disp(multiplied_variable);
end

% if loop with string check
my_stringname = 'rightchannel';
rightchannel_data = [1:5];
if strcmpi(my_stringname,'rightchannel') 
    % code inside the if loop
    divided_variable = rightchannel_data/5;
    disp(divided_variable);
end

% for
sample_vector = [4:7];
differences = zeros(1,4);
for iter = 1:length(sample_vector)
    differences(iter) = sample_vector(iter)-10;
end

% more complicated for loop on a matrix
matrix_for_loop = rand(9,10);
loop_output = zeros(1,size(matrix_for_loop,1));
for irow = 1:size(matrix_for_loop,1)
    loop_output(irow) = sum(matrix_for_loop(irow,:));
end

% while
analysis_done = 0;
while_loop_data = rand(1,3);
while analysis_done == 0
    summed_data = sum(while_loop_data);
    analysis_done = 1;
end

% if inside for
experimental_data = rand(8,2000);
participants = [0 1 0 1 1 0 0 1];
summed_experimental_data = zeros(1,length(participants));
for ipart = 1:length(participants)
    if participants(ipart) == 1
        summed_experimental_data(ipart) = sum(experimental_data(ipart,:));
    end
end
%% Functions
% using pre-written MATLAB functions or toolbox functions
average = mean([1:5]);
stand_dev = std([1:5]);

% writing your own functions
output_from_function = add_three(10);
output_from_another_function = add_numbers(8,9);
% (make sure you've created the function before executing, or it won't run!)
%% Saving and loading
% save
save(fullfile('C:/Users/Darcy/Desktop/EEG course','file'),'output_from_function');
% note that these filepaths won't work on your computer - they're specific
% to mine!

% load
load(fullfile('C:/Users/Darcy/Desktop/EEG course','file.mat'));
%% Debugging in MATLAB
% keyboard
experimental_data = rand(8,2000);
participants = [0 1 0 1 1 0 0 1];
summed_experimental_data = zeros(1,length(participants));
for ipart = 1:length(participants)
    if participants(ipart) == 1
        summed_experimental_data(ipart) = sum(experimental_data(ipart,:));
    end
end