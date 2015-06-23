clear all
close all
clc



% Close all previously openned files
check_open_files
disp('Close all files.')
fclose('all');



%% Define email parameters
sender = 'lukas.puettmann@gmail.com';
password = 'egGiegGG';
recipient = 'lukas.puettmann@gmx.de';


%% Set email connection settings
setpref('Internet', 'E_mail', sender);
setpref('Internet', 'SMTP_Server', 'smtp.gmail.com');
setpref('Internet', 'SMTP_Username', sender);
setpref('Internet', 'SMTP_Password', password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth', 'true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port', '465');



%% Delete previous log file
if exist('CommandLineTextLog.txt', 'file') == 2
    delete('CommandLineTextLog.txt')
    disp('Delete previous log file.')
else
    disp('Make new file CommandLineTextLog.txt.')
end


%% Run the analysis for the first part (1976-2001)
tic

% Save command line input/output to text file
diary('CommandLineTextLog.txt'); 

% Run analysis
find_patents_part1

part_run_time = toc;
fprintf('Part 1 finished, time: %d seconds (%d minutes).\n', ...
    round(part_run_time), round(part_run_time/60))

diary('off'); % stop saving command line text

% Send email stating that first part has finished. Also send the command
% line text (input and output) in the body of the message.
subject = 'Matlab status report: part 1 (1976-2001) finished.';
message_text_log = textread('CommandLineTextLog.txt', '%s', 'delimiter', '\n');
sendmail(recipient, subject, message_text_log);




%% Run the analysis for the second part (2002-2004)
tic

% Save command line input/output to text file
diary('CommandLineTextLog.txt'); 

% Run analysis
find_patents_part2

part_run_time = toc;
fprintf('Part 2 finished, time: %d seconds (%d minutes).\n', ...
    round(part_run_time), round(part_run_time/60))

diary('off'); % stop saving command line text

% Send email stating that first part has finished. Also send the command
% line text (input and output) in the body of the message.
subject = 'Matlab status report: part 2 (2002-2004) finished.';
message_text_log = textread('CommandLineTextLog.txt', '%s', 'delimiter', '\n');
sendmail('lukas.puettmann@gmx.de', subject, message_text_log);



%% Run the analysis for the third part (2005-2015)
tic

% Save command line input/output to text file
diary('CommandLineTextLog.txt'); 

% Run analysis
find_patents_part3

part_run_time = toc;
fprintf('Part 3 finished, time: %d seconds (%d minutes).\n', ...
    round(part_run_time), round(part_run_time/60))

diary('off'); % stop saving command line text

% Send email stating that first part has finished. Also send the command
% line text (input and output) in the body of the message.
subject = 'Matlab status report: part 3 (2005-2015) finished.';
message_text_log = textread('CommandLineTextLog.txt', '%s', 'delimiter', '\n');
sendmail('lukas.puettmann@gmx.de', subject, message_text_log);
