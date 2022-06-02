state("MLP") {}

startup
{
	vars.Log = (Action<object>)(output => print("[A Maretime Bay Adventure] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;
}

onStart
{}

onSplit
{}

onReset
{}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var bs = helper.GetClass("Assembly-CSharp", "BaseSystem");
		var bss = helper.GetParent(helper.GetParent(bs));
		var slf = helper.GetClass("Assembly-CSharp", "SceneLoadFader");
		vars.Unity.Make<bool>(bss.Static, bss["_instance"], bs["sceneLoadFader"], slf["isLoading"]).Name = "isLoading";
		return true;
	});

	vars.Unity.Load(game);
	current.DidSplit = false;
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();
	current.Loading = vars.Unity["isLoading"].Current;
	if (current.DidSplit && !current.Loading)
	{
		current.DidSplit = false;
	}
}

start
{
	return vars.Unity.Scenes.Active.Name == "MenuScene" && current.Loading;
}

split
{
	var name = vars.Unity.Scenes.Active.Name;
	if (current.DidSplit || name == "IntroScene" || name == "MenuScene") return false;
	if (current.Loading) 
	{
		current.DidSplit = true;
		return true;
	}
	return false;
}

reset
{}

gameTime
{}

isLoading
{
	return current.Loading || vars.Unity.Scenes.Count > 1;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}
