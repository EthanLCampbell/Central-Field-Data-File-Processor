function test = ScriptFile(~,~) %#ok<STOUT>
% This program reads and processes central field csv data files 
% from a user-specified folder and saves corresponding output 
% files to another user-specified folder.
% Author Ethan Labianca-Campbell

% Following command makes the text window appear commanding the user
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
msgbox('\fontsize{18} Select an input folder to read files, then select an output folder to put scanned files into.', CreateStruct)           

% Prompt user to choose a folder and return the path that the user selects
% Note we can change the start directory to any path, not just C:\
inputDirectory = uigetdir('C:\', 'Select a folder containing files to process.');

% Prompt user to choose a folder for saving data to and return the path
% Again, we can change the start directory to any path
outputDirectory = uigetdir('C:\', 'Select a folder for the output data.');

% Dir lists only *.txt files in the selected directory in a structured array
% Fullfile returns a vector with information about each file (name, folder, date, etc)
fileList = dir(fullfile(inputDirectory, '*.txt'));

% Now that you have a list of file names and folder paths, you can process each one.
for x = 1:length (fileList)

     filename = fullfile(fileList(x).folder, fileList(x).name);
     fprintf(1, 'Now reading %s\n', filename);
     fileID = fopen(filename,'r');
     dataArray = textscan(fileID,'%s%f%f%f%f%f%f%f%f%f%f%f%f%s','Delimiter','\t','HeaderLines',1,'CollectOutput',true);
     fclose(fileID);
     % fullTable = table(dataArray{1:end});

     % Remove NaN rows with ~all(Arrayname, 1 or 2), where ~ means not, and 1 works by columns, 2 works by rows
     idx = ~all(isnan(dataArray{2}),2);
     pth = dataArray{1}(idx,:);
     mat = dataArray{2}(idx,:);
     rgb = dataArray{3}(idx,:);

     % Compare rbg to string, 0=red, 1=blue
     ind2 = strcmp('java.awt.Color[r=0,g=0,b=255]',rgb);

     % Selects all rows in columns 9 and 10
     xAll = mat (:,9);
     yAll = mat (:,10);

     % Selects red rows in columns 9 and 10
     xRed = mat ([ind2==0],9);
     yRed = mat ([ind2==0],10);

     % Selects blue rows in columns 9 and 10
     xBlue = mat ([ind2==1],9);
     yBlue = mat ([ind2==1],10);

     % Plotting on the same graph
     hold on
     scatter (xRed,yRed, 'filled', 'r');
     scatter (xBlue,yBlue, 'filled', 'b');

     % Join mat columns 9 & 10 with rgb in a Structure Array because cat(A,B) won't join arrays with different types & sizes
     % See documentation on "Concatenate Structures" and how to "Access Data in a Structure Array".
     structuredArray.mat9 = mat(:,9);
     structuredArray.mat10 = mat(:,10);
     structuredArray.rgb = rgb;     % This could be ind2 as well
     shortTable = struct2table(structuredArray);     

     %Sorts data so that blue is over red
     shortTableSorted = sortrows(shortTable,3);

     % write the processed data to a new file in the user selected folder
     % the new file will end with *_output.txt
     newFilename = fullfile(outputDirectory, fileList(x).name);
     [filepath,name,ext] = fileparts(newFilename);
     newFilename = fullfile(filepath, strcat(name,'_Output',ext));
     writetable(shortTableSorted, newFilename,'Delimiter', '\t');  

end
end

