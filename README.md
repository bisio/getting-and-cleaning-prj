run_analysis.R
========================

Expand zipped data in current directory and source the script to obtain a *tidy_data.txt* file.

Actually *run_analysis.R* depends on *plyr*. An alternative implementation, with no external dependencies, of the final summarization phase is commented out.


Code Book
----------

**subject**: subject id

**activity**: subject reported activity; one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

**all other variables**: see *features.txt*; variable names are cleaned up with make.names and "." characters are removed.

