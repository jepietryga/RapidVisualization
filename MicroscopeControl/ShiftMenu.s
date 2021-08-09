// Code for testing stage movements of a microscope
// Some safety valves placed for microscope protection
// Edit at own peril

// By Jacob Pietryga (2020.7.31)

// GLOBAL VARIABLES

number stage_safety = 5 // um
number beamshift_safety = 10 // raw
number df_safety = 1000 // raw
number tilt_safety = 30 // degrees

// Sub-functions
void UpdateValues(object given){
	number imagex,imagey,imagez,alpha,beta,df,bx,by
	EMGetBeamShift(bx,by)
	EMGetStagePositions(15,imagex,imagey,imagez,alpha,beta)
	df = EMGetFocus()
	dlgvalue(given.lookupelement("currX"),imagex)
	dlgvalue(given.lookupelement("currY"),imagey)
	dlgvalue(given.lookupelement("currZ"),imagez)
	dlgvalue(given.lookupelement("currDF"),df)
	dlgvalue(given.lookupelement("currTilt"),alpha)
	dlgvalue(given.lookupelement("currBeamShiftX"),bx)
	dlgvalue(given.lookupelement("currBeamShiftY"),by)
}



void IncrementCommand(object given,number increment,string mode){
	
	number safetyCheck = abs(increment)
	number value
	
	if(mode == "X"){
		if(safetyCheck > stage_safety){
			okdialog("STAGE SAFETY FACTOR OF " + stage_safety + " VIOLATED")
			return
		}
		else{
			value = EMGetStageX() + increment
			EMSetStageX(value)
		}
	}
	else if(mode == "Y"){
		if(safetyCheck > stage_safety){
			okdialog("STAGE SAFETY FACTOR OF " + stage_safety + " VIOLATED")
			return
		}
		else{
			value = EMGetStageY() + increment
			EMSetStageY(value)
		}
	}
	else if(mode == "Z"){
		if(safetyCheck > stage_safety){
			okdialog("STAGE SAFETY FACTOR OF " + stage_safety + " VIOLATED")
			return
		}
		else{
			value = EMGetStageZ() + increment
			EMSetStageZ(value)
		}
	}
	else if(mode == "DF"){
		if(safetyCheck > df_safety){
			okdialog("STAGE DEFOCUS FACTOR OF " + df_safety + " VIOLATED")
			return
		}
		else{
			value = EMGetFocus() + increment
			EMSetFocus(value)
		}
	}
	else if(mode == "T"){
		if(safetyCheck > tilt_safety){
			okdialog("BEAMSHIFT FACTOR OF " + tilt_safety + " VIOLATED")
			return
		}
		else{
			value = EMGetStageAlpha() + increment
			EMSetStageAlpha(value)
		}
	}
	else if(mode == "Bx"){
		if(safetyCheck > beamshift_safety){
			okdialog("BEAMSHIFT FACTOR OF " + beamshift_safety + " VIOLATED")
			return
		}
		else{
			number bx, by
			EMGetBeamshift(bx,by)
			value = bx + increment
			EMSetBeamShift(value,by)
		}
	}
	else if(mode == "By"){
		if(safetyCheck > beamshift_safety){
			okdialog("BEAMSHIFT FACTOR OF " + beamshift_safety + " VIOLATED")
			return
		}
		else{
			number bx, by
			EMGetBeamshift(bx,by)
			value = by + increment
			EMSetBeamShift(bx,value)
		}
	}
	else{
		okdialog("UNRECOGNIZED MODE")
	}
	UpdateValues(given)
}

//GUI Designs
TagGroup MakeShiftingDialog(){
	TagGroup Shift_items = newTagGroup()
	TagGroup Shift_Box = DLGCreateBox("Shift", Shift_items)

	// INCREMENT (TL)
	TagGroup Increment_Label = DLGCreateLabel("Increment")
	TagGroup Increment_Field = DLGCreateRealField(0,9,5).dlgidentifier("increment_field")
	TagGroup Increment_Column = DLGGroupItems(Increment_Label,Increment_Field).DLGTableLayout(1,2,0)

	// SHIFT BLOCK (TR)
	// Labels
	TagGroup XShift_Label = DLGCreateLabel("X")
	TagGroup YShift_LAbel = DLGCreateLabel("Y")
	TagGroup ZShift_Label = DLGCreateLabel("Z")
	TagGroup TiltShift_Label = DLGCreateLabel("Tilt")
	TagGroup DFShift_Label = DLGCreateLabel("DF")
	TagGroup BeamShiftX_Label = DLGCreateLabel("Bx")
	TagGroup BeamShiftY_Label = DLGCreateLabel("By")
	
	// (-) Buttons
	TagGroup XShift_minus_Button = DLGCreatePushButton("-","xshift_minus_button")
	TagGroup YShift_minus_Button = DLGCreatePushButton("-","yshift_minus_button")
	TagGroup ZShift_minus_Button = DLGCreatePushButton("-","zshift_minus_button")
	TagGroup TiltShift_minus_Button = DLGCreatePushButton("-","tiltshift_minus_button")
	TagGroup DFShift_minus_Button = DLGCreatePushButton("-","dfshift_minus_button")
	TagGroup BeamShiftX_minus_Button = DLGCreatePushButton("-","beamshiftx_minus_button")
	TagGroup BeamShiftY_minus_Button = DLGCreatePushButton("-","beamshifty_minus_button")
	
	// (+) Buttons
	TagGroup XShift_plus_Button = DLGCreatePushButton("+","xshift_plus_button")
	TagGroup YShift_plus_Button = DLGCreatePushButton("+","yshift_plus_button")
	TagGroup ZShift_plus_Button = DLGCreatePushButton("+","zshift_plus_button")
	TagGroup TiltShift_plus_Button = DLGCreatePushButton("+","tiltshift_plus_button")
	TagGroup DFShift_plus_Button = DLGCreatePushButton("+","dfshift_plus_button")
	TagGroup BeamShiftX_plus_Button = DLGCreatePushButton("+","beamshiftx_plus_button")
	TagGroup BeamShiftY_plus_Button = DLGCreatePushButton("+","beamshifty_plus_button")
	
	// Row Combines
	TagGroup XShift_row = DLGGroupItems(XShift_minus_button,XShift_Label,XShift_plus_button).dlgtablelayout(3,1,0)
	TagGroup YShift_row = DLGGroupItems(YShift_minus_button,YShift_Label,YShift_plus_button).dlgtablelayout(3,1,0)
	TagGroup ZShift_row = DLGGroupItems(ZShift_minus_button,ZShift_Label,ZShift_plus_button).dlgtablelayout(3,1,0)
	TagGroup TiltShift_row = DLGGroupItems(TiltShift_minus_button,TiltShift_Label,TiltShift_plus_button).dlgtablelayout(3,1,0)
	TagGroup DFShift_row = DLGGroupItems(DFShift_minus_button,DFShift_Label,DFShift_plus_button).dlgtablelayout(3,1,0)
	TagGroup BeamShiftX_row = DLGGroupItems(BeamShiftX_minus_button,BeamShiftX_Label,BeamShiftX_plus_button).dlgtablelayout(3,1,0)
	TagGroup BeamShiftY_row = DLGGroupItems(BeamShiftY_minus_button,BeamShiftY_Label,BeamShiftY_plus_button).dlgtablelayout(3,1,0)
	
	// ShiftBlock Forming
	TagGroup XYZShift_block = DLGGroupItems(XShift_row,YShift_row,ZShift_row).dlgtablelayout(1,3,0)
	TagGroup TiltDFShift_block = DLGGroupItems(TiltShift_row,DFShift_Row).dlgtablelayout(1,2,0)
	TagGroup BeamShiftXY_block = DLGGroupItems(BeamShiftX_row,BeamShiftY_row).dlgtablelayout(1,2,0)
	TagGroup TotalShift_block = DLGGroupItems(XYZShift_Block,TiltDFShift_block,BeamShiftXY_block).dlgtablelayout(3,1,0)
	
	// VALUE BLOCK (B)
	TagGroup Empty_Label = DLGCreateLabel("")
	TagGroup X_Label = DLGCreateLabel("X\n(um)")
	TagGroup Y_Label = DLGCreateLabel("Y\n(um)")
	TagGroup Z_Label = DLGCreateLabel("Z\n(um)")
	TagGroup DF_Label = DLGCreateLabel("Defocus\n(um)")
	TagGroup Tilt_Label = DLGCreateLabel("Tilt\n(degrees)")
	TagGroup val_BeamShiftX_Label = DLGCreateLabel("Bx\n(raw)")
	TagGroup val_BeamShiftY_Label = DLGCreateLabel("By\n(raw)")
	
	TagGroup Curr_Label = DLGCreateLabel("Current: ")
	TagGroup CurrX = DLGCreateRealField(0,9,5).dlgidentifier("currX")
	TagGroup CurrY = DLGCreateRealField(0,9,5).dlgidentifier("currY")
	TagGroup CurrZ = DLGCreateRealField(0,9,5).dlgidentifier("currZ")
	TagGroup CurrDF = DLGCreateRealField(0,9,5).dlgidentifier("currDF")
	TagGroup CurrTilt = DLGCreateRealField(0,9,5).dlgidentifier("currTilt")
	TagGroup CurrBeamShiftX = DLGCreateRealField(0,9,5).dlgidentifier("currBeamShiftX")
	TagGroup CurrBeamShiftY = DLGCreateRealField(0,9,5).dlgidentifier("currBeamShiftY")
	
	TagGroup Label_column = DLGgroupitems(Empty_Label, Curr_Label).dlgtablelayout(1,2,1)
	TagGroup X_column = DLGgroupitems(X_Label, CurrX).dlgtablelayout(1,2,1)
	TagGroup Y_column = DLGgroupitems(Y_Label, CurrY).dlgtablelayout(1,2,1)
	TagGroup Z_column = DLGgroupitems(Z_Label, CurrZ).dlgtablelayout(1,2,1)
	TagGroup dF_column = DLGgroupitems(DF_Label, CurrDF).dlgtablelayout(1,2,1)
	TagGroup tilt_column = DLGGroupitems(Tilt_Label, CurrTilt).dlgtablelayout(1,2,1)
	TagGroup BeamShiftX_column = DLGGroupitems(val_BeamShiftX_Label, CurrBeamShiftX).dlgtablelayout(1,2,1)
	TagGroup BeamShiftY_column = DLGGroupitems(val_BeamShiftY_Label, CurrBeamShiftY).dlgtablelayout(1,2,1)
	
	
	TagGroup ValXYZ_Block = DLGgroupitems(X_column,Y_column,Z_column).dlgtablelayout(3,1,1)
	TagGroup ValTiltDF_Block = DLGGroupItems(dF_column,tilt_column).dlgtablelayout(2,1,1)
	TagGroup ValBeamShiftXY_Block = DLGGroupItems(BeamShiftX_column,BeamShiftY_column).dlgtablelayout(2,1,1)
	TagGroup ValTotal_Block = DLGgroupitems(Label_Column, ValXYZ_Block, ValTiltDF_Block,ValBeamShiftXY_Block).dlgtablelayout(4,1,0)
	
	// COMBINE TOTAL
	TagGroup top_row = DLGGroupItems(Increment_Column,TotalShift_Block).dlgtablelayout(2,1,1)
	TagGroup Total_GUI = DLGGroupItems(top_row,ValTotal_Block).dlgtablelayout(1,2,1)
	Shift_items.DLGAddElement(Total_GUI)
	
	return Shift_box
}

class ShiftMenu :uiframe
{
	TagGroup ButtonCreate(object self){
		TagGroup Total = (MakeShiftingDialog())
		return Total
	}
	
	object Launch(object self)
	{
		self.init(self.ButtonCreate())
		self.Display("Shifting")
	}
	
	
	// Minus Buttons
	void xshift_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"X")
	}
	
	void yshift_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Y")
	}
	
	void zshift_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Z")
	}
	
	void dfshift_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"DF")
	}
	
	void tiltshift_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"T")
	}
	
	void beamshiftx_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Bx")
	}
	
	void beamshifty_minus_button(object self){
		number increment = -1*DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"By")
	}
	
	// POSITIVE BUTTONS
	void xshift_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"X")
	}
	
	void yshift_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Y")
	}
	
	void zshift_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Z")
	}
	
	void dfshift_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"DF")
	}
	
	void tiltshift_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"T")
	}
	
	void beamshiftx_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"Bx")
	}
	
	void beamshifty_plus_button(object self){
		number increment = DLGGetValue(self.lookupelement("increment_field"))
		
		IncrementCommand(self,increment,"By")
	}
}

void CreateDialog()
{
	alloc(ShiftMenu).Launch()
}

CreateDialog()