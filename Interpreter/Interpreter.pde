// Started 04/02/22
// Last updated 08/28/22



//final String FolderToCompile = "/BallBlastClone";
//final String FolderToCompile = "/CustomSwitchStatement";
//final String FolderToCompile = "/FakeOS/Entry";
//final String FolderToCompile = "/GraphicsTesting";
final String FolderToCompile = "/InterpreterTesting";
//final String FolderToCompile = "/PossibleMacros";
//final String FolderToCompile = "/StoryGenerator";

final boolean Windowed = true;
final int WindowWidth = 512;
final int WindowHeight = 288;
final int TargetFramerate = 1000;





import java.util.*;
import java.lang.reflect.Array;
import java.nio.file.*;
import javax.imageio.ImageIO;
import java.awt.image.*;
import java.awt.Point;
import java.awt.MouseInfo;
import java.awt.event.MouseEvent;
import java.awt.event.*;
import java.awt.Component;





LooFEnvironment Environment = null;





void setup() {
  
  
  
  // stuff that doesn't work in settings()
  
  frameRate (TargetFramerate);
  background (255);
  
  
  
  // compile
  
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
  
  try {
    Environment = LooFCompiler.CompileEnvironmentFromFolder(new File (dataPath("") + FolderToCompile), CompileSettings);
  } catch (LooFCompilerException e) {
    throw e;
  }
  
  
  
  println();
  println();
  println();
  println ("Running program...");
  println();
  
  
  
  /*
  // interpret
  println();
  println();
  println();
  println("Program output:");
  println();
  int StartMillis = millis();
  try {
    while (!Environment.IsStopped) {
      LooFInterpreter.ExecuteStatementsUntilBreak(Environment);
    }
  } catch (RuntimeException e) {
    if (!ExceptionIsLooFInterpreterException (e)) e.printStackTrace();
    throw e;
  }
  println();
  println ("Execution time: " + (millis() - StartMillis) + " ms");
  */
  
  
  
  /*
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
  */
  
  
  
}





void settings() {
  
  if (Windowed) {
    size (WindowWidth, WindowHeight);
  } else {
    fullScreen();
  }
  
}





void draw() {
  
  try {
    LooFInterpreter.ExecuteStatementsUntilBreak(Environment);
  } catch (LooFInterpreterException e) {
    throw e;
  }
  
  if (Environment.IsStopped) {
    println();
    println ("Program stopped.");
    exit();
  }
  
  //println (frameRate);
  
}
