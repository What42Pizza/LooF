// Started 04/02/22
// Last updated 06/06/22



//String FolderToCompile = "/BallBlastClone";
String FolderToCompile = "/InterpreterTesting";
//String FolderToCompile = "/FakeOS/Entry";
//String FolderToCompile = "/CustomSwitchStatement";



import java.util.*;
import java.lang.reflect.Array;
import java.nio.file.*;



LooFCodeData TestCodeData = new LooFCodeData (new String[] {"not actual code"}, "TestCodeData");





void setup() {
  
  LooFCompileSettings CompileSettings = new LooFCompileSettings();
  //CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.LexerOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.FinalOutputPath = dataPath("") + "/CompilerOutputs";
  
  LooFEnvironment TestEnvironment = null;
  //try {
    TestEnvironment = LooFCompiler.CompileEnvironmentFromFolder(new File (dataPath("") + FolderToCompile), CompileSettings);
  //} catch (RuntimeException e) {
  //  if (!ExceptionIsLooFCompilerException (e)) e.printStackTrace();
  //  throw e;
  //}
  
  ///*
  LooFInterpreter.ExecuteNextEnvironmentStatements(TestEnvironment, TestEnvironment.CurrentCodeData.Statements.length - 1);
  
  HashMap <String, LooFDataValue> AllVars = TestEnvironment.VariableListsStack.get(0);
  Set <String> AllVarKeys = AllVars.keySet();
  for (String S : AllVarKeys) {
    try {
      println (S + ": " + ConvertLooFDataValueToString (AllVars.get(S)));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  //*/
  
  exit();
  
}
