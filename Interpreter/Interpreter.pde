// Started 04/02/22
// Last updated 05/04/22



import java.util.*;
import java.lang.reflect.Array;





PrintWriter Log;





void setup() {
  
  LooFCompileSettings CompileSettings = new LooFCompileSettings();
  //CompileSettings.PreProcessorOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.LinkerOutputPath = dataPath("") + "/CompilerOutputs";
  //CompileSettings.ParserOutputPath = dataPath("") + "/CompilerOutputs";
  CompileSettings.LexerOutputPath = dataPath("") + "/CompilerOutputs";
  
  LooFInterpreter.AddNewEnvironment(new File (dataPath("")), CompileSettings);
  
  exit();
  
}
