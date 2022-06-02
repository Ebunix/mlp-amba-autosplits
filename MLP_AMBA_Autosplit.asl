state("MLP") {}

startup
{
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
        vars.baseSystem = helper.GetClass("Assembly-CSharp", "BaseSystem");
        vars.baseSystemSingleton = helper.GetParent(helper.GetParent(vars.baseSystem));
        vars.sceneLoadFader = helper.GetClass("Assembly-CSharp", "SceneLoadFader");

        vars.asyncOpHandle = helper.GetClass("Unity.ResourceManager", "UnityEngine.ResourceManagement.AsyncOperations.AsyncOperationHandle`1");
        vars.asyncOpBase = helper.GetClass("Unity.ResourceManager", "UnityEngine.ResourceManagement.AsyncOperations.AsyncOperationBase`1");

        vars.asyncOp = helper.GetClass("UnityEngine.CoreModule", "UnityEngine.AsyncOperation");
        vars.sceneInstance = helper.GetClass("Unity.ResourceManager", "UnityEngine.ResourceManagement.ResourceProviders.SceneInstance");

        vars.Unity.Make<bool>(
            vars.baseSystemSingleton.Static, vars.baseSystemSingleton["_instance"],
            vars.baseSystem["sceneLoadFader"],
            vars.sceneLoadFader["isLoading"]
        ).Name = "load";
        
//        for (int i = 0; i < 0x20; i++) {
//            vars.Unity.Make<byte>(
//                vars.baseSystemSingleton.Static, vars.baseSystemSingleton["_instance"]
//                ,vars.baseSystem["sceneLoadFader"]
//                ,vars.sceneLoadFader["addressableScene"]
//                ,vars.asyncOpHandle["m_Version"]
//                ,vars.asyncOpBase["Result"]
//                ,vars.sceneInstance["m_Operation"] + i
//            ).Name = "init" + i;
//        }
        
        for (int i = 0; i < 0x20; i++) {
            vars.Unity.Make<int>(
                vars.baseSystemSingleton.Static, vars.baseSystemSingleton["_instance"],
                vars.baseSystem["sceneLoadFader"],
                vars.sceneLoadFader["addressableScene"],
                vars.asyncOpHandle["m_Version"],
                vars.asyncOpBase["Result"],
                vars.sceneInstance["m_Operation"] + 28 // Seems to be -1 usually, switched to 0 when operating
            ).Name = "init";
        }

        vars.done = true;
		return true;
	});

    vars.done = false;
	vars.Unity.Load(game);
    vars.changedToLoading = false;
}

start
{
    return vars.changedToLoading;
}

isLoading 
{
    return vars.Unity["load"].Current || (vars.Unity["init"].Current != -1);
}

update
{
    if (!vars.done) return false;

    vars.Unity.Update();
    vars.changedToLoading = vars.Unity["load"].Current && !vars.Unity["load"].Old;

//    string text = "";
    
//    for (int i = 0; i < 0x20; i++) {
//        text += vars.Unity["init" + i].Current.ToString("X2") + " ";
//    }
//    print("Init " + text + "| Loading " + vars.Unity["load"].Current + " | Init " + vars.Unity["init"].Current);
}

split
{
    return vars.changedToLoading;
}
