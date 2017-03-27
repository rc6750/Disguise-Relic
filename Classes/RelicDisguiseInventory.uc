//=============================================================================
// Relic of Disguise
// Relic Mutation created by Bog_Wraith (grave@tampabay.rr.com). 
// Basically, this relic will change your team color to the opposing team color
// for the duration you own the relic. 
//
// Important:
//	-You must have the UT-BonusPack installed or this won't work.
// 	-This is designed for two team CTF (or possibly Domination). 
//	-Support for two teams only (Red and Blue)
//	-Will NOT, repeat NOT, fool any sort of computer AI (gun turrets, bots, etc).
//	 It only changes your skin color, not your team information.
//	-Supports the following player models:
//		Male Soldiers
//		Female Soldiers
//		Male Commandos
//		Female Commandos
//		Skaarj
//		Nali
//		Nali WarCow
//		Boss
// 		Chrek Army
//=============================================================================
class RelicDisguiseInventory expands RelicInventory;

#exec MESH IMPORT MESH=mask ANIVFILE=MODELS\mask_a.3d DATAFILE=MODELS\mask_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=mask X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=mask SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=mask SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=mask MESH=mask
#exec MESHMAP SCALE MESHMAP=mask X=0.1 Y=0.1 Z=0.2

//#exec TEXTURE IMPORT NAME=Jtex1 FILE=textures\texture1.pcx GROUP=Skins FLAGS=2
//#exec TEXTURE IMPORT NAME=Jtex1 FILE=textures\texture1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=mask NUM=1 TEXTURE=Botpack.RipperPulse.Heexpl1_a00

var pawn 		Target;
var string 		SkinName;
var int			FixedSkin;
var int			SkinNo;
var string		DefaultSkinName;
var string		DefaultPackage;
var int			SkinType;


//This function gets the skin of the actor
//----------------------------------------------------------------------------------
function GetMultiSkin( actor SkinActor, out string SkinName, out int SkinNo )
{
	local string ShortSkinName, FullSkinName, datestamp, zero;
	
	datestamp = ""$Level.Year;
		if( Level.Month < 10 ) zero = "0"; else zero = "";
                datestamp = datestamp $ zero $Level.Month;
		if( Level.Day < 10 ) zero = "0"; else zero = "";
	        datestamp = datestamp $ zero $Level.Day;
		if( Level.Hour < 10 ) zero = "0"; else zero = "";
	        datestamp = datestamp $ zero $Level.Hour;
		if( Level.Minute < 10 ) zero = "0"; else zero = "";
		datestamp = datestamp $ zero $Level.Minute;
		if( Level.Second < 10 ) zero = "0"; else zero = "";
		datestamp = datestamp $ zero $Level.Second;	

        Log("-----------------------------------------");
	Log(datestamp);
	Log(SkinActor.Multiskins[0]);
	Log(SkinActor.Multiskins[1]);
	Log(SkinActor.Multiskins[2]);
	Log(SkinActor.Multiskins[3]);
	
	if (Left(String(SkinActor.Multiskins[0]), 12) == "SoldierSkins")
	{
		FixedSkin = 0;
		SkinNo = 1;
		SkinType = 1;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 10) == "SGirlSkins")
	{
		FixedSkin = 0;
		SkinNo = 1;
		SkinType = 1;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 9) == "BossSkins")
	{
		FixedSkin = 0;
		SkinNo = 1;
		SkinType = 2;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 14) == "FCommandoSkins")
	{
		FixedSkin = 0;
		SkinNo = 1;
		SkinType = 1;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 9) == "tskmskins")
	{
		FixedSkin = 2;
		SkinNo = 3;
		SkinType = 1;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 13) == "CommandoSkins")
	{
		FixedSkin = 2;
		SkinNo = 3;
		SkinType = 1;
	}
	else if (Left(String(SkinActor.Multiskins[1]), 13) == "TCowMeshSkins")
	{
		FixedSkin = 2;
		SkinNo = 0;
		SkinType = 4;
	}
	else if (Left(String(SkinActor.Multiskins[0]), 14) == "TNaliMeshSkins")
	{
		FixedSkin = 0;
		SkinNo = 0;
		SkinType = 3;
	}
	else if(Left(String(SkinActor.Multiskins[1]), 10) == "chrekskins")
	{
		FixedSkin = 1;
		SkinNo = 2;
		SkinType = 1;
	}

	Log(FixedSkin);
	Log(SkinNo);
	Log(SkinType);
	Log("-----------------------------------------");	

	FullSkinName  = String(SkinActor.Multiskins[FixedSkin]);
	ShortSkinName = SkinActor.GetItemName(FullSkinName);

	SkinName = Left(FullSkinName, Len(FullSkinName) - Len(ShortSkinName)) $ Left(ShortSkinName, 4);
	Log(SkinName);

}


//This function sets the actual skin elements.
//-------------------------------------------------------------------------------------------

function SetSkinElement(Actor SkinActor, int SkinNo, string SkinName)
{
	local Texture NewSkin;

	NewSkin = Texture(DynamicLoadObject(SkinName, class'Texture'));
	if ( NewSkin != None )
	{
		SkinActor.Multiskins[SkinNo] = NewSkin;
		return;
	}
	else
	{
		log("Failed to load "$SkinName);
		return;
	}
}

//This function should set the different skins of the actor(pawn)
//--------------------------------------------------------------------------------------------

function SetMultiSkin( actor SkinActor, string SkinName, byte TeamNum )
{
	local string MeshName, SkinItem, SkinPackage;

	MeshName = SkinActor.GetItemName(string(SkinActor.Mesh));

	SkinItem = SkinActor.GetItemName(SkinName);
	SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));

	// Set the team elements
	if( TeamNum != 255 )
	{
		if (SkinType == 1)
		{
			SetSkinElement(SkinActor, FixedSkin, SkinName$string(SkinNo)$"T_"$String(TeamNum));
			SetSkinElement(SkinActor, (FixedSkin+1), SkinName$string(SkinNo+1)$"T_"$String(TeamNum));
		}
		else if (SkinType == 2)
		{
			SetSkinElement(SkinActor, FixedSkin, SkinName$string(SkinNo)$"T_"$String(TeamNum));
			SetSkinElement(SkinActor, (FixedSkin+1), SkinName$string(SkinNo+1)$"T_"$String(TeamNum));
			SetSkinElement(SkinActor, (FixedSkin+2), SkinName$string(SkinNo+2)$"T_"$String(TeamNum));	
			SetSkinElement(SkinActor, (FixedSkin+3), SkinName$string(SkinNo+3)$"T_"$String(TeamNum));
		}
		else if (SkinType == 3)
		{
			SetSkinElement(SkinActor, FixedSkin, "TNaliMeshSkins.T_Nali_"$String(TeamNum));
		}
		else if (SkinType == 4)
		{
			SetSkinElement(SkinActor, FixedSkin, "TCowMeshSkins.T_cow_"$String(TeamNum));
		}
			
	}
	else
	{
		Log("Hell, bitch needs to get a team first..");
	}

		
}

//Actual change color functions
//----------------------------------------------------------------------------------
function ChangeColorBlue() 
{

	SetMultiSkin( Target, SkinName, 1);
}

function ChangeColorRed()
{
	SetMultiSkin( Target, SkinName, 0);
}


//States
//----------------------------------------------------------------------------------
state Activated
{
	function BeginState()
	{
		Target = Pawn(Owner);

		GetMultiSkin(Target, SkinName, SkinNo);		

		if (Target.PlayerReplicationInfo.Team == 1)
		{			
			ChangeColorRed();
		}
		else if  (Target.PlayerReplicationInfo.Team == 0)
		{
			ChangeColorBlue();
		}
	}

	function EndState()
	{
		Target = Pawn(Owner);

		GetMultiSkin(Target, SkinName, SkinNo);		
			
		if (Target.PlayerReplicationInfo.Team == 1)
		{
			ChangeColorBlue();
		}
		else if  (Target.PlayerReplicationInfo.Team == 0)
		{
			ChangeColorRed();
		}
	}
}

defaultproperties
{
     ShellSkin=Texture'Relics.Skins.RelicPurple'
     PickupMessage="You picked up the Relic of Disguise!"
     PickupViewMesh=LodMesh'DisguiseRelicv10.Mask'
     Icon=Texture'Relics.Icons.RelicIconVengeance'
     Physics=PHYS_Rotating
     Texture=Texture'Botpack.RipperPulse.Heexpl1_a00'
     Skin=Texture'Botpack.RipperPulse.Heexpl1_a00'
     CollisionHeight=40.000000
     LightHue=185
     LightSaturation=0
}
