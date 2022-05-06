class LooFModule {
  
  public void HandleCall (LooFDataValue[] Args, ArrayList <LooFDataValue> GeneralStack, LooFEnvironment Environment, String FileName, int LineNumber) {
    
  }
  
}



class LooFEvaluatorOperation {
  
  public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "this LooFEvaluatorOperation does not have an overridden HandleOperation()."));
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
  
  boolean LineHasChanged = LineOfCode.equals(OriginalLineOfCode);
  
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
  
  
  
  int Type;
  
  long IntValue;
  double FloatValue;
  String StringValue;
  boolean BoolValue;
  ArrayList <LooFDataValue> ArrayValue;
  HashMap <String, LooFDataValue> HashMapValue;
  
  ArrayList <Integer> LockLevels = new ArrayList <Integer> ();
  
  
  
  public LooFDataValue() {
    Type = DataValueType_Null;
    LockLevels.add(0);
  }
  
  public LooFDataValue (long IntValue) {
    Type = DataValueType_Int;
    this.IntValue = IntValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (double FloatValue) {
    Type = DataValueType_Float;
    this.FloatValue = FloatValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (String StringValue) {
    Type = DataValueType_String;
    this.StringValue = StringValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (boolean BoolValue) {
    Type = DataValueType_Bool;
    this.BoolValue = BoolValue;
    LockLevels.add(0);
  }
  
  public LooFDataValue (ArrayList <LooFDataValue> ArrayValue, HashMap <String, LooFDataValue> HashMapValue) {
    Type = DataValueType_Table;
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
  
  
  
}



final int DataValueType_Null = 0;
final int DataValueType_Int = 1;
final int DataValueType_Float = 2;
final int DataValueType_String = 3;
final int DataValueType_Bool = 4;
final int DataValueType_Table = 5;

final String[] DataValueTypeNames = {
  "null",
  "int",
  "float",
  "string",
  "bool",
  "table",
};

final String[] DataValueTypeNames_PlusA = {
  "null",
  "an int",
  "a float",
  "a string",
  "a bool",
  "a table",
};










class LooFTokenBranch {
  
  int Type;
  long IntValue;
  double FloatValue;
  String StringValue;
  boolean BoolValue;
  LooFTokenBranch[] Children;
  
  public LooFTokenBranch (long IntValue) {
    this.Type = TokenBranchType_Int;
    this.IntValue = IntValue;
  }
  
  public LooFTokenBranch (double FloatValue) {
    this.Type = TokenBranchType_Float;
    this.FloatValue = FloatValue;
  }
  
  public LooFTokenBranch (int Type, String StringValue) {
    this.Type = Type;
    this.StringValue = StringValue;
  }
  
  public LooFTokenBranch (boolean BoolValue) {
    this.Type = TokenBranchType_Bool;
    this.BoolValue = BoolValue;
  }
  
  public LooFTokenBranch (int Type, LooFTokenBranch[] Children) {
    this.Type = Type;
    this.Children = Children;
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
