LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  ArrayList <LooFEnvironment> AllEnvironments = new ArrayList <LooFEnvironment> ();
  
  HashMap <String, LooFModule> AllModules = new HashMap <String, LooFModule> ();
  
  
  
  
  
  void AddNewEnvironment (File CodeFolder) {
    AddNewEnvironment (CodeFolder, new LooFCompileSettings());
  }
  
  void AddNewEnvironment (File CodeFolder, LooFCompileSettings CompileSettings) {
    if (CodeFolder == null) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File argument is null)."));
    if (!CodeFolder.exists()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File does not exist)."));
    if (!CodeFolder.isDirectory()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument. (File is not a folder)."));
    if (CompileSettings == null) throw (new LooFCompileException ("AddNewEnvironment cannot take a null LoofCompileSettings object. Either pass a new LooFCompileSettings object or call AddNewEvironment with no LooFCompileSettings argument."));
    
    LooFEnvironment NewEnvironment = LooFCompiler.CompileEnvironmentFromFolder (CodeFolder, CompileSettings);
    AllEnvironments.add(NewEnvironment);
    
  }
  
  
  
  
  
}
