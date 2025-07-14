state("Lithtech", "v1002")
{
	byte gameState	: "cshell.dll", 0x11AC9C, 0xAED0;
	byte missionID	: "cshell.dll", 0x1198C0, 0x1114;
	byte sceneID	: "cshell.dll", 0x1198C0, 0x1115;
}

state("Lithtech", "v1003")
{
	byte gameState	: "cshell.dll", 0x12F9CC, 0xAE70;
	byte missionID	: "cshell.dll", 0x12E020, 0x1114;
	byte sceneID	: "cshell.dll", 0x12E020, 0x1115;
}

state("Lithtech", "v1004")
{
	byte gameState	: "cshell.dll", 0x130B8C, 0xAE70;
	byte missionID	: "cshell.dll", 0x12F1E0, 0x1114;
	byte sceneID	: "cshell.dll", 0x12F1E0, 0x1115;
}

state("Lithtech", "LithFix")
{
	byte gameState	: "CShellReal.dll", 0x130B8C, 0xAE70;
	byte missionID	: "CShellReal.dll", 0x12F1E0, 0x1114;
	byte sceneID	: "CShellReal.dll", 0x12F1E0, 0x1115;
}

state("Lithtech", "Modernizer")
{
	byte gameState	: "cshell.dll", 0x22754C, 0xAE70;
	sbyte missionID	: "cshell.dll", 0x214D5C;
	sbyte sceneID	: "cshell.dll", 0x214D5D;
}

init
{
	var tmp = modules.First(m => m.ModuleName == "cshell.dll").ModuleMemorySize;
	if (tmp == 172032) {
		version = "LithFix";
		print(tmp.ToString() + ": LithFix");
	} else if (tmp == 2392064) {
		version = "Modernizer";
		print(tmp.ToString() + ": Modernizer");
	} else if (tmp == 1249280) {
		version = "v1002";
		print(tmp.ToString() + ": v1002");
	} else if (tmp == 1339392) {
		version = "v1003";
		print(tmp.ToString() + ": v1003");
	} else if (tmp == 1343488) {
		version = "v1004";
		print(tmp.ToString() + ": v1004");
	} else {
		version = tmp.ToString();
		print("Unknown Memory Size: " + tmp.ToString());
	}
	// This array has the scene count for all the missions in the game for avoiding double splits
	int[] missioncount = {3,4,1,3,2,1,2,1,5,1,3,1,3,1,6,1,3,1,4,2,1,4,4,2,2};
	vars.MissionArray = missioncount;
}

start
{
	return current.missionID == 0 && current.sceneID == 0 && old.gameState == 2 && current.gameState == 1;
}

isLoading
{
	return current.gameState == 2;
}

split
{
	// We need to also check if the scene number is valid since the addresses sometimes jump to a non existing scene number, not just scene or mission change
	return (current.missionID == old.missionID + 1 || (current.sceneID == old.sceneID + 1 && current.sceneID != vars.MissionArray[current.missionID])) && !(current.missionID == 0 && current.sceneID == 1);
}

exit
{
	timer.IsGameTimePaused = true;
}
