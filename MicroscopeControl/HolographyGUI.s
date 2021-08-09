// Holography Code for automated acqusition of image stack for 
// LookingGlass display

// Created 2020/07/31
// By: Jacob Pietryga

// Global Variables
number minAngle = -22
number maxAngle = 22
number angleIter = maxAngle-minAngle + 1

/*
number detectChecks = 0
number signalIndex = 0
number dataDepth = 4
number acquire = 1
number imageID = 0
number Dim = 512
number DwellTime = 4
*/
// number ParamID = DSCreateParameters(Dim, Dim, 0, DwellTime, 0)



// Sub-functions

void Tilt_Command(object self, number given_tilt){
	result("Beginning tilt...\n")
	number tilt = EMGetStageAlpha()
	number anglechange = given_tilt //(DLGGetValue(self.lookupelement("deltatiltfield")))
	number newtilt = tilt+anglechange
	
	EMSetStageAlpha(newtilt)
	//EMWaitUntilReady()
	RefreshFunction_curr(self)
}

// GUI Design
// EFFECTS: Returns TagGroup of organized dialog elements for GUI
TagGroup MakeHoloDialog(){
	TagGroup Holo_items = newTagGroup()
	TagGroup Holo_Box = DLGCreateBox("Holography", Holo_items)

	// Start Button
	TagGroup Start_Button = DLGCreatePushButton("Start Imaging", "start_imaging")

	// Value Block: Organized block of values
	TagGroup Empty_Label = DLGCreateLabel("")
	TagGroup X_Label = DLGCreateLabel("X\n(um)")
	TagGroup Y_Label = DLGCreateLabel("Y\n(um)")
	TagGroup Z_Label = DLGCreateLabel("Z\n(um)")
	TagGroup DF_Label = DLGCreateLabel("Defocus\n(um)")
	TagGroup Tilt_Label = DLGCreateLabel("Tilt\n(degrees)")
	
	TagGroup Curr_Label = DLGCreateLabel("Current: ")
	TagGroup CurrX = DLGCreateRealField(0,9,5).dlgidentifier("currX")
	TagGroup CurrY = DLGCreateRealField(0,9,5).dlgidentifier("currY")
	TagGroup CurrZ = DLGCreateRealField(0,9,5).dlgidentifier("currZ")
	TagGroup CurrDF = DLGCreateRealField(0,9,5).dlgidentifier("currDF")
	TagGroup CurrTilt = DLGCreateRealField(0,9,5).dlgidentifier("currTilt")
	
	TagGroup Label_column = DLGgroupitems(Empty_Label, Curr_Label).dlgtablelayout(1,2,1)
	TagGroup X_column = DLGgroupitems(X_Label, CurrX).dlgtablelayout(1,2,1)
	TagGroup Y_column = DLGgroupitems(Y_Label, CurrY).dlgtablelayout(1,2,1)
	TagGroup Z_column = DLGgroupitems(Z_Label, CurrZ).dlgtablelayout(1,2,1)
	TagGroup dF_column = DLGgroupitems(DF_Label, CurrDF).dlgtablelayout(1,2,1)
	TagGroup tilt_column = DLGGroupitems(Tilt_Label, CurrTilt).dlgtablelayout(1,2,1)
	
	TagGroup XYZ_Block = DLGgroupitems(X_column,Y_column,Z_column).dlgtablelayout(3,1,1)
	TagGroup Val_Block = DLGgroupitems(Label_Column, XYZ_Block, DF_Column,Tilt_Column).dlgtablelayout(4,1,0)
	
	// Simplified Tilt Controls
	TagGroup TiltMinus_button = DLGCreatePushbutton("Tilt (-)","tilt_minus")
	TagGroup TiltPlus_button = DLGCreatePushbutton("Tilt (+)","tilt_plus")
	TagGroup deltaTiltField = DLGCreateRealField(5, 7, 5).dlgidentifier("deltatiltfield")
	TagGroup TiltButtons_combined = DLGGroupitems(TiltMinus_button,deltaTiltField,TiltPlus_button).DLGtableLayout(3,1,1)
	
	// Organizing Previous TagGroups
	TagGroup top_row = DLGgroupitems(TiltButtons_combined, Start_Button).dlgtablelayout(2,1,1)
	TagGroup Total_GUI = DLGgroupitems(top_row, Val_Block).dlgtablelayout(1,2,1)
	Holo_items.DLGAddElement(Total_GUI)
	
	return Holo_box
}
// Menu Interactions
class HoloMenu : uiframe
{
	// EFFECTS: Generates combined GUI
	TagGroup ButtonCreate(object self){
		TagGroup Total = DLGGroupitems(MakeSaveDialog(),MakeAcqDialog(),MakeHoloDialog()).dlgtablelayout(1,3,1)
		return Total
	}
	
	object Launch(object self)
	{
		self.init(self.ButtonCreate())
		self.Display("Holography")
	}
	
	//Acquisition and Save Script's Buttons
	//REQUIRES: SetPath button pressed
	//EFFECTS : Runs SetPath Function
	//NOTES   : Refer to NSSaveDialog for function performance
	void SetPath(object self)
	{
		SetPathFunction(self)
	}
	
	void tilt_minus(object self)
	{
		number delta_tilt = -1*DLGGetValue(self.lookupelement("deltatiltfield"))
		
		self.Tilt_Command(delta_tilt)
	}
	
	void tilt_plus(object self)
	{
		number delta_tilt = DLGGetValue(self.lookupelement("deltatiltfield"))
		
		self.Tilt_Command(delta_tilt)
	}
	
	void start_imaging(object self)
	{
		// Grab Noah Values
		number detectChecks = 0
		number signalIndex = 0
		number dataDepth = 4
		number acquire = 1
		number imageID = 0
		number cDim
		//result("Variables instantiated")
		DLGGetValue(self.lookupelement("dimField"), cDim)
		//result("DLGGetValue used successfully")
		number cDwellT 
		DLGGetValue(self.lookupelement("dwellField"), cDwellT);
		number cImageNum 
		dlgGetValue(self.lookupelement("imageNumfield"), cImageNum)
		number sRotation
		dlgGetValue(self.lookupelement("rotationField"), sRotation)
	
		number ParamID = DSCreateParameters(cDim,cDim,sRotation,cDwellT,0)
	
	
		// Use predefined imaging parameters (see: Global Variables)
		DSSetParametersSignal(ParamID,0,dataDepth,acquire,imageID)
		
		// New Image stack
		image stack = NewImage("stack",2,cDim,cDim,angleIter)
		setName(stack,"Current")
		
		// Acquistion Loop
		number iterations = 0
		number internal_Angle = minAngle
		for(iterations; iterations < angleIter; iterations++)
		{
			EMSetStageAlpha(internal_Angle)
			DSStartAcquisition(paramID,0,1)
			image curr := getfrontimage()
			stack[0,0,iterations,cDim,cDim,iterations+1] = curr
			
			if(iterations == 0){ // Calibration Code; needed once
				imagecopycalibrationfrom(stack,curr)
			
				taggroup currTags = curr.imagegettaggroup()
				taggroup stackTags = stack.imagegettaggroup()
				taggroupcopytagsfrom(stackTags, currTags)	
			}
			internal_Angle = internal_Angle+1
			DeleteImage(curr)
			result("\n" + iterations + "\n")
		}
		ShowImage(stack)
		SaveFunction(self,0,"HOLO")
		OKdialog("Holo-capture complete\nStack Size: " + iterations )
		
	}
	
	
}

void CreateDialog()
{
	alloc(HoloMenu).Launch()
}

CreateDialog()
