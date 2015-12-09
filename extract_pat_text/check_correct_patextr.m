function check_correct_patextr(patextr)
% Run some checks to see if the extracted metainformation on the manuall
% coded patents is plausible.


disp('__________')
disp('Run checks on extracted metadata of manually coded patents:')

% Check some of the classifications
i = find( patextr.patentnr == 3986701 );
if not( patextr.manAutomat(i) == 0 )
    warning('Patent should be classified differently.')
else
    fprintf('.')
end

i = find( patextr.patentnr == 5269094 );
if not( patextr.manAutomat(i) == 1 )
    warning('Patent should be classified differently.')
else
    fprintf('.')
end

i = find( patextr.patentnr == 6874680 );
if not( patextr.manAutomat(i) == 1 )
    warning('Patent should be classified differently.')
else
    fprintf('.')
end

% Check that percentage of automation patent is plausible
perc_autompat = sum(patextr.manAutomat) / length(patextr.manAutomat);
if (perc_autompat >= 0.5) || ( perc_autompat <= 0.1)
    warning('Implausible share of automation patents.')
else
    fprintf('.')
end

% Check plausible coding dates
if not( all(patextr.coderDate >= 20150101) | ...
        all(patextr.coderDate >= 20200101) )
    warning('Implausible coder dates.')
else
    fprintf('.')
end

% Check years of patents
if not( all(patextr.indic_year >= 1976) | ...
        all(patextr.indic_year <= 2016) )
    warning('Implausible patent years.')
else
    fprintf('.')
end

fprintf('\n')
disp('Checks finished.')
disp('__________')
