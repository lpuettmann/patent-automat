function leave_xaxis_bottomonly(ix_subplot, dim_subplot, ...
    nr_totalsubplots, indic_axislabelsoff)
% Turn off x-axis line and labels for all but the last row of subplots.
%
% Inputs:
%         ix_subplot - give the position on the iteration loop for
%                      the subplot, so if the current suplot is the third 
%                      one, pass along 3
%         dim_subplot - give the rectangular dimensions of the subplot grid
%                       [rows, columns]
%         nr_totalsubplots - give the total number of subplots 
%         indic_axislabelsoff - 
%
% Set "indic_axislabelsoff" to:
%           'all' - turns off x-axis line and x-axis labels
%           'labels' - turns off x-axis labels only
%
% Written by Lukas Puettmann (2014)

if ix_subplot > (dim_subplot(1)-1)*dim_subplot(2) + ...
        (nr_totalsubplots - dim_subplot(1)*dim_subplot(2))
    % leave x-axis on
else 
    if strcmp(indic_axislabelsoff, 'all') == 1
        % turn x-axis and labels off
        set(gca, 'box', 'off', 'XTick', [], 'XColor', 'white')
    elseif strcmp(indic_axislabelsoff, 'labels') == 1
        % turn only labels off
        set(gca, 'box', 'off', 'XTick', [], 'XColor', 'black')
    else
        warning('Wrongly specified input "indic_axislabelsoff"')
    end
end
