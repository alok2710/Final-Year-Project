'# MWS Version: Version 2016.1 - Feb 26 2016 - ACIS 25.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2.2 fmax = 2.6
'# created = '[VERSION]2016.1|25.0.2|20160226[/VERSION]


'@ use template: Antenna - Planar_2.cfg

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mue "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2.2", "2.6"

Dim sDefineAt As String
sDefineAt = "2.4"
Dim sDefineAtName As String
sDefineAtName = "2.4"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .Frequency zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .Frequency zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .Frequency zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")



'@ switch bounding box

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Plot.DrawBox "False" 


'@ define material: FR-4 (lossy)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.025" 
.TanDFreq "10.0" 
.TanDGiven "True" 
.TanDModel "ConstTanD" 
.KappaM "0.0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstKappa" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "General 1st" 
.DispersiveFittingSchemeMue "General 1st" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.Rho "0.0" 
.ThermalType "Normal" 
.ThermalConductivity "0.3" 
.SetActiveMaterial "all" 
.Colour "0.94", "0.82", "0.76" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With 


'@ new component: component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Component.New "component1" 


'@ define brick: component1:substrate

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-SL/2", "SL/2" 
     .Yrange "-SW/2", "SW/2" 
     .Zrange "-SH", "0" 
     .Create
End With


'@ activate local coordinates

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.ActivateWCS "local"


'@ move wcs

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "-SH" 


'@ define material: Copper (annealed)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
.FrqType "static" 
.Type "Normal" 
.SetMaterialUnit "Hz", "mm" 
.Epsilon "1" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
.TanDModel "ConstTanD" 
.KappaM "0" 
.TanDM "0.0" 
.TanDMFreq "0.0" 
.TanDMGiven "False" 
.TanDMModel "ConstTanD" 
.DispModelEps "None" 
.DispModelMue "None" 
.DispersiveFittingSchemeEps "Nth Order" 
.DispersiveFittingSchemeMue "Nth Order" 
.UseGeneralDispersionEps "False" 
.UseGeneralDispersionMue "False" 
.FrqType "all" 
.Type "Lossy metal" 
.SetMaterialUnit "GHz", "mm" 
.Mue "1.0" 
.Kappa "5.8e+007" 
.Rho "8930.0" 
.ThermalType "Normal" 
.ThermalConductivity "401.0" 
.HeatCapacity "0.39" 
.MetabolicRate "0" 
.BloodFlow "0" 
.VoxelConvection "0" 
.MechanicsType "Isotropic" 
.YoungsModulus "120" 
.PoissonsRatio "0.33" 
.ThermalExpansionRate "17" 
.Colour "1", "1", "0" 
.Wireframe "False" 
.Reflection "False" 
.Allowoutline "True" 
.Transparentoutline "False" 
.Transparency "0" 
.Create
End With 


'@ define brick: component1:ground

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "ground" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-SL/2", "SL/2" 
     .Yrange "-SW/2", "SW" 
     .Zrange "-Mt", "0" 
     .Create
End With


'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:substrate", "1" 


'@ align wcs with face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.AlignWCSWithSelected "Face"


'@ align wcs with face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:substrate", "1" 
WCS.AlignWCSWithSelected "Face"


'@ align wcs with face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:substrate", "1" 
WCS.AlignWCSWithSelected "Face"


'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:substrate", "1" 


'@ align wcs with face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.AlignWCSWithSelected "Face"


'@ define brick: component1:patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-PL/2", "Pl/2" 
     .Yrange "-PW/2", "Pw/2" 
     .Zrange "0", "Mt" 
     .Create
End With


'@ move wcs

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.MoveWCS "local", "PL/2", "0.0", "0.0" 


'@ define brick: component1:microstrip

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "microstrip" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "ML" 
     .Yrange "-MW/2", "MW/2" 
     .Zrange "0", "Mt" 
     .Create
End With



'@ move wcs

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.MoveWCS "local", "0.0", "MW/2", "0.0" 



'@ define brick: component1:inset1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "inset1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-InL", "0" 
     .Yrange "0", "InW" 
     .Zrange "0", "Mt" 
     .Create
End With


