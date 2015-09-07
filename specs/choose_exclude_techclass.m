function exclude_techclass = choose_exclude_techclass()
% Choose those technology classification numbers (sometimes also called 
% OCL) to be excluded from being classified as automation patents. They 
% mostly pharma and chemical technologies.

exclude_techclass = [127;
                     252;
                     423;
                     424;
                     435;
                     436;
                     502;
                     (510:585)';
                     800;
                     930;
                     987];
