%% Translating the MATLAB Basics to EEGLab, and plotting figures
% This is the script we created during a second introductory video on how to use
% MATLAB, created by Darcy Diesburg for Dr. Jan Wessel's Analyzing Neural
% Field Potentials course. 
%% Open EEGLab
% (Make sure you have EEGLab installed, first!)
% tell MATLAB where it's located by adding the path or changing folder
% director to initialize
% addpath('C:/Users/Darcy/Documents/code stuff/eeglab14_1_1b');
cd('C:/Users/Darcy/Documents/code stuff/eeglab14_1_1b');
eeglab;
cd('C:/Users/Darcy/Desktop/EEG course/code');

%% EEGLab GUI (graphical user interface)
eeglab; % open GUI using this command in script or command window
% use 'eegh' command to print GUI command history into the command window
% As an example, use the GUI to load the sample data, called 'Subject201'
% by selecting File-->Load existing dataset. Then, call command history
% with eegh.

% This is my history of the loading commands:
% this command starts EEGLab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% This command loads the dataset
EEG = pop_loadset('filename','Subject201-pp.set','filepath','C:\\Users\\Darcy\\Desktop\\EEG course\\code\\');
% This command stores it in EEGLab's memory
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

% So, we can accomplish all this without the GUI by using these commands!
% HOWEVER, not all of the above needs to be included, because most of the
% above outputs are required for the GUI but not for simply using EEGLab
% functions in the workspace. I can do the same thing just by using:
EEG = pop_loadset('filename','Subject201-pp.set','filepath','C:\\Users\\Darcy\\Desktop\\EEG course\\code\\');

% If I want updates to refresh on the GUI window, so I can see it, I can
% use:
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw;
%% Some notes about the EEGLab standard data structure
% EEGLab loads in a dataset, which is organized as a structure.
% Above, I named it EEG. Some fields of this structure you'll work with
% frequently are data and event. 

% EEG.data is simply a large, 2D matrix, with channels as rows and
% timepoints as columns. 

% EEG.event is another structure, which holds the timestamps of event
% markers and any relevant behavioral information you want during analysis.

% Sometimes (as when you epoch your data), EEG.data may be a
% three-dimensional matrix. This simply means 2-D matrices are stacked
% along a third dimension (like what epoch is stored, for example). All you
% need to index a 3-D matrix is a third input when indexing.
% Example: EEG.data(1,500,1); <- I want the first channel, 500th timepoint,
% 1st epoch.

%% Final reminders about using EEGLab
% EEGLab functions are just that - functions! They take inputs (including
% your data in standard format) and give you outputs (usually your same
% data in the same format with some alterations made).

% If you get confused or encounter a function you aren't familiar with, use
% doc or help to access the documentation. The EEGLab wiki is also a
% fantastic resource when you have questions: https://eeglab.org/.

%% How to plot data figures
% make some example data, a sine wave
sine_wave = sin(2*pi*0:.1:10);
bar_data = [1 2 3];
% plot the data
% use figure to open a figure
handles = figure('Color','w');
subplot(2,1,1);
plot(sine_wave); xlabel('data points');
ylabel('voltage'); title('Sine wave data');

subplot(2,1,2);
bar(bar_data);