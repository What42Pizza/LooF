class LooFModule {
  
  
  
  public void HandleCall (LooFDataValue[] Args, ArrayList <LooFDataValue> GeneralStack) {
    
  }
  
  
  
}










class LooFEnvironment {
  
  
  
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
  LooFFileCodeData CodeData;
  
  public LooFFile (String FullName, LooFFileCodeData CodeData) {
    this.FullName = FullName;
    this.CodeData = CodeData;
  }
  
}





class LooFFileCodeData {
  
  String FullName;
  boolean IncludesHeader;
  
  String[] OriginalCode;
  ArrayList <String> CodeArrayList;
  ArrayList <ArrayList <String>> CodeTokens = new ArrayList <ArrayList <String>> ();
  LooFTokenBranch[][] Statements;
  ArrayList <Integer> LineNumbers;
  ArrayList <String> LineFileOrigins;
  
  HashMap <String, Integer> FunctionLocations = new HashMap <String, Integer> ();
  HashMap <String, String> LinkedFiles = new HashMap <String, String> ();
  
  public LooFFileCodeData (String[] Code, String FullName) {
    this.FullName = FullName;
    this.OriginalCode = Code;
    this.CodeArrayList = new ArrayList <String> (Arrays.asList (Code));
    this.LineNumbers = CreateNumberedIntegerList (Code.length);
    this.LineFileOrigins = CreateFilledArrayList (Code.length, FullName);
  }
  
}





class LooFLoadedFilesData {
  
  HashMap <String, LooFFileCodeData> AllCodeDatas;
  String[] HeaderFileContents;
  
  public LooFLoadedFilesData (HashMap <String, LooFFileCodeData> AllCodeDatas, String[] HeaderFileContents) {
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
  
  String PreProcessorOutputPath = null;
  String LinkerOutputPath = null;
  String ParserOutputPath = null;
  String LexerOutputPath = null;
  
}










class LooFCompileException extends RuntimeException {
  
  public LooFCompileException (LooFFileCodeData CodeData, int LineNumber, String Message) {
    super (GetCompilerErrorMessage (CodeData, CodeData.FullName, CodeData.LineNumbers.get(LineNumber), Message));
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



String GetCompilerErrorMessage (LooFFileCodeData CodeData, String FileName, int LineNumber, String Message) {
  
  int OriginalLineNumber    = CodeData.LineNumbers.get(LineNumber);
  String OriginalLineOfCode = CodeData.OriginalCode[OriginalLineNumber].trim();
  String LineOfCode         = CodeData.CodeArrayList.get(LineNumber);
  String LineFileOrigin     = CodeData.LineFileOrigins.get(LineNumber);
  
  String FileNameToShow = (FileName.equals(LineFileOrigin)) ? ("\"" + FileName + "\"") : ("\"" + FileName + "\" (originally from file \"" + LineFileOrigin + "\")");
  String LineOfCodeToShow = (LineOfCode.equals(OriginalLineOfCode)) ? ("\"" + LineOfCode + "\"") : ("\"" + OriginalLineOfCode + "\"  ->  \"" + LineOfCode + "\"");
  
  return "File " + FileNameToShow + " line " + LineNumber + "   (" + LineOfCodeToShow + ") :   " + Message;
  
}



String GetCompilerErrorMessage (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
  
  String FileNameToShow = (FileName.equals(LineFileOrigin)) ? ("\"" + FileName + "\"") : ("\"" + FileName + "\" (originally from file \"" + LineFileOrigin + "\")");
  
  return "File " + FileNameToShow + " line " + LineNumber + "   (\"" + LineOfCode + "\") :   " + Message;
  
}





class LooFInterpreterException extends RuntimeException {
  
  public LooFInterpreterException (LooFEnvironment Environment, String FileName, int LineNumber, String Message) {
    super (GetInterpreterErrorMessage (Environment, FileName, LineNumber, Message));
  }
  
}



String GetInterpreterErrorMessage (LooFEnvironment Environment, String FileName, int LineNumber, String Message) {
  LooFFileCodeData CodeData = Environment.AllFiles.get(FileName).CodeData;
  
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
  
  double NumberValue;
  String StringValue;
  boolean BoolValue;
  ArrayList <LooFDataValue> TableValue;
  HashMap <String, LooFDataValue> HashMapValue;
  
  ArrayList <Integer> LockLevels = new ArrayList <Integer> ();
  
  
  
  public LooFDataValue() {
    Type = DataValueType_Null;
    LockLevels.add(0);
  }
  
  public LooFDataValue (double NumberValue) {
    Type = DataValueType_Number;
    this.NumberValue = NumberValue;
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
  
  public LooFDataValue (ArrayList <LooFDataValue> TableValue, HashMap <String, LooFDataValue> HashMapValue) {
    Type = DataValueType_Table;
    this.TableValue = TableValue;
    this.HashMapValue = HashMapValue;
    LockLevels.add(0);
  }
  
  
  
}



final int DataValueType_Null = 0;
final int DataValueType_Number = 1;
final int DataValueType_String = 2;
final int DataValueType_Bool = 3;
final int DataValueType_Table = 4;

final String[] DataValueTypeNames = {
  "null",
  "number",
  "string",
  "bool",
  "table",
};

final String[] DataValueTypeNames_PlusA = {
  "null",
  "a number",
  "a string",
  "a bool",
  "a table",
};










class LooFTokenBranch {
  
  int Type;
  double NumberValue;
  String StringValue;
  boolean BoolValue;
  LooFTokenBranch[] Children;
  
  public LooFTokenBranch (double NumberValue) {
    this.Type = TokenBranchType_Number;
    this.NumberValue = NumberValue;
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



final int TokenBranchType_Number = 0;
final int TokenBranchType_String = 1;
final int TokenBranchType_Bool = 2;
final int TokenBranchType_Table = 3;
final int TokenBranchType_Name = 4;
final int TokenBranchType_Formula = 5;
final int TokenBranchType_Index = 6;
final int TokenBranchType_OutputVar = 7;

final String[] TokenBranchTypeNames = {
  "Number",
  "String",
  "Bool",
  "Table",
  "Name",
  "Formula",
  "Index",
  "OutputVar",
};

final String[] TokenBranchTypeNames_PlusA = {
  "a Number",
  "a String",
  "a Bool",
  "a Table",
  "a Name",
  "a Formula",
  "an Index",
  "an OutputVar",
};
