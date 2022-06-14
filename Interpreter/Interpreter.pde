// Started 04/02/22
// Last updated 06/14/22



//String FolderToCompile = "/BallBlastClone";
String FolderToCompile = "/InterpreterTesting";
//String FolderToCompile = "/FakeOS/Entry";
//String FolderToCompile = "/CustomSwitchStatement";



import java.util.*;
import java.lang.reflect.Array;
import java.nio.file.*;



LooFCodeData TestCodeData = new LooFCodeData (new String[] {"not actual code"}, "TestCodeData");





void setup() {
  
  TestCodeData.CodeTokens = new ArrayList <ArrayList <String>> ();
  TestCodeData.TokensFollowedBySpaces = new ArrayList <ArrayList <Boolean>> ();
  
  ArrayList <String> TestTokens = ArrayToArrayList (new String[] {
    "Output",
    ".",
    ".",
    "=",
    "a",
    "=",
    "=",
    "b",
  });
  
  ArrayList <Boolean> B = ArrayToArrayList (new Boolean[] {
    true,
    false,
    false,
    true,
    true,
    false,
    true,
    false,
  });
  
  TestCodeData.CodeTokens.add(TestTokens);
  TestCodeData.TokensFollowedBySpaces.add(B);
  
  String[] CombinedTokens = {"==", "..="};
  
  LooFCompiler.CombineTokensForLine (TestCodeData, CombinedTokens, 0);
  
  for (String S : TestCodeData.CodeTokens.get(0)) println (S);
  
  
  
  LooFCompileSettings CompileSettings = new LooFCompileSettings();
  CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LexerOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.FinalOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.PrintPreProcessedLooF = true;
  CompileSettings.PrintLinkedLooF = false;
  CompileSettings.PrintLexedLooF = true;
  CompileSettings.PrintParsedLooF = false;
  CompileSettings.PrintFinalLooF = true;
  
  
  
  // compile
  /**/
  LooFEnvironment TestEnvironment = null;
  try {
    TestEnvironment = LooFCompiler.CompileEnvironmentFromFolder(new File (dataPath("") + FolderToCompile), CompileSettings);
  } catch (RuntimeException e) {
    if (!ExceptionIsLooFCompilerException (e)) e.printStackTrace();
    throw e;
  }
  
  
  
  // interpret
  int StartMillis = millis();
  try {
    LooFInterpreter.ExecuteNextEnvironmentStatements(TestEnvironment, TestEnvironment.CurrentCodeData.Statements.length - 1);
  } catch (RuntimeException e) {
    if (!ExceptionIsLooFInterpreterException (e)) e.printStackTrace();
    throw e;
  }
  println ("Execution time: " + (millis() - StartMillis) + " ms");
  
  
  
  // print vars
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
