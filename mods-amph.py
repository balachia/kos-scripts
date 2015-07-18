#!/usr/bin/python
import subprocess

mods = [
    #"ActiveTextureManagement-x86-Aggressive",
    "AGExt",
    "AlternateResourcePanel",
    "AnalogControl",
    "AstronomersPack",
    "AstronomersPack-DistantObjectEnhancement",
    "CapCom",
    "Chatterer",
    "CoherentContracts",
    "CommunityResourcePack",
    "CommunityTechTree",
    "ConnectedLivingSpace",
    "ContractConfigurator",
    ##"ContractConfigurator-AdvancedProgression",
    "ContractConfigurator-AnomalySurveyor",
    "ContractConfigurator-BaseConstuction",
    "ContractConfigurator-ContractPack-SCANsat",
    "ContractConfigurator-FieldResearch",
    "ContractConfigurator-KerbalAircraftBuilders",
    "ContractConfigurator-KerbinSpaceStation",
    "ContractConfigurator-RemoteTech",
    "ContractConfigurator-Tourism",
    "ContractsWindowPlus",
    "ControlLock",
    "CrewQueue",
    "CustomBarnKit",
    "DMagicOrbitalScience",
    "DockingPortAlignmentIndicator",
    "FerramAerospaceResearch",
    "FinalFrontier",
    #"FingerboxesCore",
    #"FirespitterCore",
    #"FirespitterResourcesConfig",
    "HotRockets",
    "HotSpot",
    "ImprovedChaseCamera",
    "InfernalRobotics",
    #"InterstellarFuelSwitch-Core",
    "KAS",
    "KerbalAircraftExpansion",
    "KerbalAlarmClock",
    "KerbalEngineerRedux",
    "KerbalJointReinforcement",
    "KIS",
    "kOS",
    "LSPFlags",
    #"ModularFlightIntegrator",
    "ModuleManager",
    "NavballDockingIndicator",
    #"NearFutureProps",
    "NearFutureConstruction",
    "NearFutureSolar",
    "NearFutureElectrical",
    "NearFuturePropulsion",
    "NearFutureSpacecraft",
    "PlanetShine",
    "PreciseNode",
    "ProceduralFairings",
    "QuickScroll",
    "QuickSearch",
    "RasterPropMonitor",
    "RCSBuildAid",
    "RealChute",
    "RemoteTech",
    ##"RKE-Joystick",
    #"SAVE",
    "SCANsat",
    "ScienceAlert",
    "SETI-CommunityTechTree",
    "SETI-Contracts",
    "ShipManifest",
    "StageRecovery",
    "StationPartsExpansion",
    "StationScience",
    "surfacelights",
    "TakeCommand",
    #"TextureReplacer",
    "Toolbar",
    ##"Trajectories",
    "TweakScale",
    "UKS",
    "UniversalStorage",
    "USI-LS",
    #"USITools",
    "WaypointManager",
    ""]

mod_override = [
    "ContractConfigurator-AdvancedProgression=4.5",
    #"RKE-Joystick=1.2.1",
    "Trajectories=v1.3.0a",
    ""]

subprocess.call(['ckan','install'] + mods + mod_override)

