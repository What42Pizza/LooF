// Started 04/02/22
// Last updated 05/18/22



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
  HashMap <String, LooFDataValue> CurrentVariableList = TestEnvironment.VariableListsStack.get(0);
  
  HashMap <String, LooFDataValue> BallsDataHashMap = new HashMap <String, LooFDataValue> ();
  BallsDataHashMap.put("BounceVelOffset", new LooFDataValue (10));
  BallsDataHashMap.put("BounceVelScale", new LooFDataValue (5));
  CurrentVariableList.put("BallsData", new LooFDataValue (new ArrayList <LooFDataValue> (), BallsDataHashMap));
  
  HashMap <String, LooFDataValue> CurrentBallHashMap = new HashMap <String, LooFDataValue> ();
  CurrentBallHashMap.put("Size", new LooFDataValue (7));
  CurrentVariableList.put("CurrentBall", new LooFDataValue (new ArrayList <LooFDataValue> (), CurrentBallHashMap));
  
  LooFCodeData TestCodeData = TestEnvironment.AllCodeDatas.get("BallsHandler.LOOF");
  LooFTokenBranch[] TestStatement = TestCodeData.Statements[30];
  LooFTokenBranch TestFormula = TestStatement[1];
  println (ConvertLooFTokenBranchToString (TestFormula));
  
  LooFDataValue TestResult = LooFInterpreter.EvaluateFormula(TestFormula, TestEnvironment, "BallsHandler.LOOF", 30);
  println (TestResult.ValueType + " " + TestResult.IntValue);
  
  exit();
  
}
