// Started 04/02/22
// Last updated 05/19/22



import java.util.*;
import java.lang.reflect.Array;





PrintWriter Log;





void setup() {
  
  LooFCompileSettings CompileSettings = new LooFCompileSettings();
  //CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LexerOutputPath = dataPath("") + "/CompilerOutputs";
  
  LooFEnvironment TestEnvironment = LooFCompiler.CompileEnvironmentFromFolder(new File (dataPath("")), CompileSettings);
  
  /*
  LooFInterpreter.ExecuteNextEnvironmentStatements(TestEnvironment, 3);
  
  HashMap <String, LooFDataValue> AllVars = TestEnvironment.VariableListsStack.get(0);
  Set <String> AllVarKeys = AllVars.keySet();
  for (String S : AllVarKeys) {
    try {
      println (S + ": " + ConvertLooFDataValueToString (AllVars.get(S)));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  */
  
  exit();
  
}
