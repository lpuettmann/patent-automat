function setup_path()
%SETUP Adds directories for Metrics to your MATLAB path
%
%   Author: Ben Hamner (ben@benhamner.com)
%
%   Adjusted by Lukas Puettmann:
%       - adjust for path delimiters on different operating systems.
%       - add comments
%       - don't use savepath

% Get absolute path to current script
myDir = fileparts(mfilename('fullpath'));

% Get paths of given directory and subdirectories
paths = genpath(myDir);
paths = strread(paths,'%s','delimiter',':');
pathsToAdd = [];

for i=1:length(paths)
    thisPath = paths{i};
    
    if ismac | isunix
        thisPathSplit = strread(thisPath,'%s','delimiter','/');
    elseif ispc
        thisPathSplit = strread(thisPath,'%s','delimiter','\\');
    end  
    
    addThisPath = 1;
    
    % Do not add any directories or files starting with a . or a ~
    for j=1:length(thisPathSplit)
        thisStr = thisPathSplit{j};
        if (~isempty(thisStr)) && ((thisStr(1) == '.') || (thisStr(1) == '~'))
            addThisPath = 0;
        end
    end
    if addThisPath ==1
        if ~isempty(pathsToAdd)
            thisPath = [':' thisPath];
        end
        pathsToAdd = [pathsToAdd thisPath];
    end
end

addpath(pathsToAdd);