// Array to ArrayList:  Output = new ArrayList <T> (Arrays.asList (Input));
// ArrayList to Array:  Output = Input.toArray(new T [Input.size()]);



<T> ArrayList <T> ArrayToArrayList (T[] Input) {
  return new ArrayList <T> (Arrays.asList (Input));
}

<T> T[] ArrayListToArray (List <T> Input, Class OutputClass) {
  return Input.toArray((T[]) Array.newInstance(OutputClass, Input.size()));
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



<T> T[] RemoveFirstItem (T[] Input, Class OutputClass) {
  T[] Output = (T[]) Array.newInstance(OutputClass, Input.length - 1);
  for (int i = 0; i < Output.length; i ++) {
    Output[i] = Input[i + 1];
  }
  return Output;
}

<T> T RemoveLastItem (ArrayList <T> Input) {
  return Input.remove(Input.size() - 1);
}

<T> T SetLastItem (ArrayList <T> Input, T NewItem) {
  return Input.set(Input.size() - 1, NewItem);
}



<T> boolean ArrayContainsItem (T[] Input, T Item) {
  for (int i = 0; i < Input.length; i ++) {
    if (Input[i].equals(Item)) return true;
  }
  return false;
}

<T> boolean AnyItemsMatch (T[] Array1, T[] Array2) {
  for (T CurrentItem : Array1) {
    if (ArrayContainsItem (Array2, CurrentItem)) return true;
  }
  return false;
}



// this can't use ArrayList.indexOf() since that doesn't allow you to specify a starting index
<T> int IndexOfItemInRange (ArrayList <T> ArrayIn, T ItemToFind, int MinIndex, int MaxIndex) {
  MaxIndex = Math.min(MaxIndex, ArrayIn.size());
  for (int i = MinIndex; i <= MaxIndex; i ++) {
    if (ArrayIn.get(i).equals(ItemToFind)) return i;
  }
  return -1;
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

boolean ExceptionIsLooFInterpreterException (RuntimeException e) {
  return e.getClass().equals(LooFInterpreterException.class);
}





class StringComparator_ShortestToLongest implements Comparator <String> {
  public int compare (String String1, String String2) {
    return String1.length() - String2.length();
  }
}





boolean[] GetCharsInQuotes_WithCache (String StringIn, HashMap <String, boolean[]> CharsInQuotesCache) {
  boolean[] CharsInQuotes = CharsInQuotesCache.getOrDefault (StringIn, null);
  if (CharsInQuotes == null) {
    CharsInQuotes = GetCharsInQuotes (StringIn);
    CharsInQuotesCache.put(StringIn, CharsInQuotes);
  }
  return CharsInQuotes;
}



boolean[] GetCharsInQuotes (String StringIn) {
  boolean[] CharsInQuotes = new boolean [StringIn.length()];
  int StartQuoteIndex = StringIn.indexOf('"');
  while (StartQuoteIndex != -1) {
    int EndQuoteIndex = StringIn.indexOf('"', StartQuoteIndex + 1);
    if (EndQuoteIndex == -1) return CharsInQuotes;
    for (int i = StartQuoteIndex + 1; i < EndQuoteIndex; i ++) {
      CharsInQuotes[i] = true;
    }
    StartQuoteIndex = StringIn.indexOf('"', EndQuoteIndex + 1);
  }
  return CharsInQuotes;
}



Result <Integer> GetEndQuoteIndex (String CurrentLine, int StartQuoteIndex) {
  int EndQuoteIndex = CurrentLine.indexOf('"', StartQuoteIndex + 1);
  while (true) {
    if (EndQuoteIndex == -1) return new Result <Integer> ();
    if (CurrentLine.charAt(EndQuoteIndex - 1) != '\\') return new Result <Integer> (EndQuoteIndex);
    EndQuoteIndex = CurrentLine.indexOf('"', EndQuoteIndex + 1);
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



long ByteToLong (byte ByteIn) {
  long Output = (long) ByteIn;
  Output += 256;
  Output %= 256;
  return Output;
}

int ByteToInt (byte ByteIn) {
  int Output = (int) ByteIn;
  Output += 256;
  Output %= 256;
  return Output;
}





// from stack overflow: https://stackoverflow.com/questions/21092086/get-random-element-from-collection by Peter Lawrey https://stackoverflow.com/users/57695/peter-lawrey
<T> T GetCollectionIndex (Collection <T> CollectionIn, int Index) {
  for (T CurrentItem : CollectionIn) {
    if (--Index < 0) return CurrentItem;
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
  return ArrayListToArray (FileContents, String.class);
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



String GetFileExtention (String FileNameIn) {
  int PeriodIndex = FileNameIn.lastIndexOf('.');
  if (PeriodIndex == -1) throw (new RuntimeException ("Could not remove the extention of the file name \"" + FileNameIn + "\"."));
  return FileNameIn.substring(PeriodIndex + 1);
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





String EnsureStringLength (String StringIn, int NeededLength, char FillChar) {
  int NumToAdd = NeededLength - StringIn.length();
  for (int i = 0; i < NumToAdd; i ++) {
    StringIn += FillChar;
  }
  return StringIn;
}





String RemoveStringRange (String StringIn, int RangeStart, int RangeEnd) {
  return StringIn.substring(0, RangeStart) + StringIn.substring (RangeEnd);
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
  
  String ArrayPartString = "";
  LooFTokenBranch[] Children = TokenBranch.Children;
  if (Children.length > 0) {
    ArrayPartString += ConvertLooFTokenBranchToString (Children[0]);
    for (int i = 1; i < Children.length; i ++) {
      ArrayPartString += ", " + ConvertLooFTokenBranchToString (Children[i]);
    }
  }
  
  if (TokenBranch.HashMapChildren == null) {
    return ArrayPartString;
  }
  
  String HashMapPartString = "";
  HashMap <String, LooFTokenBranch> HashMapPart = TokenBranch.HashMapChildren;
  Set <String> HashMapKeys = HashMapPart.keySet();
  boolean FirstItem = true;
  for (String CurrentKey : HashMapKeys) {
    LooFTokenBranch CurrentTokenBranch = HashMapPart.get(CurrentKey);
    String CurrentDataValueAsString = ConvertLooFTokenBranchToString (CurrentTokenBranch);
    String MappingToAdd = CurrentKey + " = " + CurrentDataValueAsString;
    HashMapPartString += FirstItem  ?  MappingToAdd  :  ", " + MappingToAdd;
    FirstItem = false;
  }
  
  int CaseToUse = (ArrayPartString.length() > 0 ? 1 : 0) + (HashMapPartString.length() > 0 ? 2 : 0);
  switch (CaseToUse) {
    
    case (0): // no Children or HashMapChildren
      return "";
    
    case (1): // Children but non HashMapChildren
      return ArrayPartString;
    
    case (2): // HashMapChildren but no Children
      return HashMapPartString;
    
    case (3): // Children and HashMapChildren
      return ArrayPartString + "; " + HashMapPartString;
    
    default:
      throw new AssertionError();
    
  }
  
  
}





String ConvertLooFDataValueToString (LooFDataValue DataValueIn) {
  switch (DataValueIn.ValueType) {
    
    case (DataValueType_Null):
      return "null";
    
    case (DataValueType_Int):
      return DataValueIn.IntValue + "";
    
    case (DataValueType_Float):
      return DataValueIn.FloatValue + "";
    
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
      return "{" + HashMapPartString + "}";
    
    case (3): // ArrayPart and HashMapPart
      return "{" + ArrayPartString + "; " + HashMapPartString + "}";
    
    default:
      throw new AssertionError();
    
  }
  
}





boolean GetDataValueTruthiness (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
  switch (Input.ValueType) {
    
    case (DataValueType_Null):
      return false;
    
    case (DataValueType_Int):
      return Input.IntValue > 0;
    
    case (DataValueType_Float):
      return Input.FloatValue > 0;
    
    case (DataValueType_String):
      return Input.StringValue.length() > 0;
    
    case (DataValueType_Bool):
      return Input.BoolValue;
    
    case (DataValueType_Table):
      return Input.ArrayValue.size() > 0;
    
    case (DataValueType_ByteArray):
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast byteArray to bool.", new String[] {"InvalidCast", "InalidArgType"});
    
    case (DataValueType_Function):
      return true;
    
    default:
      throw new AssertionError();
    
  }
}





Result <Boolean> GetDataValueSign (LooFDataValue Input) {
  switch (Input.ValueType) {
    
    case (DataValueType_Int):
       return new Result <Boolean> (Input.IntValue >= 0);
    
    case (DataValueType_Float):
       return new Result <Boolean> (Input.FloatValue >= 0);
    
    default:
      return new Result();
    
  }
}










void IncreaseDataValueLock (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  int CurrentLockLevel = LastItemOf (LockLevels);
  LockLevels.add(CurrentLockLevel + 1);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) IncreaseDataValueLock (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) IncreaseDataValueLock (DataValue.HashMapValue.get(CurrentKey));
}



void DecreaseDataValueLock (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  RemoveLastItem (LockLevels);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) DecreaseDataValueLock (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) DecreaseDataValueLock (DataValue.HashMapValue.get(CurrentKey));
}



void UnlockDataValue (LooFDataValue DataValue) {
  ArrayList <Integer> LockLevels = DataValue.LockLevels;
  SetLastItem (LockLevels, 0);
  if (DataValue.ValueType != DataValueType_Table) return;
  for (LooFDataValue CurrentDataValue : DataValue.ArrayValue) UnlockDataValue (CurrentDataValue);
  Set <String> HashMapKeys = DataValue.HashMapValue.keySet();
  for (String CurrentKey : HashMapKeys) UnlockDataValue (DataValue.HashMapValue.get(CurrentKey));
}



boolean ValueIsLocked (LooFDataValue DataValueIn) {
  return LastItemOf (DataValueIn.LockLevels) > 0;
}





double GetDataValueNumber (LooFDataValue DataValueIn) {
  return (DataValueIn.ValueType == DataValueType_Float) ? DataValueIn.FloatValue : (double) DataValueIn.IntValue;
}

double GetDataValueNumber_Unsafe (LooFDataValue DataValueIn, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String FunctionName) {
  if (!(DataValueIn.ValueType == DataValueType_Int || DataValueIn.ValueType == DataValueType_Float)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function " + FunctionName + " cannot be called with a table containing a non-number value.", new String[] {"InvalidArgType"});
  return (DataValueIn.ValueType == DataValueType_Float) ? DataValueIn.FloatValue : (double) DataValueIn.IntValue;
}



Result <Long> GetDataValueInt (LooFDataValue DataValueIn) {
  switch (DataValueIn.ValueType) {
    case (DataValueType_Int): return new Result <Long> (DataValueIn.IntValue);
    case (DataValueType_Float): return new Result <Long> ((long) DataValueIn.FloatValue);
    default: return new Result();
  }
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



Result <String[]> GetStringArrayFromDataValue (LooFDataValue DataValueIn) {
  ArrayList <LooFDataValue> ArrayIn = DataValueIn.ArrayValue;
  String[] Output = new String [ArrayIn.size()];
  for (int i = 0; i < Output.length; i ++) {
    LooFDataValue CurrentValue = ArrayIn.get(i);
    if (CurrentValue.ValueType != DataValueType_String) return (new Result()).SetErrCause(DataValueTypeNames[CurrentValue.ValueType]);
    Output[i] = CurrentValue.StringValue;
  }
  return new Result (Output);
}
