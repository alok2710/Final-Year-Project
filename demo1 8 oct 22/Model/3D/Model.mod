'# MWS Version: Version 2016.1 - Feb 26 2016 - ACIS 25.0.2 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0 fmax = 5
'# created = '[VERSION]2016.1|25.0.2|20160226[/VERSION]


'@ use template: Antenna - Planar.cfg

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
With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With
With Mesh
     .MeshType "PBA"
End With
'set the solver type
ChangeSolverType("HF Time Domain")

'@ new component: component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Component.New "component1"

'@ define material: Rogers RO4003C (loss free)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4003C (loss free)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "3.38" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
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
.ThermalConductivity "0.64" 
.SetActiveMaterial "all" 
.Colour "0.75", "0.95", "0.85" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ rename component: component1 to: dielctric palne

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Component.Rename "component1", "dielctric palne"

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

'@ define brick: dielctric palne:Ground plane

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Ground plane" 
     .Component "dielctric palne" 
     .Material "Copper (annealed)" 
     .Xrange "-xgr/2", "xgr/2" 
     .Yrange "-ygr/2", "ygr/2" 
     .Zrange "-.035", "0" 
     .Create
End With

'@ define brick: dielctric palne:patch antenna

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "patch antenna" 
     .Component "dielctric palne" 
     .Material "Copper (annealed)" 
     .Xrange "-xp/2", "+xp/2" 
     .Yrange "-yp/2", "+yp/2" 
     .Zrange "hp", "hp+0.035" 
     .Create
End With

'@ new component: component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Component.New "component1"

'@ define brick: component1:Microstrip Line

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Microstrip Line" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-xm\2", "xm\2" 
     .Yrange "-ym\2", "ym\2" 
     .Zrange "hp", "hp+0.035" 
     .Create
End With

'@ clear picks

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.ClearAllPicks

'@ define material: Rogers RO4003C (loss free)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Material
     .Reset
     .Name "Rogers RO4003C (loss free)"
     .Folder ""
.FrqType "all" 
.Type "Normal" 
.SetMaterialUnit "GHz", "mm"
.Epsilon "3.38" 
.Mue "1.0" 
.Kappa "0.0" 
.TanD "0.0" 
.TanDFreq "0.0" 
.TanDGiven "False" 
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
.ThermalConductivity "0.64" 
.SetActiveMaterial "all" 
.Colour "0.75", "0.95", "0.85" 
.Wireframe "False" 
.Transparency "0" 
.Create
End With

'@ define brick: dielctric palne:ground plane

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "ground plane" 
     .Component "dielctric palne" 
     .Material "Rogers RO4003C (loss free)" 
     .Xrange "-xg/2", "xg/2" 
     .Yrange "-yg/2", "yg/2" 
     .Zrange "0", "hg" 
     .Create
End With

'@ transform: rotate component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "95", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1" 
     .Vector "-0.52", "-29.2", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1" 
     .Vector "0", "6.5465", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component1:Microstrip Line

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Delete "component1:Microstrip Line"

'@ define brick: component1:Microstrip Line

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Brick
     .Reset 
     .Name "Microstrip Line" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-xm/2", "xm/2" 
     .Yrange "-ym/2", "ym/2" 
     .Zrange "hp", "hp+0.035" 
     .Create
End With

'@ transform: translate component1

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Transform 
     .Reset 
     .Name "component1" 
     .Vector "0", "-25", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Microstrip Line", "3"

'@ boolean add shapes: component1:Microstrip Line, dielctric palne:patch antenna

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solid.Add "component1:Microstrip Line", "dielctric palne:patch antenna"

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Microstrip Line", "9"

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
  .XrangeAdd "0.508*7.64", "0.508*7.64"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.508", "0.508*7.64"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Microstrip Line", "9"

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
  .XrangeAdd "0.508*7.64", "0.508*7.64"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.508", "0.508*7.64"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ pick face

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Pick.PickFaceFromId "component1:Microstrip Line", "9"

'@ define port:3

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
' Port constructed by macro Calculate -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "3"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0.508*7.64", "0.508*7.64"
  .YrangeAdd "0", "0"
  .ZrangeAdd "0.508", "0.508*7.64"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ delete port: port2

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Port.Delete "2"

'@ delete port: port3

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Port.Delete "3"

'@ define frequency range

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
Solver.FrequencyRange "0", "5"

'@ define farfield monitor: farfield (f=2.45)

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=2.45)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "2.45" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-35", "35", "-35", "35", "-0.035", "4.42412" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .Create 
End With

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

'@ define pml specials

'[VERSION]2016.1|25.0.2|20160226[/VERSION]
With Boundary
     .ReflectionLevel "0.0001" 
     .MinimumDistanceType "Fraction" 
     .MinimumDistancePerWavelengthNewMeshEngine "4" 
     .MinimumDistanceReferenceFrequencyType "User" 
     .FrequencyForMinimumDistance "1" 
     .SetAbsoluteDistance "0.0" 
End With

