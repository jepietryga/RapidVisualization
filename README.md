# Rapid Visualization Overview
This work is associated with the work on "Rapid Understanding of Electron Tomography through Holographic Displays".  This repository holds the DMScript code for controlling the microscope, Python scripts for making quilts, and a Unity build of the Quilt Viewer. Each can be used independently, but it is necessary to combine them to rapidly visualize from the microscope to the holographic display.

Additionally, there are sample quilts and Data attached for viewing.

# DMScript
This code mostly relies on combined_scripts.s and HolographyGUI.s. To use these scripts, install the combined_scripts.s file inside the GMS software, then open and run the HolographyGUI.s inside the GMS software. 

# Python Scripts
The Python scripts are used for both creation of quilts and transferring of data between folders. SSH is used to move .dm4 files from a microscope server to a local directory.

# Unity Build
The Unity Quilt Viewer is based on kirurobo's Quilt Viewer (https://github.com/kirurobo/LookingGlassQuiltViewer).

The Quilt Viewer is suitable for loading and viewing generated quilts and quilt videos, but it also allows for directory monitoring--if a new quilt enters the directory, it will automatically be displayed on screen. The default directory is the "StreamingAssets" directory, so scripts trying to automatically load files should be placed here. However, loading a quilt from a different folder will the current directory to the image's directory.
