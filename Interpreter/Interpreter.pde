// Started 04/02/22
// Last updated 05/01/22



import java.util.*;
import java.lang.reflect.Array;





PrintWriter Log;





void setup() {
  
  LooFFileCodeData CodeData = new LooFFileCodeData (new String[] {""}, "TestFileCodeData");
  ArrayList <String> Tokens = ArrayToArrayList (new String[] {
    "push",
    "[",
    "0",
    "]",
    ",",
    "(",
    "5",
    "+",
    "3",
    ")",
    "*",
    "10"
  });
  LooFTokenBranch[] Statement = LooFCompiler.GetLexedTokensForLine (Tokens, CodeData, 0);
  println (ConvertLooFStatementToString (Statement));
  
  LooFCompileSettings CompileSettings = new LooFCompileSettings();
  //CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.FinalOutputPath = dataPath("") + "/CompilerOutputs";
  
  LooFInterpreter.AddNewEnvironment(new File (dataPath("")), CompileSettings);
  
  exit();
  
}
