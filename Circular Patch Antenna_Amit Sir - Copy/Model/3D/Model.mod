'# MWS Version: Version 2016.1 - Feb 26 2016 - ACIS 25.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1.5 fmax = 4.5
'# created = '[VERSION]2016.1|25.0.2|20160226[/VERSION]


'@ use template: Antenna - Planar_1.cfg

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

'@ define brick: component1:Substrate

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Substrate" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-30", "30" 
     .Yrange "-30", "30" 
     .Zrange "0", "1.6" 
     .Create
End With

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

'@ define brick: component1:Square Patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Square Patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-30", "30" 
     .Yrange "-30", "30" 
     .Zrange "1.6", "1.6+0.035" 
     .Create
End With

'@ define brick: component1:Square Cut

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Square Cut" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-20", "20" 
     .Yrange "-20", "20" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ boolean subtract shapes: component1:Square Patch, component1:Square Cut

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:Square Patch", "component1:Square Cut"

'@ clear picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ClearAllPicks

'@ define brick: component1:Slot 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Slot 1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-30", "-20" 
     .Yrange "-0.85/2", "0.85/2" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ transform: translate component1:Slot 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot 1" 
     .Vector "0", "-1.6", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Slot 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot 1" 
     .Vector "0", "1.6", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:Rectangle Patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Rectangle Patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "3.4" 
     .Yrange "0", "3.2" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ transform: translate component1:Rectangle Patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rectangle Patch" 
     .Vector "-20", "-1.6", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Square Patch", "42"

'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Square Patch", "56"

'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "2.755146"
    .SetViewVector "0.000000", "-0.000014", "-1.000000"
    .Create
End With
Pick.ClearAllPicks

'@ transform: translate component1:Slot 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot 1" 
     .Vector "0", "0.425", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Slot 1_1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot 1_1" 
     .Vector "0", "-0.425", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch", "47"

'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch", "42"

'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.179711"
    .SetViewVector "0.000000", "-0.000009", "-1.000000"
    .Create
End With
Pick.ClearAllPicks

'@ define brick: component1:patch 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "patch 1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "3.5" 
     .Yrange "0", "15.1" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ transform: translate component1:patch 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:patch 1" 
     .Vector "-16.6", "-7.55", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:patch 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:patch 1" 
     .Vector "0", "-0.85", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ boolean add shapes: component1:Rectangle Patch, component1:patch 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Add "component1:Rectangle Patch", "component1:patch 1"

'@ paste structure data: 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ boolean subtract shapes: component1:Square Patch, component1:Slot 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:Square Patch", "component1:Slot 1"

'@ boolean subtract shapes: component1:Square Patch, component1:Slot 1_1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:Square Patch", "component1:Slot 1_1"

'@ delete shape: component1:Square Patch_1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Delete "component1:Square Patch_1"

'@ clear picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ClearAllPicks

'@ define brick: component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Rect 1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "10" 
     .Yrange "0", "3.2" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ transform: translate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Vector "-30", "-1.5", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Vector "0", "-0.1", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ paste structure data: 2

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With SAT 
     .Reset 
     .FileName "*2.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ boolean add shapes: component1:Rect 1, component1:Rectangle Patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Add "component1:Rect 1", "component1:Rectangle Patch"

'@ boolean add shapes: component1:Rectangle Patch_1, component1:Square Patch

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Add "component1:Rectangle Patch_1", "component1:Square Patch"

'@ transform: rotate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: rotate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "180", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Vector "0", "0", "1.635" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Rect 1" 
     .Vector "0", "0", "1.6" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:Slot

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Slot" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "0.85" 
     .Yrange "0", "10" 
     .Zrange "1.6", "1.635" 
     .Create
End With

'@ transform: translate component1:Slot

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot" 
     .Vector "-2.45", "-30", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: mirror component1:Slot

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Slot" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean subtract shapes: component1:Rectangle Patch_1, component1:Slot

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:Rectangle Patch_1", "component1:Slot"

'@ boolean subtract shapes: component1:Rectangle Patch_1, component1:Slot_1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:Rectangle Patch_1", "component1:Slot_1"

'@ boolean add shapes: component1:Rectangle Patch_1, component1:Rect 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Add "component1:Rectangle Patch_1", "component1:Rect 1"

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Rectangle Patch_1", "76"

'@ define port:1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
' Port constructed by macro Calculate -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1.6*5.74", "1.6*5.74"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.6", "1.6*5.74"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Rectangle Patch_1", "59"

'@ define port:2

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
' Port constructed by macro Calculate -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "2"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0", "0"
  .YrangeAdd "1.6*5.74", "1.6*5.74"
  .ZrangeAdd "1.6", "1.6*5.74"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define frequency range

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solver.FrequencyRange "1.5", "4.5"

'@ define farfield monitor: farfield (broadband)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (broadband)" 
     .Domain "Time" 
     .Accuracy "1e-3" 
     .FrequencySamples "21" 
     .FieldType "Farfield" 
     .Frequency "3" 
     .TransientFarfield "False" 
     .ExportFarfieldSource "False" 
     .Create 
End With

'@ delete monitor: e-field (f=2.4)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Monitor.Delete "e-field (f=2.4)"

'@ delete monitor: farfield (f=2.4)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Monitor.Delete "farfield (f=2.4)"

'@ delete monitor: h-field (f=2.4)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Monitor.Delete "h-field (f=2.4)"

'@ define time domain solver parameters

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Mesh.SetCreator "High Frequency" 
With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-30.0"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ switch bounding box

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Plot.DrawBox "False"

'@ pick edge

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEdgeFromId "component1:Rectangle Patch_1", "99", "66"

'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "4.852564"
    .SetViewVector "0.244633", "0.296578", "-0.923145"
    .Create
End With
Pick.ClearAllPicks

'@ pick edge

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEdgeFromId "component1:Rectangle Patch_1", "126", "82" 


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "3.014222"
    .SetViewVector "0.000000", "-0.000010", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ clear picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ClearAllPicks 


'@ pick mid point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickMidpointFromId "component1:Rectangle Patch_1", "124" 


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch_1", "82" 


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.326700"
    .SetViewVector "0.000000", "-0.000008", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch_1", "113" 


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch_1", "118" 


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.328555"
    .SetViewVector "0.000000", "-0.000002", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ activate local coordinates

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.ActivateWCS "local"


'@ align wcs with point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:Rectangle Patch_1", "74" 
WCS.AlignWCSWithSelectedPoint 


'@ define brick: component1:square path1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "square path1" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "0", "9.75" 
     .Yrange "0", "9.75" 
     .Zrange "1.6", "1.635" 
     .Create
End With


'@ pick point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickPointFromCoordinates "5.0000000014861", "11.6", "0"


'@ pick point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickPointFromCoordinates "5.0000001439202", "9.7500003458798", "-0.035"


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.658713"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ pick point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickPointFromCoordinates "9.7446424303092", "4.9930513552021", "1.635"


'@ pick point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickPointFromCoordinates "11.590249301987", "4.9931025535217", "-0.035"


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "7"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.215308"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ define brick: component1:cut square 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "cut square 1" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "0", "6.25" 
     .Yrange "0", "6.25" 
     .Zrange "1.6", "1.635" 
     .Create
End With


'@ boolean subtract shapes: component1:square path1, component1:cut square 1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Subtract "component1:square path1", "component1:cut square 1" 

'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:square path1", "18" 


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:square path1", "19" 


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "8"
    .SetOrientation "Smart Mode"
    .SetDistance "0.533464"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:square path1", "18" 


'@ pick end point

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickEndpointFromId "component1:square path1", "22" 


'@ define distance dimension by picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "9"
    .SetOrientation "Smart Mode"
    .SetDistance "1.295398"
    .SetViewVector "0.000000", "-0.000004", "-1.000000"
    .Create
End With

Pick.ClearAllPicks


'@ activate global coordinates

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
WCS.ActivateWCS "global"


