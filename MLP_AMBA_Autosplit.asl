state("MLP") 
{
    bool isLoading: "UnityPlayer.dll", 0x019B4878, 0xD0, 0x8, 0x60, 0xA0, 0x18, 0xA0;
}

startup
{
    vars.nowLoading = false;
    vars.loadCount = 0;
}

start
{
    if (current.isLoading)
    {
        vars.loadCount = 0;
    }
    return current.isLoading;
}

isLoading 
{
    return current.isLoading;
}

update
{
    if (vars.nowLoading && !current.isLoading) 
    {
        vars.nowLoading = false;
    }
}

split
{
    if (vars.nowLoading)
    {
        return false;
    }
    
    bool shouldSplit = false;
    if (current.isLoading) {
        vars.loadCount++;
        shouldSplit = vars.loadCount > 1;
    }

    vars.nowLoading = current.isLoading;
    return shouldSplit;
}
