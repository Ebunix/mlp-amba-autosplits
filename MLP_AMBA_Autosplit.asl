state("MLP") 
{
    bool isLoading: "UnityPlayer.dll", 0x019B4878, 0xD0, 0x8, 0x60, 0xA0, 0x18, 0xA0;
}

startup
{
    vars.loadCount = 0;
}

onReset
{
    vars.loadCount = 0;
}

start
{
    return !old.isLoading && current.isLoading;
}

split
{
    if (!old.isLoading && current.isLoading)
    {
        vars.loadCount++;
        return vars.loadCount > 1;
    }
}

isLoading 
{
    return current.isLoading;
}
