// Started 04/02/22
// Last updated 05/06/22



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
  
  exit();
  
}
