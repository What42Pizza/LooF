class LooFModule {
  
  public void HandleCall (LooFDataValue[] Args, ArrayList <LooFDataValue> GeneralStack, LooFEnvironment Environment, String FileName, int LineNumber) {
    
  }
  
}



class LooFEvaluatorOperation {
  
  public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "this LooFEvaluatorOperation does not have an overridden HandleOperation()."));
  }
  
  public float GetOrder() {
    return 0;
  }
  
}



class LooFEvaluatorFunction {
  
  public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "this LooFEvaluatorFunction does not have an overridden HandleFunctionCall()."));
  }
  
}










class LooFEnvironment {
  
  
  
  HashMap <String, LooFModule> InterpreterModules = new HashMap <String, LooFModule> ();
  
  HashMap <String, LooFEvaluatorOperation> EvaluatorOperations = new HashMap <String, LooFEvaluatorOperation> ();
  HashMap <String, LooFEvaluatorFunction > EvaluatorFunctions  = new HashMap <String, LooFEvaluatorFunction > ();
  
  
  
  HashMap <String, LooFFile> AllFiles;
  
  ArrayList <LooFDataValue> GeneralStack = new ArrayList <LooFDataValue> ();
  ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = new ArrayList <HashMap <String, LooFDataValue>> ();
  
  ArrayList <LooFDataValue[]> LockedArgumentDataValues = new ArrayList <LooFDataValue[]> ();
  
  
  
  public LooFEnvironment (HashMap <String, LooFFile> AllFiles) {
    this.AllFiles = AllFiles;
  }
  
  
  
}





class LooFFile {
  
  String FullName;
  LooFCodeData CodeData;
  
  public LooFFile (String FullName, LooFCodeData CodeData) {
    this.FullName = FullName;
    this.CodeData = CodeData;
  }
  
}





class LooFCodeData {
  
  String FullFileName;
  boolean IncludesHeader;
  
  String[] OriginalCode;
  ArrayList <String> CodeArrayList;
  ArrayList <ArrayList <String>> CodeTokens = new ArrayList <ArrayList <String>> ();
  LooFTokenBranch[][] Statements;
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





class LooFLoadedFilesData {
  
  HashMap <String, LooFCodeData> AllCodeDatas;
  String[] HeaderFileContents;
  
  public LooFLoadedFilesData (HashMap <String, LooFCodeData> AllCodeDatas, String[] HeaderFileContents) {
    this.AllCodeDatas = AllCodeDatas;
    this.HeaderFileContents = HeaderFileContents;
  }
  
}





class ReturnValue {
  
  int IntegerValue;
  String StringValue;
  String[] StringArrayValue;
  ArrayList <Integer> IntegerArrayListValue;
  ArrayList <Integer> SecondIntegerArrayListValue;
  
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
  
  boolean AddDefaultModules = true;
  boolean AddDefaultOperations = true;
  boolean AddDefaultFunctions = true;
  
  HashMap <String, LooFModule> CustomModules = new HashMap <String, LooFModule> ();
  HashMap <String, LooFEvaluatorOperation> CustomOperations = new HashMap <String, LooFEvaluatorOperation> ();
  HashMap <String, LooFEvaluatorFunction> CustomFunctions = new HashMap <String, LooFEvaluatorFunction> ();
  
  String PreProcessorOutputPath = null;
  String LinkerOutputPath = null;
  String ParserOutputPath = null;
  String LexerOutputPath = null;
  
}










class LooFCompileException extends RuntimeException {
  
  public LooFCompileException (LooFCodeData CodeData, int LineNumber, String Message) {
    super (GetCompilerErrorMessage (CodeData, CodeData.FullFileName, LineNumber, null, Message));
  }
  
  public LooFCompileException (LooFCodeData CodeData, int LineNumber, int TokenNumber, String Message) {
    super (GetCompilerErrorMessage (CodeData, CodeData.FullFileName, LineNumber, TokenNumber, Message));
  }
  
  public LooFCompileException (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
    super (GetCompilerErrorMessage (LineOfCode, LineNumber, LineFileOrigin, FileName, Message));
  }
  
  public LooFCompileException (String Message) {
    super (Message);
  }
  
  /*
  String toString() {
    return "LooFCompileException";
  }
  */
  
}



String GetCompilerErrorMessage (LooFCodeData CodeData, String FileName, int LineNumber, Integer TokenNumber, String Message) {
  int OriginalLineNumber = CodeData.LineNumbers.get(LineNumber);
  String OriginalFileName = CodeData.LineFileOrigins.get(LineNumber);
  return "File " + ErrorMessage_GetFileNameToShow (FileName, OriginalFileName) + " line " + OriginalLineNumber + "   (" + ErrorMessage_GetLineOfCodeToShow (CodeData, LineNumber, TokenNumber) + ") :   " + Message;
}



String ErrorMessage_GetFileNameToShow (String FileName, String OriginalFileName) {
  if (FileName.equals(OriginalFileName)) return "\"" + FileName + "\"";
  return "\"" + FileName + "\" (originally from file \"" + OriginalFileName + "\")";
}



String ErrorMessage_GetLineOfCodeToShow (LooFCodeData CodeData, int LineNumber, Integer TokenNumber) {
  String LineOfCodeToShow = ErrorMessage_GetLineOfCodeToShow_WithoutToken (CodeData, LineNumber);
  LineOfCodeToShow += (TokenNumber == null) ? "" : "; token \"" + CodeData.CodeTokens.get(LineNumber).get(TokenNumber) + "\"";
  return LineOfCodeToShow;
}

String ErrorMessage_GetLineOfCodeToShow_WithoutToken (LooFCodeData CodeData, int LineNumber) {
  int OriginalLineNumber    = CodeData.LineNumbers.get(LineNumber);
  String LineOfCode         = CodeData.CodeArrayList.get(LineNumber);
  String OriginalLineOfCode = CodeData.OriginalCode[OriginalLineNumber].trim();
  
  boolean LineHasChanged = !LineOfCode.equals(OriginalLineOfCode);
  
  if (OriginalLineOfCode.length() > 50) OriginalLineOfCode = OriginalLineOfCode.substring(0, 50) + " ...";
  if (LineOfCode.length() > 50) LineOfCode = LineOfCode.substring(0, 50) + " ...";
  
  if (LineHasChanged) return "\"" + OriginalLineOfCode + "\"  ->  \"" + LineOfCode + "\"";
  return "\"" + LineOfCode + "\"";
  
}



String GetCompilerErrorMessage (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
  return "File " + ErrorMessage_GetFileNameToShow (FileName, LineFileOrigin) + " line " + LineNumber + "   (\"" + LineOfCode + "\") :   " + Message;
}





class LooFInterpreterException extends RuntimeException {
  
  public LooFInterpreterException (LooFEnvironment Environment, String FileName, int LineNumber, String Message) {
    super (GetInterpreterErrorMessage (Environment, FileName, LineNumber, Message));
  }
  
}



String GetInterpreterErrorMessage (LooFEnvironment Environment, String FileName, int LineNumber, String Message) {
  LooFCodeData CodeData = Environment.AllFiles.get(FileName).CodeData;
  
  int OriginalLineNumber    = CodeData.LineNumbers.get(LineNumber);
  String OriginalLineOfCode = CodeData.OriginalCode[OriginalLineNumber].trim();
  String LineOfCode         = CodeData.CodeArrayList.get(LineNumber);
  String LineFileOrigin     = CodeData.LineFileOrigins.get(LineNumber);
  
  String FileNameToShow = (FileName.equals(LineFileOrigin)) ? ("\"" + FileName + "\"") : ("\"" + FileName + "\" (originally from file \"" + LineFileOrigin + "\")");
  String LineOfCodeToShow = (LineOfCode.equals(OriginalLineOfCode)) ? ("\"" + LineOfCode + "\"") : ("\"" + OriginalLineOfCode + "\"  ->  \"" + LineOfCode + "\"");
  
  return "File " + FileNameToShow + " line " + LineNumber + "   (" + LineOfCodeToShow + ") :   " + Message;
  
}










class LooFDataValue {
  
  
  
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
  
  
  
}



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
  
  int TokenType;
  long IntValue;
  double FloatValue;
  String StringValue;
  boolean BoolValue;
  LooFTokenBranch[] Children;
  LooFEvaluatorOperation Operation;
  LooFEvaluatorFunction Function;
  
  int[] IndexQueryIndexes;
  int[] FunctionIndexes;
  FloatIntPair[] OperationIndexes;
  
  public LooFTokenBranch (long IntValue) {
    this.TokenType = TokenBranchType_Int;
    this.IntValue = IntValue;
  }
  
  public LooFTokenBranch (double FloatValue) {
    this.TokenType = TokenBranchType_Float;
    this.FloatValue = FloatValue;
  }
  
  public LooFTokenBranch (int Type, String StringValue) {
    this.TokenType = Type;
    this.StringValue = StringValue;
  }
  
  public LooFTokenBranch (boolean BoolValue) {
    this.TokenType = TokenBranchType_Bool;
    this.BoolValue = BoolValue;
  }
  
  public LooFTokenBranch (int Type, LooFTokenBranch[] Children) {
    this.TokenType = Type;
    this.Children = Children;
  }
  
  public LooFTokenBranch (LooFEvaluatorOperation Operation, String Name) {
    this.TokenType = TokenBranchType_Operation;
    this.Operation = Operation;
    this.StringValue = Name;
  }
  
  public LooFTokenBranch (LooFEvaluatorFunction Function, String Name) {
    this.TokenType = TokenBranchType_Function;
    this.Function = Function;
    this.StringValue = Name;
  }
  
}



final int TokenBranchType_Int = 0;
final int TokenBranchType_Float = 1;
final int TokenBranchType_String = 2;
final int TokenBranchType_Bool = 3;
final int TokenBranchType_Table = 4;
final int TokenBranchType_Formula = 5;
final int TokenBranchType_Index = 6;
final int TokenBranchType_Name = 7;
final int TokenBranchType_OutputVar = 8;
final int TokenBranchType_Operation = 9;
final int TokenBranchType_Function = 10;

final String[] TokenBranchTypeNames = {
  "Int",
  "Float",
  "String",
  "Bool",
  "Table",
  "Name",
  "Formula",
  "Index",
  "OutputVar",
};

final String[] TokenBranchTypeNames_PlusA = {
  "an Int",
  "a Float",
  "a String",
  "a Bool",
  "a Table",
  "a Name",
  "a Formula",
  "an Index",
  "an OutputVar",
};
