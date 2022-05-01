class LooFModule {
  
  
  
  public void HandleCall (LooFDataValue[] Args, ArrayList <LooFDataValue> GeneralStack) {
    
  }
  
  
  
}










class LooFEnvironment {
  
  
  
  HashMap <String, LooFFile> AllFiles;
  
  ArrayList <LooFDataValue> GeneralStack = new ArrayList <LooFDataValue> ();
  ArrayList <HashMap <String, LooFDataValue>> AllVarListStacks = new ArrayList <HashMap <String, LooFDataValue>> ();
  
  
  
  public LooFEnvironment (HashMap <String, LooFFile> AllFiles) {
    this.AllFiles = AllFiles;
  }
  
  
  
}





class LooFFile {
  
  
  
  String FullName;
  
  
  
}





class LooFFileCodeData {
  
  String FullName;
  boolean IncludesHeader;
  
  String[] OriginalCode;
  ArrayList <String> CodeArrayList;
  ArrayList <ArrayList <String>> CodeTokens = new ArrayList <ArrayList <String>> ();
  LooFTokenBranch[][] CodeTokenTrees;
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
  String FinalOutputPath = null;
  
}










class LooFCompileException extends RuntimeException {
  
  public LooFCompileException (LooFFileCodeData CodeData, int LineNumber, String Message) {
    this (CodeData.CodeArrayList.get(LineNumber), CodeData.LineNumbers.get(LineNumber), CodeData.LineFileOrigins.get(LineNumber), CodeData.FullName, Message);
  }
  
  public LooFCompileException (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
    super (GetErrorMessageToShow (LineOfCode, LineNumber, LineFileOrigin, FileName, Message));
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



String GetErrorMessageToShow (String LineOfCode, int LineNumber, String LineFileOrigin, String FileName, String Message) {
  
  if (LineFileOrigin.equals(FileName))
    return "File \"" + LineFileOrigin + "\" line " + LineNumber + "   (\"" + LineOfCode + "\") :   " + Message;
  
  return "File \"" + FileName + "\" (originally from file \"" + LineFileOrigin + "\") line " + LineNumber + "  (\"" + LineOfCode + "\") :   " + Message;
  
}










class LooFDataValue {
  
  
  
  int Type;
  
  double NumberValue;
  String StringValue;
  boolean BoolValue;
  ArrayList <LooFDataValue> TableValue;
  
  
  
  public LooFDataValue() {
    Type = DVType_Null;
  }
  
  public LooFDataValue (double NumberValue) {
    Type = DVType_Number;
    this.NumberValue = NumberValue;
  }
  
  public LooFDataValue (String StringValue) {
    Type = DVType_String;
    this.StringValue = StringValue;
  }
  
  public LooFDataValue (boolean BoolValue) {
    Type = DVType_Bool;
    this.BoolValue = BoolValue;
  }
  
  public LooFDataValue (ArrayList <LooFDataValue> TableValue) {
    Type = DVType_Table;
    this.TableValue = TableValue;
  }
  
  
  
}



final int DVType_Null = 0;
final int DVType_Number = 1;
final int DVType_String = 2;
final int DVType_Bool = 3;
final int DVType_Table = 4;

final String[] DVTypeNames = {
  "null",
  "number",
  "string",
  "bool",
  "table",
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
