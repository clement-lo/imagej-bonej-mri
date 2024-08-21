// Main Macro
    setupEnvironment();
    clearOverlays();
    var filePath = File.openDialog("Select the bone scan CT file");
    if (filePath == "") {
        showMessage("Error", "No file selected. Please select a valid CT file to proceed.");
        return;
    }
    open(filePath);
    if (nImages == 0) {
        showMessage("Error", "The selected file could not be opened or is not a valid image file.");
        return;
    }

    showMessage("Please manually scroll to the center frame of the image stack and then press OK.");
    waitForUser("Identify Center Frame");
    var centerFrame = getFrameInput("Enter the center frame number:", nSlices / 2);

    showMessage("Please manually scroll to the end frame of the image stack and then press OK.");
    waitForUser("Identify End Frame");
    var endFrame = getFrameInput("Enter the end frame number:",);

    showMessage("Please manually scroll to the start frame of the image stack and then press OK.");
    waitForUser("Identify Start Frame");
    var startFrame = getFrameInput("Enter the start frame number:",);
}
	var decision = getManagementDecision();
	if (decision == "Draw New ROIs") {
	    drawROIs(startFrame, endFrame);
	} else if (decision == "Load ROIs from File") {
	    loadROIsFromFile();
	}
    if (confirmROIsReady()) {
        automateROISelectionAndInterpolation();
        if (!confirmInterpolationComplete()) {
            manualROISelectionAndInterpolationInstructions();
            if (!confirmInterpolationComplete()) {
                showMessage("Error", "Interpolation not confirmed. Please ensure all ROIs are correctly interpolated.");
                return;
            }
        }
        var saveDirectory = getSaveLocation();
        if (saveDirectory != "") {
            saveROIs(saveDirectory, "");
        } else {
            showMessage("Error", "No save directory selected. Please select a valid directory to save ROIs.");
        }
    } else {
        showMessage("ROI finalization cancelled by user.");
    }

function setupEnvironment() {
    run("Close All");
    roiManager("Reset");
    run("Clear Results");
}

function clearOverlays() {
    run("Remove Overlay");
}

function getFrameInput(message, defaultFrame) {
    return getNumber(message + " (default: " + defaultFrame + "):", defaultFrame);
}

function getManagementDecision() {
    Dialog.create("Decision");
    Dialog.addChoice("Choose:", "Option 1");
    Dialog.show();
    return Dialog.getChoice();
}

function drawROIs(startFrame, endFrame) {
    setSlice(startFrame);
    showMessage("Draw ROIs from frame " + startFrame + " to " + endFrame + ". Press OK when done.");
    waitForUser("Drawing ROIs");
   
function loadROIsFromFile() {
    var filepath = File.openDialog("Select ROI file");
    roiManager("Open", filepath);
}

function confirmROIsReady() {
    return showDialog("Confirm ROIs", "Are all ROIs ready for saving?", newArray("Yes", "No")) == "Yes";
}

function automateROISelectionAndInterpolation() {
    roiManager("Select All");
    run("Interpolate ROIs", "");
    showMessage("Interpolation complete.");
}

function manualROISelectionAndInterpolationInstructions() {
    showMessage("Manual Interpolation Instructions", "Please manually select all ROIs in the ROI Manager by pressing 'cmd+a', then go to 'More >>' and select 'Interpolate ROIs'. After completing these steps, press OK to continue.");
}

function confirmInterpolationComplete() {
    return showDialog("Confirm Interpolation", "Have you completed the interpolation of ROIs?", newArray("Yes", "No")) == "Yes";
}

function getSaveLocation() {
    return getDirectory("Choose a directory to save ROIs");
}

function saveROIs(saveDirectory, roiZipPath) {
    if (saveDirectory == "") {
        showMessage("Error", "No save directory selected. Please select a valid directory to save ROIs.");
        return;
    }
    var filename = getString("Enter a filename for the ROIs .zip", roiZipPath != "" ? roiZipPath : "NewROIs.zip");
    var fullPath = saveDirectory + filename;
    roiManager("Save", fullPath);
    showMessage("ROIs Saved", "The ROIs were saved to " + fullPath);
}
---
Error:
There are no images open in line 17
(called from line 17)
var centerFrame = getFrameInput ("Enter the center frame number:", <nslices> / 2);