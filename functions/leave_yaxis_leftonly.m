function leave_yaxis_leftonly(ix_subplot, dim_subplot)

% Turn off y-axis lines and labels for all but  the column on the left.
%
% Inputs:
%         ix_subplot - give the position on the iteration loop for
%                      the subplot, so if the current suplot is the third 
%                      one, pass along 3
%         dim_subplot - give the rectangular dimensions of the subplot grid
%                       [rows, columns]
% Written by Lukas Puettmann (2014)

for i = 0:dim_subplot(1)-1
    ix_YAxis_On(i+1) = i*dim_subplot(2) + 1;
end

if any(ix_subplot==ix_YAxis_On) == 0
    set(gca,'box','off','YTick',[],'YColor','w')
end