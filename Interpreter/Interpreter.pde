// Started 04/02/22
// Last updated 06/22/22



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
  CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LexerOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.FinalOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.PrintPreProcessedLooF = false;
  CompileSettings.PrintLinkedLooF = false;
  CompileSettings.PrintLexedLooF = false;
  CompileSettings.PrintParsedLooF = false;
  CompileSettings.PrintFinalLooF = true;
  
  
  
  // compile
  LooFEnvironment TestEnvironment = null;
  try {
    TestEnvironment = LooFCompiler.CompileEnvironmentFromFolder(new File (dataPath("") + FolderToCompile), CompileSettings);
  } catch (RuntimeException e) {
    if (!ExceptionIsLooFCompilerException (e)) e.printStackTrace();
    throw e;
  }
  
  
  
  // interpret
  println();
  println("Program output:");
  int StartMillis = millis();
  try {
    LooFInterpreter.ExecuteNextEnvironmentStatements(TestEnvironment, 1000000000);
  } catch (RuntimeException e) {
    if (!ExceptionIsLooFInterpreterException (e)) e.printStackTrace();
    throw e;
  }
  println();
  println ("Execution time: " + (millis() - StartMillis) + " ms");
  
  
  
  // print vars
  println ();
  println ();
  println ();
  println ("Vars:");
  HashMap <String, LooFDataValue> AllVars = TestEnvironment.VariableListsStack.get(0);
  Set <String> AllVarKeys = AllVars.keySet();
  for (String S : AllVarKeys) {
    try {
      println (S + ": " + ConvertLooFDataValueToString (AllVars.get(S)));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  
  
  exit();
  
}
