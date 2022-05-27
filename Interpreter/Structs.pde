class LooFInterpreterModule {
  
  public void HandleCall (LooFDataValue[] Args, ArrayList <LooFDataValue> GeneralStack, LooFEnvironment Environment) {
    
  }
  
}





class LooFInterpreterAssignment {
  
  public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    throw (new LooFInterpreterException (Environment, "this LooFInterpreterAssignment does not have an overridden GetNewVarValue()."));
  }
  
  public boolean AddToCombinedTokens() {
    return false;
  }
  
  public boolean TakesArgs() {
    return true;
  }
  
}





class LooFInterpreterFunction implements Cloneable {
  
  public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    throw (new LooFInterpreterException (Environment, "this LooFInterpreterFunction does not have an overridden HandleFunctionCall()."));
  }
  
  public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    throw (new LooFCompileException (CodeData, LineNumber, "this LooFInterpreterFunction does not have an overridden FinishStatement()."));
  }
  
  public int GetBlockLevelChange() {
    return 0;
  }
  
  public boolean AddToCombinedTokens() {
    return false;
  }
  
  public Object clone() {
    try {
      return super.clone();
    } catch (CloneNotSupportedException e) {
      throw new AssertionError();
    }
  }
  
}





class LooFEvaluatorOperation {
  
  public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    throw (new LooFInterpreterException (Environment, "this LooFEvaluatorOperation does not have an overridden HandleOperation()."));
  }
  
  public float GetOrder() {
    return 0;
  }
  
  public boolean AddToCombinedTokens() {
    return false;
  }
  
  public boolean CanBePreEvaluated() {
    return true;
  }
  
}





LooFEvaluatorFunction NullEvaluatorFunction = new LooFEvaluatorFunction();

class LooFEvaluatorFunction {
  
  public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    throw (new LooFInterpreterException (Environment, "this LooFEvaluatorFunction does not have an overridden HandleFunctionCall()."));
  }
  
  public boolean AddToCombinedTokens() {
    return false;
  }
  
  public boolean CanBePreEvaluated() {
    return true;
  }
  
}





class LooFAddonsData {
  
  HashMap <String, LooFInterpreterModule> InterpreterModules;
  HashMap <String, LooFEvaluatorOperation> EvaluatorOperations;
  HashMap <String, LooFEvaluatorFunction> EvaluatorFunctions;
  HashMap <String, LooFInterpreterAssignment> InterpreterAssignments;
  HashMap <String, LooFInterpreterFunction> InterpreterFunctions;
  
}










class LooFEnvironment {
  
  
  
  HashMap <String, LooFCodeData> AllCodeDatas;
  
  LooFAddonsData AddonsData;
  
  
  
  String CurrentFileName;
  LooFCodeData CurrentCodeData;
  int CurrentLineNumber;
  
  ArrayList <LooFDataValue> GeneralStack = new ArrayList <LooFDataValue> ();
  ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = new ArrayList <HashMap <String, LooFDataValue>> ();
  
  ArrayList <String> CallStackFileNames = new ArrayList <String> ();
  ArrayList <Integer> CallStackLineNumbers = new ArrayList <Integer> ();
  ArrayList <String[]> CallStackErrorsToCatch = new ArrayList <String[]> (); 
  ArrayList <LooFDataValue[]> CallStackLockedArguments = new ArrayList <LooFDataValue[]> ();
  
  
  
  public LooFEnvironment (HashMap <String, LooFCodeData> AllCodeDatas, LooFAddonsData AddonsData) {
    this.AllCodeDatas = AllCodeDatas;
    this.AddonsData = AddonsData;
    this.CurrentFileName = "Main.LOOF";
    this.CurrentCodeData = AllCodeDatas.get(CurrentFileName);
    this.CurrentLineNumber = 0;
    this.VariableListsStack.add(new HashMap <String, LooFDataValue> ());
  }
  
  
  
}





class LooFCodeData {
  
  String FullFileName;
  boolean IncludesHeader;
  
  String[] OriginalCode;
  ArrayList <String> CodeArrayList;
  ArrayList <ArrayList <String>> CodeTokens = new ArrayList <ArrayList <String>> ();
  ArrayList <ArrayList <Boolean>> TokensFollowedBySpaces = new ArrayList <ArrayList <Boolean>> ();
  LooFStatement[] Statements;
  ArrayList <Integer> LineNumbers;
  ArrayList <String> LineFileOrigins;
  
  HashMap <String, Integer> FunctionLocations = new HashMap <String, Integer> ();
  HashMap <String, String> LinkedFiles = new HashMap <String, String> ();
  
  public LooFCodeData (String[] Code, String FullFileName) {
    this.FullFileName = FullFileName;
    this.OriginalCode = Code;
    this.CodeArrayList = new ArrayList <String> (Arrays.asList (Code));
    this.LineNumbers = CreateNumberedIntegerList (Code.length);
    this.LineFileOrigins = CreateFilledArrayList (Code.length, FullFileName);
  }
  
}





class ReturnValue {
  
  int IntValue;
  Integer IntegerValue;
  String StringValue;
  String[] StringArrayValue;
  ArrayList <Integer> IntegerArrayListValue;
  ArrayList <Integer> SecondIntegerArrayListValue;
  ArrayList <String> StringArrayListValue;
  ArrayList <Boolean> BooleanArrayListValue;
  HashMap <String, LooFCodeData> AllCodeDatas;
  
}



class FloatIntPair {
  
  float FloatValue;
  int IntValue;
  
  public FloatIntPair (float FloatValue, int IntValue) {
    this.FloatValue = FloatValue;
    this.IntValue = IntValue;
  }
  
  public String toString() {
    return IntValue + ",   " + FloatValue;
  }
  
}



class FloatIntPairComparator implements Comparator <FloatIntPair> {
  
  public int compare (FloatIntPair Pair1, FloatIntPair Pair2) {
    float FloatDifference = Pair2.FloatValue - Pair1.FloatValue;
    if (FloatDifference == 0) return 0;
    return (int) (FloatDifference / Math.abs(FloatDifference));
  }
  
}





class LooFCompileSettings {
  
  boolean AddDefaultInterpreterModules = true;
  boolean AddDefaultEvaluatorOperations = true;
  boolean AddDefaultEvaluatorFunctions = true;
  boolean AddDefaultInterpreterAssignments = true;
  boolean AddDefaultInterpreterTweakAssignments = true;
  boolean AddDefaultInterpreterFunctions = true;
  
  HashMap <String, LooFInterpreterModule> CustomModules = new HashMap <String, LooFInterpreterModule> ();
  HashMap <String, LooFEvaluatorOperation> CustomOperations = new HashMap <String, LooFEvaluatorOperation> ();
  HashMap <String, LooFEvaluatorFunction> CustomFunctions = new HashMap <String, LooFEvaluatorFunction> ();
  
  String PreProcessorOutputPath = null;
  String LinkerOutputPath = null;
  String LexerOutputPath = null;
  String ParserOutputPath = null;
  String FinalOutputPath = null;
  
}










class LooFCompileException extends RuntimeException {
  
  public LooFCompileException (LooFCodeData CodeData, int LineNumber, String Message) {
    super (GetCompilerErrorMessage (CodeData, CodeData.FullFileName, LineNumber, null, Message));
  }
  
  public LooFCompileException (LooFCodeData CodeData, int LineNumber, int TokenIndex, String Message) {
    super (GetCompilerErrorMessage (CodeData, CodeData.FullFileName, LineNumber, TokenIndex, Message));
  }
  
  public LooFCompileException (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
    super (GetCompilerErrorMessage (LineOfCode, LineNumber, LineFileOrigin, FileName, Message));
  }
  
  public LooFCompileException (String Message) {
    super (Message);
  }
  
  public LooFCompileException (Exception e) {
    super ("An error occured while compiling: " + e.toString());
  }
  
  /*
  String toString() {
    return "LooFCompileException";
  }
  */
  
}



String GetCompilerErrorMessage (LooFCodeData CodeData, String FileName, int LineNumber, Integer TokenIndex, String Message) {
  int OriginalLineNumber = CodeData.LineNumbers.get(LineNumber);
  String OriginalFileName = CodeData.LineFileOrigins.get(LineNumber);
  return "File " + ErrorMessage_GetFileNameToShow (FileName, OriginalFileName) + " line " + OriginalLineNumber + ":   " + Message + "\n\n" + ErrorMessage_GetLineOfCodeToShow (CodeData, LineNumber, TokenIndex);
}



String ErrorMessage_GetFileNameToShow (String FileName, String OriginalFileName) {
  if (FileName.equals(OriginalFileName)) return "\"" + FileName + "\"";
  return "\"" + FileName + "\" (originally from file \"" + OriginalFileName + "\")";
}



String ErrorMessage_GetLineOfCodeToShow (LooFCodeData CodeData, int LineNumber, Integer TokenIndex) {
  String LineOfCodeToShow = ErrorMessage_GetLineOfCodeToShow_WithoutToken (CodeData, LineNumber);
  LineOfCodeToShow += (TokenIndex == null) ? "" : "\nToken number " + TokenIndex + " `" + CodeData.CodeTokens.get(LineNumber).get(TokenIndex) + "`";
  return LineOfCodeToShow;
}

String ErrorMessage_GetLineOfCodeToShow_WithoutToken (LooFCodeData CodeData, int LineNumber) {
  int OriginalLineNumber    = CodeData.LineNumbers.get(LineNumber);
  String LineOfCode         = CodeData.CodeArrayList.get(LineNumber);
  String OriginalLineOfCode = CodeData.OriginalCode[OriginalLineNumber].trim();
  
  boolean LineHasChanged = !LineOfCode.equals(OriginalLineOfCode);
  
  if (OriginalLineOfCode.length() > 100) OriginalLineOfCode = OriginalLineOfCode.substring(0, 100) + " ...";
  if (LineOfCode.length() > 100) LineOfCode = LineOfCode.substring(0, 100) + " ...";
  
  if (LineHasChanged) return "Original line of code:        `" + OriginalLineOfCode + "`\nAfter pre-processor & linker: `" + LineOfCode + "`";
  return "Line of code:  `" + LineOfCode + "`";
  
}



String GetCompilerErrorMessage (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
  return "File " + ErrorMessage_GetFileNameToShow (FileName, LineFileOrigin) + " line " + LineNumber + "   (\"" + LineOfCode + "\") :   " + Message;
}





class LooFInterpreterException extends RuntimeException {
  
  public LooFInterpreterException (LooFEnvironment Environment, String Message) {
    super (GetInterpreterErrorMessage (Environment, Message));
  }
  
}



String GetInterpreterErrorMessage (LooFEnvironment Environment, String Message) {
  String FileName = Environment.CurrentFileName;
  LooFCodeData CodeData = Environment.CurrentCodeData;
  int LineNumber = Environment.CurrentLineNumber;
  
  int OriginalLineNumber    = CodeData.LineNumbers.get(LineNumber);
  String OriginalLineOfCode = CodeData.OriginalCode[OriginalLineNumber].trim();
  String LineOfCode         = CodeData.CodeArrayList.get(LineNumber);
  String LineFileOrigin     = CodeData.LineFileOrigins.get(LineNumber);
  
  boolean LineHasChanged = !LineOfCode.equals(OriginalLineOfCode);
  
  if (OriginalLineOfCode.length() > 100) OriginalLineOfCode = OriginalLineOfCode.substring(0, 100) + " ...";
  if (LineOfCode.length() > 100) LineOfCode = LineOfCode.substring(0, 100) + " ...";
  
  String LineOfCodeToShow = (LineOfCode.equals(OriginalLineOfCode)) ? ("\"" + LineOfCode + "\"") : ("\"" + OriginalLineOfCode + "\"  ->  \"" + LineOfCode + "\"");
  
  return "File " + ErrorMessage_GetFileNameToShow (FileName, LineFileOrigin) + " line " + CodeData.LineNumbers.get(LineNumber) + ":   " + Message + "\n\n" + ErrorMessage_GetLineOfCodeToShow_WithoutToken (CodeData, LineNumber);
}










class LooFDataValue implements Cloneable {
  
  
  
  int ValueType;
  
  long IntValue;
  double FloatValue;
  String StringValue;
  boolean BoolValue;
  ArrayList <LooFDataValue> ArrayValue;
  HashMap <String, LooFDataValue> HashMapValue;
  byte[] ByteArrayValue;
  
  ArrayList <Integer> LockLevels = new ArrayList <Integer> ();
  
  
  
  public LooFDataValue() {
    ValueType = DataValueType_Null;
    LockLevels.add(0);
  }
  
  public LooFDataValue (long IntValue) {
    ValueType = DataValueType_Int;
    this.IntValue = IntValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (double FloatValue) {
    ValueType = DataValueType_Float;
    this.FloatValue = FloatValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (String StringValue) {
    ValueType = DataValueType_String;
    this.StringValue = StringValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (boolean BoolValue) {
    ValueType = DataValueType_Bool;
    this.BoolValue = BoolValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (ArrayList <LooFDataValue> ArrayValue, HashMap <String, LooFDataValue> HashMapValue) {
    ValueType = DataValueType_Table;
    this.ArrayValue = ArrayValue;
    this.HashMapValue = HashMapValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (LooFDataValue[] ArrayValue) {
    ArrayList <LooFDataValue> ArrayValueAsList = ArrayToArrayList (ArrayValue);
    this.ArrayValue = ArrayValueAsList;
    this.HashMapValue = new HashMap <String, LooFDataValue> ();
    LockLevels.add(0);
  }
  
  public LooFDataValue (byte[] ByteArrayValue) {
    this.ByteArrayValue = ByteArrayValue;
    this.HashMapValue = new HashMap <String, LooFDataValue> ();
    LockLevels.add(0);
  }
  
  
  
  public LooFDataValue clone() {
    switch (ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue();
      
      case (DataValueType_Int):
        return new LooFDataValue (IntValue);
      
      case (DataValueType_Float):
        return new LooFDataValue (FloatValue);
      
      case (DataValueType_String):
        return new LooFDataValue (StringValue);
      
      case (DataValueType_Bool):
        return new LooFDataValue (BoolValue);
      
      case (DataValueType_Table):
        ArrayList <LooFDataValue> NewArrayValue = new ArrayList <LooFDataValue> ();
        HashMap <String, LooFDataValue> NewHashMapValue = new HashMap <String, LooFDataValue> ();
        for (LooFDataValue CurrentValue : ArrayValue) {
          NewArrayValue.add (CurrentValue.clone());
        }
        Set <String> HashMapKeys = HashMapValue.keySet();
        for (String CurrentKey : HashMapKeys) {
          NewHashMapValue.put(CurrentKey, HashMapValue.get(CurrentKey).clone());
        }
        return new LooFDataValue (NewArrayValue, NewHashMapValue);
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (ByteArrayValue.clone());
      
      default:
        throw new AssertionError();
      
    }
  }
  
  
  
}



final int NumOfDataValueTypes = 7;

final int DataValueType_Null = 0;
final int DataValueType_Int = 1;
final int DataValueType_Float = 2;
final int DataValueType_String = 3;
final int DataValueType_Bool = 4;
final int DataValueType_Table = 5;
final int DataValueType_ByteArray = 6;

final String[] DataValueTypeNames = {
  "null",
  "int",
  "float",
  "string",
  "bool",
  "table",
  "byteArray",
};

final String[] DataValueTypeNames_PlusA = {
  "null",
  "an int",
  "a float",
  "a string",
  "a bool",
  "a table",
  "a byteArray",
};










class LooFTokenBranch {
  
  boolean ConvertsToDataValue;
  boolean IsAction;
  int OriginalTokenIndex;
  String OriginalString;
  boolean CanBePreEvaluated = true;
  
  int TokenType;
  long IntValue;
  double FloatValue;
  String StringValue;
  boolean BoolValue;
  LooFTokenBranch[] Children;
  LooFEvaluatorOperation Operation;
  LooFEvaluatorFunction Function;
  LooFDataValue Result;
  
  int[] IndexQueryIndexes;
  int[] FunctionIndexes;
  FloatIntPair[] OperationIndexes;
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_Null;
    this.ConvertsToDataValue = true;
    this.IsAction = false;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, long IntValue) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_Int;
    this.IntValue = IntValue;
    this.ConvertsToDataValue = true;
    this.IsAction = false;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, double FloatValue) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_Float;
    this.FloatValue = FloatValue;
    this.ConvertsToDataValue = true;
    this.IsAction = false;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, int TokenType, String StringValue, boolean ConvertsToDataValue, boolean IsAction) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenType;
    this.StringValue = StringValue;
    this.ConvertsToDataValue = ConvertsToDataValue;
    this.IsAction = IsAction;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, boolean BoolValue) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_Bool;
    this.BoolValue = BoolValue;
    this.ConvertsToDataValue = true;
    this.IsAction = false;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, int TokenType, LooFTokenBranch[] Children, boolean IsAction) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenType;
    this.Children = Children;
    this.ConvertsToDataValue = true;
    this.IsAction = IsAction;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, LooFEvaluatorOperation Operation) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_EvaluatorOperation;
    this.Operation = Operation;
    this.StringValue = OriginalString;
    this.ConvertsToDataValue = false;
    this.IsAction = true;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, LooFEvaluatorFunction Function) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_EvaluatorFunction;
    this.Function = Function;
    this.StringValue = OriginalString;
    this.ConvertsToDataValue = true;
    this.IsAction = true;
  }
  
  public LooFTokenBranch (int OriginalTokenIndex, String OriginalString, LooFDataValue Result) {
    this.OriginalTokenIndex = OriginalTokenIndex;
    this.OriginalString = OriginalString;
    this.TokenType = TokenBranchType_PreEvaluatedFormula;
    this.Result = Result;
    this.ConvertsToDataValue = true;
    this.IsAction = false;
  }
  
}



final int TokenBranchType_Null = 0;
final int TokenBranchType_Int = 1;
final int TokenBranchType_Float = 2;
final int TokenBranchType_String = 3;
final int TokenBranchType_Bool = 4;
final int TokenBranchType_Table = 5;
final int TokenBranchType_Formula = 6;
final int TokenBranchType_Index = 7;
final int TokenBranchType_VarName = 8;
final int TokenBranchType_OutputVar = 9;
final int TokenBranchType_EvaluatorOperation = 10;
final int TokenBranchType_EvaluatorFunction = 11;
final int TokenBranchType_PreEvaluatedFormula = 12;

final String[] TokenBranchTypeNames = {
  "Null",
  "Int",
  "Float",
  "String",
  "Bool",
  "Table",
  "Formula",
  "Index",
  "VarName",
  "OutputVar",
  "EvaluatorOperation",
  "EvaluatorFunction",
  "PreEvaluatedFormula",
};

final String[] TokenBranchTypeNames_PlusA = {
  "a Null",
  "an Int",
  "a Float",
  "a String",
  "a Bool",
  "a Table",
  "a Formula",
  "an Index",
  "a VarName",
  "an OutputVar",
  "an EvaluatorOperation",
  "an EvaluatorFunction",
  "a PreEvaluatedFormula",
};










class LooFStatement {
  
  int StatementType;
  String Name;
  
  LooFInterpreterAssignment Assignment;
  String VarName;
  LooFTokenBranch[] IndexQueries;
  LooFTokenBranch NewValueFormula;
  
  LooFInterpreterFunction Function;
  LooFTokenBranch[] Args;
  
  public LooFStatement (String Name, String VarName, LooFTokenBranch[] IndexQueries, LooFInterpreterAssignment Assignment, LooFTokenBranch NewValueFormula) {
    this.StatementType = StatementType_Assignment;
    this.Name = Name;
    this.VarName = VarName;
    this.IndexQueries = IndexQueries;
    this.Assignment = Assignment;
    this.NewValueFormula = NewValueFormula;
  }
  
  public LooFStatement (String Name, LooFInterpreterFunction Function, LooFTokenBranch[] Args) {
    this.StatementType = StatementType_Function;
    this.Name = Name;
    this.Function = Function;
    this.Args = Args;
  }
  
}



final int StatementType_Assignment = 0;
final int StatementType_Function = 1;
