This module provides (preferably temporary) fixes for the 'No GSettings schemas are installed on the system' error that can occur with GTK applications.
It creates a system variable ```GSETTINGS_SCHEMA_DIR``` with a path to the ```schemas``` directory in the gtk3 package.
Module updates this path when the gtk3 package is updated, so its name and store location.