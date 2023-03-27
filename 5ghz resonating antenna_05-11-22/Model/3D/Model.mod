'# MWS Version: Version 2016.1 - Feb 26 2016 - ACIS 25.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 10
'# created = '[VERSION]2016.0|25.0.2|20160122[/VERSION]


'@ use template: Antenna - Planar_2.cfg

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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
Solver.FrequencyRange "1", "10"
Dim sDefineAt As String
sDefineAt = "1;5.5;10"
Dim sDefineAtName As String
sDefineAtName = "1;5.5;10"
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

'@ define material: Copper (annealed)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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

'@ new component: ground

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Component.New "ground"

'@ define brick: ground:ground

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Brick
     .Reset 
     .Name "ground" 
     .Component "ground" 
     .Material "Copper (annealed)" 
     .Xrange "-xs/2", "xs/2" 
     .Yrange "-ys/2", "ys/2" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define material: FR-4 (lossy)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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

'@ define brick: ground:substrate

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Brick
     .Reset 
     .Name "substrate" 
     .Component "ground" 
     .Material "FR-4 (lossy)" 
     .Xrange "-xs/2", "xs/2" 
     .Yrange "-ys/2", "ys/2" 
     .Zrange "0.035", "0.035+h" 
     .Create
End With

'@ rename component: ground to: component1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Component.Rename "ground", "component1"

'@ define brick: component1:patch

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-x/2", "x/2" 
     .Yrange "-y/2", "y/2" 
     .Zrange "1.635", "1.67" 
     .Create
End With

'@ define brick: component1:feed

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Brick
     .Reset 
     .Name "feed" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-3.12/2", "3.12/2" 
     .Yrange "0", "-9" 
     .Zrange "1.635", "1.67" 
     .Create
End With

'@ pick face

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickFaceFromId "component1:patch", "3"

'@ define port:1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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
  .XrangeAdd "1.6*6.81", "1.6*6.81"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.6", "1.6*6.81"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ pick face

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickFaceFromId "component1:patch", "3"

'@ define port:2

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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
  .XrangeAdd "1.6*6.81", "1.6*6.81"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.6", "1.6*6.81"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ delete port: port2

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Port.Delete "2"

'@ define monitor: e-field (f=5.5)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=5.5)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "5.5" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-12.456", "12.456", "-9", "9", "0", "12.566" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .Create 
End With

'@ define monitor: h-field (f=5.5)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.5)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .Frequency "5.5" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-12.456", "12.456", "-9", "9", "0", "12.566" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .Create 
End With

'@ define farfield monitor: farfield (f=5.5)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=5.5)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "5.5" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-12.456", "12.456", "-9", "9", "0", "12.566" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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

'@ pick end point

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickEndpointFromId "component1:patch", "4"

'@ pick end point

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickEndpointFromId "component1:patch", "1"

'@ define distance dimension by picks

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "0.853921"
    .SetViewVector "-0.111278", "0.213738", "-0.970533"
    .Create
End With
Pick.ClearAllPicks

'@ pick end point

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickEndpointFromId "component1:substrate", "4"

'@ pick end point

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickEndpointFromId "component1:substrate", "7"

'@ define distance dimension by picks

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Dimension
    .Reset
    .UsePicks True
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "0.490638"
    .SetViewVector "0.991140", "-0.011313", "-0.132338"
    .Create
End With
Pick.ClearAllPicks

'@ delete port: port1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Port.Delete "1"

'@ transform: translate component1:feed

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Transform 
     .Reset 
     .Name "component1:feed" 
     .Vector "0", "-5.84", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:feed

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Transform 
     .Reset 
     .Name "component1:feed" 
     .Vector "0", "-0.16", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ boolean add shapes: component1:feed, component1:patch

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Solid.Add "component1:feed", "component1:patch"

'@ pick face

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.PickFaceFromId "component1:feed", "9"

'@ define port:1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
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
  .XrangeAdd "1.6*6.81", "1.6*6.81"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1.6", "1.6*6.81"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define farfield monitor: farfield (broadband)

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (broadband)" 
     .Domain "Time" 
     .Accuracy "1e-3" 
     .FrequencySamples "21" 
     .FieldType "Farfield" 
     .Frequency "5.5" 
     .TransientFarfield "False" 
     .ExportFarfieldSource "False" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "9" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0.000000e+000", "1.000000e+000", "0.000000e+000" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+000 
     .Origin "bbox" 
     .Userorigin "0.000000e+000", "0.000000e+000", "0.000000e+000" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+001" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .StoreSettings
End With

'@ define pml specials

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Boundary
     .ReflectionLevel "0.0001" 
     .MinimumDistanceType "Fraction" 
     .MinimumDistancePerWavelengthNewMeshEngine "4" 
     .MinimumDistanceReferenceFrequencyType "User" 
     .FrequencyForMinimumDistance "1" 
     .SetAbsoluteDistance "0.0" 
End With

'@ transform: mirror component1:feed

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Transform 
     .Reset 
     .Name "component1:feed" 
     .Origin "Free" 
     .Center "100", "0", "0" 
     .PlaneNormal "0", "0", "1" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ delete shape: component1:feed_1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Solid.Delete "component1:feed_1"

'@ transform: mirror component1:feed

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
With Transform 
     .Reset 
     .Name "component1:feed" 
     .Origin "Free" 
     .Center "10", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ delete shape: component1:feed_1

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Solid.Delete "component1:feed_1"

'@ align wcs with face

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:substrate", "1" 
WCS.AlignWCSWithSelected "Face"

'@ move wcs

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "1.6"

'@ move wcs

'[VERSION]2016.0|25.0.2|20160122[/VERSION]
WCS.MoveWCS "local", "0.0", "0.0", "-3.2" 

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
     .AutoNormImpedance "True"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With


