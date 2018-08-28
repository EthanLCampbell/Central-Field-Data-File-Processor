# Central-Field-Data-File-Processor
Central-Field-Data-File-Processor is a matlab function which converts central field csv files to shorter, cleaner txt files. 

## Basic Operation
-The function prompts the user to select a folder containing csv files and as well as an output folder.
-Raw csv files in the user-selected folder are automatically read (a sample csv files is included in this repository).
-Non data columns and any rows with NaN values are removed.
-The data columns are input to a table.
-Data table is sorted by rbg column category.
-Data is written to a tab-delimited txt file which has the same name as the input file plus '_Output'.

## Other Features
-A table is generated upon reading the input file (currently commented out).
-Able to plot all data or data based on rbg category to the same axis.
