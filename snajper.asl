state("lithtech"){
    bool LoadState: "lithtech.exe", 0x0100518, 0xE60;
    int level: "lithtech.exe", 0x01A5B88, 0x10, 0x20, 0x10, 0x1C, 0xA8, 0x5C, 0xB0;
    int finalCutscene: "lithtech.exe", 0x01A5490, 0x0, 0x0, 0xC, 0x0, 0x3C, 0x188, 0x47C;
}
init{
    vars.split=0;
}
isLoading{
    if(old.LoadState==current.LoadState && old.LoadState){
        return true;
    }
    else{
        return false;
    }
}
update{
    if(timer.CurrentSplitIndex==0){
        vars.splitTime=timer.CurrentTime.ToString().Split(':')[2].Substring(0,2);
        if(current.LoadState && old.LoadState && Convert.ToInt32(vars.splitTime)<2){
            timer.SetGameTime(new TimeSpan(0,0,0,0,0));
        }
    }
    if(!current.LoadState && vars.split==1){
        vars.split=0;
    }
}
split{
    if(current.level!=old.level && vars.split!=1){
        vars.split=1;
        return true;
    }
    if(timer.CurrentSplitIndex==25 && current.finalCutscene==1){
        return true;
    }
}