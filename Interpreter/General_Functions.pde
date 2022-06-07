// Array to ArrayList:  Output = new ArrayList <T> (Arrays.asList (Input));
// ArrayList to Array:  Output = Input.toArray(new T [Input.size()]);



<T> ArrayList <T> ArrayToArrayList (T[] Input) {
  return new ArrayList <T> (Arrays.asList (Input));
}

<T> T[] ListToArray (List <T> Input, T ExampleItem) {
  return Input.toArray((T[]) Array.newInstance(ExampleItem.getClass(), Input.size()));
}



// copied (and simplified) from stack exchange: https://stackoverflow.com/a/80503
<T> T ConcatArrays (T a, T b) {
  int aLen = Array.getLength(a);
  int bLen = Array.getLength(b);
  @SuppressWarnings("unchecked")
  T result = (T) Array.newInstance(a.getClass().getComponentType(), aLen + bLen);
  System.arraycopy(a, 0, result, 0, aLen);
  System.arraycopy(b, 0, result, aLen, bLen);
  return result;
}



<T> T LastItemOf (ArrayList <T> Input) {
  return Input.get(Input.size() - 1);
}

<T> T LastItemOf (T[] Input) {
  return Input[Input.length - 1];
}



<T> boolean TableContainsItem (T[] Input, T Item) {
  for (int i = 0; i < Input.length; i ++) {
    if (Input[i].equals(Item)) return true;
  }
  return false;
}



<T> void AddItemToArrayStart (T[] ArrayIn, T Item) {
  T[] ArrayOut = (T[]) Array.newInstance(Item.getClass(), ArrayIn.length + 1);
  for (int i = 0; i < ArrayIn.length; i ++) {
    ArrayOut[i + 1] = ArrayIn[i];
  }
  ArrayOut[0] = Item;
}

<T> T[] RemoveItemsFromArrayStart (T[] ArrayIn, T Item, int NumOfItemsToRemove) {
  T[] ArrayOut = (T[]) Array.newInstance(Item.getClass(), ArrayIn.length - NumOfItemsToRemove);
  for (int i = 0; i < ArrayOut.length; i ++) {
    ArrayOut[i] = ArrayIn[i + NumOfItemsToRemove];
  }
  return ArrayOut;
}



int[] ToPrimitive (Integer[] ArrayIn) {
  int[] ArrayOut = new int [ArrayIn.length];
  for (int i = 0; i < ArrayIn.length; i ++) {
    ArrayOut[i] = ArrayIn[i];
  }
  return ArrayOut;
}

char[] ToPrimitive (Character[] ArrayIn) {
  char[] ArrayOut = new char [ArrayIn.length];
  for (int i = 0; i < ArrayIn.length; i ++) {
    ArrayOut[i] = ArrayIn[i];
  }
  return ArrayOut;
}

Boolean[] ToObject (boolean[] ArrayIn) {
  Boolean[] ArrayOut = new Boolean [ArrayIn.length];
  for (int i = 0; i < ArrayIn.length; i ++) {
    ArrayOut[i] = ArrayIn[i];
  }
  return ArrayOut;
}





boolean ExceptionIsLooFCompilerException (RuntimeException e) {
  return e.getClass().equals(LooFCompilerException.class);
}





class StringComparator_ShortestToLongest implements Comparator <String> {
  public int compare (String String1, String String2) {
    return String1.length() - String2.length();
  }
}





long CorrectModulo (long A, long B) {
  long FirstModulo = A % B;
  long PositiveResult = FirstModulo + B;
  return PositiveResult % B;
}


double CorrectModulo (double A, double B) {
  double FirstModulo = A % B;
  double PositiveResult = FirstModulo + B;
  return PositiveResult % B;
}





// from stack overflow: https://stackoverflow.com/questions/21092086/get-random-element-from-collection by Peter Lawrey https://stackoverflow.com/users/57695/peter-lawrey
<T> T GetRandomItemFromCollection (Collection <T> CollectionIn) {
  int ChosenIndex = (int) (Math.random() * CollectionIn.size());
  for (T CurrentItem : CollectionIn) {
    if (--ChosenIndex < 0) return CurrentItem;
  }
  throw new AssertionError();
}









ArrayList <File> GetAllFilesInFolder (File FolderIn) {
  ArrayList <File> AllFiles = new ArrayList <File> ();
  ArrayList <File> FoldersToCheck = new ArrayList <File> ();
  FoldersToCheck.add (FolderIn);
  
  while (FoldersToCheck.size() > 0) {
    File CurrentFolder = FoldersToCheck.remove(FoldersToCheck.size() - 1);
    File[] FilesToAdd = CurrentFolder.listFiles();
    for (File CurrentFile : FilesToAdd) {
      ArrayList <File> ArrayListToAddTo = CurrentFile.isDirectory() ? FoldersToCheck : AllFiles;
      ArrayListToAddTo.add (CurrentFile);
    }
  }
  
  return AllFiles;
}





ArrayList <File> GetAllParentsUpToAncestor (File StartingFile, File Ancestor) {
  ArrayList <File> Ancestors = new ArrayList <File> ();
  File CurrentFile = StartingFile;
  while (!CurrentFile.equals(Ancestor)) {
    CurrentFile = CurrentFile.getParentFile();
    Ancestors.add (CurrentFile);
  }
  return Ancestors;
}





String GetFileFullName (File CurrentFile, File CodeFolder) {
  ArrayList <File> Ancestors = GetAllParentsUpToAncestor (CurrentFile, CodeFolder);
  Ancestors.remove(Ancestors.size() - 1);
  String FullName = CurrentFile.getName();
  for (File Ancestor : Ancestors) {
    FullName = Ancestor.getName() + '.' + FullName;
  }
  FullName = FullName.replace(' ', '_');
  return FullName;
}





void DeleteAllFilesOfType (String FolderPath, String TypeToRemove) {
  File FolderAsFile = new File (FolderPath);
  if (!FolderAsFile.exists()) return;
  File[] FolderChildren = FolderAsFile.listFiles();
  for (File CurrentFile : FolderChildren) {
    if (CurrentFile.getName().endsWith(TypeToRemove)) CurrentFile.delete();
  }
}





String[] ReadFileAsStrings (File FileToRead) throws IOException {
  List <String> FileContents = Files.readAllLines(FileToRead.toPath());
  return ListToArray (FileContents, "");
}




String ReplaceFileExtention (String FileNameIn, String NewFileExtention) {
  int PeriodIndex = FileNameIn.lastIndexOf('.');
  if (PeriodIndex == -1) throw (new RuntimeException ("Could not replace the extention of the file name \"" + FileNameIn + "\"."));
  return FileNameIn.substring(0, PeriodIndex) + '.' + NewFileExtention;
}



String RemoveFileExtention (String FileNameIn) {
  int PeriodIndex = FileNameIn.lastIndexOf('.');
  if (PeriodIndex == -1) throw (new RuntimeException ("Could not remove the extention of the file name \"" + FileNameIn + "\"."));
  return FileNameIn.substring(0, PeriodIndex);
}










ArrayList <Integer> CreateNumberedIntegerList (int Size) {
  ArrayList <Integer> ArrayListOut = new ArrayList <Integer> ();
  for (int i = 0; i < Size; i ++) {
    ArrayListOut.add (i);
  }
  return ArrayListOut;
}




<T> ArrayList <T> CreateFilledArrayList (int Size, T FillObject) {
  ArrayList <T> ArrayListOut = new ArrayList <T> ();
  for (int i = 0; i < Size; i ++) {
    ArrayListOut.add (FillObject);
  }
  return ArrayListOut;
}





boolean CharIsWhitespace (char CharIn) {
  return
    CharIn == ' ' ||
    CharIn == 9;     // tab
}



boolean StringIsWhitespace (String StringIn) {
  char[] StringInChars = StringIn.toCharArray();
  for (char CurrChar : StringInChars) {
    if (!CharIsWhitespace (CurrChar)) return false;
  }
  return true;
}



boolean CharStartsNewToken (char CharIn) {
  return !(
    (CharIn >= 'a' && CharIn <= 'z') ||
    (CharIn >= 'A' && CharIn <= 'Z') ||
    (CharIn >= '0' && CharIn <= '9') ||
    CharIn == '_' ||
    CharIn == '.'
  );
}



boolean TokenIsInt (String Token) {
  char[] TokenChars = Token.toCharArray();
  if (TokenChars.length == 1 && TokenChars[0] == '-') return false;
  for (int i = 0; i < TokenChars.length; i ++) {
    char CurrChar = TokenChars[i];
    if (CurrChar == '-' && i == 0) continue;
    if (!CharIsDigit (CurrChar)) return false;
  }
  return true;
}



boolean TokenIsFloat (String Token) {
  char[] TokenChars = Token.toCharArray();
  if (TokenChars.length == 1 && (TokenChars[0] == '-' || TokenChars[0] == '.')) return false;
  if (TokenChars.length == 2 && TokenChars[0] == '-' && TokenChars[1] == '.') return false;
  boolean HasPeriod = false;
  for (int i = 0; i < TokenChars.length; i ++) {
    char CurrChar = TokenChars[i];
    if (CurrChar == '-' && i == 0) continue;
    if (CurrChar == '.') {
        if (HasPeriod) return false;
        HasPeriod = true;
        continue;
      }
    if (!CharIsDigit (CurrChar)) {
      return false;
    }
  }
  return true;
}

boolean CharIsDigit (char CharIn) {
  return CharIn >= '0' && CharIn <= '9';
}



boolean StringContainsLetters (String StringIn) {
  char[] StringChars = StringIn.toCharArray();
  for (char CurrentChar : StringChars) {
    if (CharIsLetter (CurrentChar)) return true;
  }
  return false;
}



boolean CharIsLetter (char CurrentChar) {
  return
    (CurrentChar >= 'a' && CurrentChar <= 'z') ||
    (CurrentChar >= 'A' && CurrentChar <= 'Z')
  ;
}





String[] FormatBackslashes (String StringIn) {
  char[] InputStringChars = StringIn.toCharArray();
  ArrayList <String> FormattedStrings = new ArrayList <String> ();
  String CurrentString = "";
  
  for (int i = 0; i < InputStringChars.length; i ++) {
    char CurrentChar = InputStringChars[i];
    
    if (CurrentChar != '\\') {
      CurrentString += CurrentChar;
      continue;
    }
    
    i ++;
    char FollowingChar = InputStringChars[i];
    
    switch (FollowingChar) {
      
      case ('n'):
        FormattedStrings.add(CurrentString);
        CurrentString = "";
        continue;
      
      default:
        CurrentString += FollowingChar;
        continue;
      
    }
    
  }
  
  FormattedStrings.add (CurrentString);
  return FormattedStrings.toArray(new String [FormattedStrings.size()]);
}



String FormatBackslashes_SingleStringReturn (String StringIn) {
  String[] FormattedString = FormatBackslashes (StringIn);
  return CombineStringsWithSeperator (FormattedString, "\n");
}





ArrayList <String> GetSpaceSeperatedStrings (String StringIn) {
  ArrayList <String> StringsOut = new ArrayList <String> ();
  char[] StringInChars = StringIn.toCharArray();
  String CurrentString = "";
  boolean InQuotes = false;
  for (int i = 0; i < StringInChars.length; i ++) {
    char CurrentChar = StringInChars[i];
    
    if (CurrentChar == ' ' && !InQuotes) {
      StringsOut.add (CurrentString);
      CurrentString = "";
      continue;
    }
    
    // toggle InQuotes if quotes are encountered
    InQuotes ^= CurrentChar == '"';
    
    CurrentString += CurrentChar;
    
  }
  StringsOut.add (CurrentString);
  return StringsOut;
}





String CombineStringsWithSeperator (ArrayList <String> StringsIn, String Seperator) {
  int StringsInSize = StringsIn.size();
  if (StringsInSize == 0) return "";
  String StringOut = StringsIn.get(0);
  for (int i = 1; i < StringsInSize; i ++) {
    StringOut += Seperator + StringsIn.get(i);
  }
  return StringOut;
}


String CombineStringsWithSeperator (String[] StringsIn, String Seperator) {
  if (StringsIn == null) return "null";
  int StringsInSize = StringsIn.length;
  if (StringsInSize == 0) return "";
  String StringOut = StringsIn[0];
  for (int i = 1; i < StringsInSize; i ++) {
    StringOut += Seperator + StringsIn[i];
  }
  return StringOut;
}










HashMap <String, Integer> TimerCounts = new HashMap <String, Integer> ();
HashMap <String, Integer> TimerStartMilliss = new HashMap <String, Integer> ();

void StartTimer (String TimerName) {
  TimerStartMilliss.put(TimerName, millis());
}

void StopTimer (String TimerName) {
  int PrevTime = TimerCounts.getOrDefault(TimerName, 0);
  int NewTime = PrevTime + (millis() - TimerStartMilliss.get(TimerName));
  TimerCounts.put(TimerName, NewTime);
}

int GetTimerMillis (String TimerName) {
  return TimerCounts.get(TimerName);
}










String ConvertLooFStatementToString (LooFStatement Statement) {
  switch (Statement.StatementType) {
    
    case (StatementType_Assignment):
      String NewValueFormulaAsString = (Statement.Assignment.TakesArgs()) ? " " + ConvertLooFTokenBranchToString (Statement.NewValueFormula) : "";
      return "Assignment \"" + Statement.VarName + "\"" + ConvertStatementIndexesToString (Statement) + " '" + Statement.Name + "'" + NewValueFormulaAsString;
    
    case (StatementType_Function):
      ArrayList <String> ArgsAsStrings = new ArrayList <String> ();
      for (LooFTokenBranch CurrentTokenBranch : Statement.Args) {
        ArgsAsStrings.add(ConvertLooFTokenBranchToString (CurrentTokenBranch));
      }
      return "Function " + Statement.Function.toString(Statement) + "   Args: (" + CombineStringsWithSeperator (ArgsAsStrings, ", ") + ")";
    
    default:
      throw new AssertionError();
    
  }
}





String ConvertStatementIndexesToString (LooFStatement Statement) {
  String Output = "";
  LooFTokenBranch[] IndexQueries = Statement.IndexQueries;
  for (LooFTokenBranch CurrentToken : IndexQueries) {
    Output += " [" + ConvertLooFTokenBranchToString (CurrentToken) + "]";
  }
  return Output;
}





String ConvertLooFTokenBranchToString (LooFTokenBranch TokenBranch) {
  switch (TokenBranch.TokenType) {
    
    default:
      throw new AssertionError();
    
    case (TokenBranchType_Null):
      return "Null";
    
    case (TokenBranchType_Int):
      return "Int " + TokenBranch.IntValue;
    
    case (TokenBranchType_Float):
      return "Float " + TokenBranch.FloatValue;
    
    case (TokenBranchType_String):
      return "String \"" + TokenBranch.StringValue + "\"";
    
    case (TokenBranchType_Bool):
      return "Bool " + TokenBranch.BoolValue;
    
    case (TokenBranchType_Table):
      return "Table {" + ConvertLooFTokenBranchChildrenToString (TokenBranch) + "}";
    
    case (TokenBranchType_Formula):
      return "Formula {" + ConvertLooFTokenBranchChildrenToString (TokenBranch) + "}";
    
    case (TokenBranchType_Index):
      return "Index {" + ConvertLooFTokenBranchChildrenToString (TokenBranch) + "}";
    
    case (TokenBranchType_VarName):
      return "VarName \"" + TokenBranch.StringValue + "\"";
    
    case (TokenBranchType_OutputVar):
      return "OutputVar \"" + TokenBranch.StringValue + "\"";
    
    case (TokenBranchType_EvaluatorOperation):
      return "Operation \"" + TokenBranch.StringValue + "\"";
    
    case (TokenBranchType_EvaluatorFunction):
      return "Function \"" + TokenBranch.StringValue + "\"";
    
    case (TokenBranchType_PreEvaluatedFormula):
      return "PreEvaluatedFormula {" + ConvertLooFDataValueToString (TokenBranch.Result) + "}";
    
  }
}





String ConvertLooFTokenBranchChildrenToString (LooFTokenBranch TokenBranch) {
  ArrayList <String> Output = new ArrayList <String> ();
  for (LooFTokenBranch CurrentChild : TokenBranch.Children) {
    Output.add(ConvertLooFTokenBranchToString (CurrentChild));
  }
  return CombineStringsWithSeperator (Output, ", ");
  
}





String ConvertLooFDataValueToString (LooFDataValue DataValueIn) {
  switch (DataValueIn.ValueType) {
    
    case (DataValueType_Null):
      return "null";
    
    case (DataValueType_Int):
      return DataValueIn.IntValue + "";
    
    case (DataValueType_Float):
      return DataValueIn.IntValue + "";
    
    case (DataValueType_String):
      return "\"" + DataValueIn.StringValue + "\"";
    
    case (DataValueType_Bool):
      return DataValueIn.BoolValue ? "true" : "false";
    
    case (DataValueType_Table):
      return ConvertLooFDataValueTableToString (DataValueIn);
    
    case (DataValueType_ByteArray):
      return new String (DataValueIn.ByteArrayValue);
    
    case (DataValueType_Function):
      String PageName = DataValueIn.FunctionPageValue;
      return "Function at " + DataValueIn.FunctionLineValue + (PageName != null ? " in " + PageName : "");
    
    default:
      throw new AssertionError();
    
  }
}



String ConvertLooFDataValueTableToString (LooFDataValue DataValueIn) {
  
  String ArrayPartString = "";
  ArrayList <LooFDataValue> ArrayPart = DataValueIn.ArrayValue;
  if (ArrayPart.size() > 0) {
    ArrayPartString += ConvertLooFDataValueToString (ArrayPart.get(0));
    for (int i = 1; i < ArrayPart.size(); i ++) {
      ArrayPartString += ", " + ConvertLooFDataValueToString (ArrayPart.get(i));
    }
  }
  
  String HashMapPartString = "";
  HashMap <String, LooFDataValue> HashMapPart = DataValueIn.HashMapValue;
  Set <String> HashMapKeys = HashMapPart.keySet();
  boolean FirstItem = true;
  for (String CurrentKey : HashMapKeys) {
    LooFDataValue CurrentDataValue = HashMapPart.get(CurrentKey);
    String CurrentDataValueAsString = ConvertLooFDataValueToString (CurrentDataValue);
    String MappingToAdd = CurrentKey + " = " + CurrentDataValueAsString;
    HashMapPartString += FirstItem  ?  MappingToAdd  :  ", " + MappingToAdd;
    FirstItem = false;
  }
  
  int CaseToUse = (ArrayPartString.length() > 0 ? 1 : 0) + (HashMapPartString.length() > 0 ? 2 : 0);
  switch (CaseToUse) {
    
    case (0): // no ArrayPart or HashMapPart
      return "{}";
    
    case (1): // ArrayPart but no HashMapPart
      return "{" + ArrayPartString + "}";
    
    case (2): // HashMapPart but no ArrayPart
      return "{" + HashMapPartString+ "}";
    
    case (3): // ArrayPart and HashMapPart
      return "{" + ArrayPartString + "; " + HashMapPartString + "}";
    
    default:
      throw new AssertionError();
    
  }
  
}










void IncreaseDataValueLockLevel (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  int CurrentLockLevel = LastItemOf (LockLevels);
  LockLevels.add(CurrentLockLevel + 1);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) IncreaseDataValueLockLevel (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) IncreaseDataValueLockLevel (DataValue.HashMapValue.get(CurrentKey));
}



void DecreaseDataValueLockLevel (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  LockLevels.remove(LockLevels.size() - 1);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) DecreaseDataValueLockLevel (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) DecreaseDataValueLockLevel (DataValue.HashMapValue.get(CurrentKey));
}



void UnlockDataValue (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  LockLevels.set(LockLevels.size() - 1, 0);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) UnlockDataValue (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) UnlockDataValue (DataValue.HashMapValue.get(CurrentKey));
}





double GetDataValueNumber (LooFDataValue DataValueIn) {
  return (DataValueIn.ValueType == DataValueType_Float) ? DataValueIn.FloatValue : (double) DataValueIn.IntValue;
}

double GetDataValueNumber_Unsafe (LooFDataValue DataValueIn, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String FunctionName) {
  if (!(DataValueIn.ValueType == DataValueType_Int || DataValueIn.ValueType == DataValueType_Float)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function " + FunctionName + " cannot be called with a table containing a non-number value.", new String[] {"InvalidArgType"});
  return (DataValueIn.ValueType == DataValueType_Float) ? DataValueIn.FloatValue : (double) DataValueIn.IntValue;
}



boolean ValueIsNumber (LooFDataValue Input) {
  return Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float;
}



ArrayList <LooFDataValue> GetAllDataValueTableItems (LooFDataValue DataValueIn) {
  ArrayList <LooFDataValue> AllItems = new ArrayList <LooFDataValue> (DataValueIn.ArrayValue);
  HashMap <String, LooFDataValue> HashMapValue = DataValueIn.HashMapValue;
  Collection <String> HashMapKeys = HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) {
    AllItems.add(HashMapValue.get(CurrentKey));
  }
  return AllItems;
}



boolean[] GetDataValueTypesFoundInList (ArrayList <LooFDataValue> ListIn) {
  boolean[] DataTypesOut = new boolean [NumOfDataValueTypes];
  for (LooFDataValue CurrentDataValue : ListIn) {
    DataTypesOut[CurrentDataValue.ValueType] = true;
  }
  return DataTypesOut;
}
