auto-archiver
=============

Script for automatic tail recursive adding files to archive.

As for now it is targeted at Prevayler commandLog and snapshot files, but it can be modified and use to any file type or name.
It doesn't need any arguments, it takes first command or snapshot file, adds it to bakap.7z and does it until bakap.7z reaches 4,4Gb in size.

Tail recursion means that the process will firstly add one file check if it should continue, and if so spawns another separate process and exits. That way it will not create stacking proceses problem.
