LooFCompiler LooFCompiler = new LooFCompiler();

class LooFCompiler {
  
  
  
  
  
  
  
  
  
  
  LooFEnvironment CompileEnvironmentFromFolder (File CodeFolder, LooFCompileSettings CompileSettings) {
    if (CodeFolder == null) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File argument is null)."));
    if (!CodeFolder.exists()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File does not exist)."));
    if (!CodeFolder.isDirectory()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument. (File is not a folder)."));
    if (CompileSettings == null) throw (new LooFCompileException ("AddNewEnvironment cannot take a null LoofCompileSettings object. Either pass a new LooFCompileSettings object or call AddNewEvironment with no LooFCompileSettings argument."));
    StartTimer ("Total");
    StartTimer ("OnlyCompilation");
    
    
    
    // MUST BE ORDERED SHORTEST TO LONGEST
    final String[] CombinedTokens = {
      "==",
      "!=",
      ">=",
      "<=",
      "..",
      "===",
      "!==",
    };
    
    
    
    // get default addons
    LooFAddonsData AddonsData = GetAddonsDataForEnvironment (CompileSettings);
    
    
    
    // start CodeData-s
    LooFLoadedFilesData LoadedFilesData = LoadFilesIntoNewCodeDatas (CodeFolder);
    HashMap <String, LooFCodeData> AllCodeDatas = LoadedFilesData.AllCodeDatas;
    String[] HeaderFileContents = LoadedFilesData.HeaderFileContents;
    
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    
    
    // pre-process CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      PreProcessCodeData (CodeData, AllCodeDatas, HeaderFileContents);
    }
    
    if (CompileSettings.PreProcessorOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintPreProcessorOutput (AllCodeDatas, CompileSettings.PreProcessorOutputPath, "PreProcessedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // link CodeData-s
    LinkAllCodeDatas (AllCodeDatas);
    
    if (CompileSettings.LinkerOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintLinkerOutput (AllCodeDatas, CompileSettings.LinkerOutputPath, "LinkedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // parse CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      ParseCodeData (CodeData, CombinedTokens);
    }
    
    if (CompileSettings.LexerOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintLexerOutput (AllCodeDatas, CompileSettings.LexerOutputPath, "ParsedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // lex CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      LexCodeData (CodeData, AddonsData);
    }
    
    if (CompileSettings.ParserOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintParserOutput (AllCodeDatas, CompileSettings.ParserOutputPath, "LexedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // create environement
    LooFEnvironment NewEnvironment = new LooFEnvironment (AllCodeDatas, AddonsData);
    
    
    
    
    StopTimer ("OnlyCompilation");
    StopTimer ("Total");
    
    println ("Compiled environment from folder " + CodeFolder + ".");
    println ("Total time for only compiling: " + GetTimerMillis ("OnlyCompilation") + " ms.");
    println ("Total time: " + GetTimerMillis ("Total") + " ms.");
    
    
    
    return NewEnvironment;
    
  }
  
  
  
  
  
  
  
  
  
  
  LooFAddonsData GetAddonsDataForEnvironment (LooFCompileSettings CompileSettings) {
    LooFAddonsData AddonsData = new LooFAddonsData();
    AddonsData.InterpreterModules          = GetInterpreterModulesForEnvironment          (CompileSettings);
    AddonsData.EvaluatorOperations         = GetEvaluatorOperationsForEnvironment         (CompileSettings);
    AddonsData.EvaluatorFunctions          = GetEvaluatorFunctionsForEnvironment          (CompileSettings);
    AddonsData.InterpreterAssignments      = GetInterpreterAssignmentsForEnvironment      (CompileSettings);
    AddonsData.InterpreterTweakAssignments = GetInterpreterTweakAssignmentsForEnvironment (CompileSettings);
    AddonsData.InterpreterFunctions        = GetInterpreterFunctionsForEnvironment        (CompileSettings);
    return AddonsData;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterModule> GetInterpreterModulesForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterModule> InterpreterModules = new HashMap <String, LooFInterpreterModule> ();
    if (!CompileSettings.AddDefaultInterpreterModules) return InterpreterModules;
    
    return InterpreterModules;
  }
  
  
  
  
  
  HashMap <String, LooFEvaluatorOperation> GetEvaluatorOperationsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFEvaluatorOperation> EvaluatorOperations = new HashMap <String, LooFEvaluatorOperation> ();
    if (!CompileSettings.AddDefaultEvaluatorOperations) return EvaluatorOperations;
    
    EvaluatorOperations.put("+", Operation_Add);
    EvaluatorOperations.put("-", Operation_Subtract);
    EvaluatorOperations.put("*", Operation_Multiply);
    EvaluatorOperations.put("/", Operation_Divide);
    EvaluatorOperations.put("^", Operation_Power);
    EvaluatorOperations.put("%", Operation_Modulo);
    EvaluatorOperations.put("..", Operation_Concat);
    EvaluatorOperations.put("==", Operation_Equals);
    EvaluatorOperations.put("===", Operation_StrictEquals);
    EvaluatorOperations.put(">", Operation_GreaterThan);
    EvaluatorOperations.put("<", Operation_LessThan);
    EvaluatorOperations.put("!=", Operation_NotEquals);
    EvaluatorOperations.put("!==", Operation_StrictNotEquals);
    EvaluatorOperations.put(">=", Operation_GreaterThanOrEqual);
    EvaluatorOperations.put("<=", Operation_LessThanOrEqual);
    EvaluatorOperations.put("and", Operation_And);
    EvaluatorOperations.put("or", Operation_Or);
    EvaluatorOperations.put("xor", Operation_Xor);
    EvaluatorOperations.put("&&", Operation_BitwiseAnd);
    EvaluatorOperations.put("||", Operation_BitwiseOr);
    EvaluatorOperations.put("^^", Operation_BitwiseXor);
    EvaluatorOperations.put("<<", Operation_ShiftRight);
    EvaluatorOperations.put(">>", Operation_ShiftLeft);
    
    return EvaluatorOperations;
  }
  
  
  
  
  
  HashMap <String, LooFEvaluatorFunction> GetEvaluatorFunctionsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFEvaluatorFunction> EvaluatorFunctions = new HashMap <String, LooFEvaluatorFunction> ();
    if (!CompileSettings.AddDefaultEvaluatorFunctions) return EvaluatorFunctions;
    
    EvaluatorFunctions.put("round", Function_round);
    EvaluatorFunctions.put("floor", Function_floor);
    EvaluatorFunctions.put("ceil", Function_ceil);
    EvaluatorFunctions.put("abs", NullEvaluatorFunction);
    EvaluatorFunctions.put("sqrt", Function_sqrt);
    EvaluatorFunctions.put("sign", Function_sign);
    EvaluatorFunctions.put("not", Function_not);
    EvaluatorFunctions.put("!!", NullEvaluatorFunction);
    EvaluatorFunctions.put("min", Function_min);
    EvaluatorFunctions.put("max", Function_max);
    EvaluatorFunctions.put("clamp", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("random", Function_random);
    EvaluatorFunctions.put("randomInt", Function_randomInt);
    EvaluatorFunctions.put("chance", Function_chance);
    
    EvaluatorFunctions.put("lengthOf", Function_lengthOf);
    EvaluatorFunctions.put("totalItemsIn", Function_totalItemsIn);
    EvaluatorFunctions.put("endOf", Function_endOf);
    EvaluatorFunctions.put("lastItemOf", NullEvaluatorFunction);
    EvaluatorFunctions.put("keysOf", Function_keysOf);
    EvaluatorFunctions.put("valuesOf", Function_valuesOf);
    EvaluatorFunctions.put("randomItem", Function_randomItem);
    EvaluatorFunctions.put("randomValue", Function_randomValue);
    EvaluatorFunctions.put("firstIndexOfItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("lastIndexOfItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("allIndexesOfItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("tableContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("arrayContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("hashmapContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("splitTable", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("getChar", Function_getChar);
    EvaluatorFunctions.put("getCharInts", Function_getCharInts);
    EvaluatorFunctions.put("getCharByes", Function_getCharBytes);
    EvaluatorFunctions.put("getSubString", Function_getSubString);
    EvaluatorFunctions.put("firstIndexOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("lastIndexOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("allIndexesOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("splitString", NullEvaluatorFunction);
    EvaluatorFunctions.put("stringStartsWith", NullEvaluatorFunction);
    EvaluatorFunctions.put("stringEndsWith", NullEvaluatorFunction);
    EvaluatorFunctions.put("replaceStrings", NullEvaluatorFunction);
    EvaluatorFunctions.put("toLowerCase", NullEvaluatorFunction);
    EvaluatorFunctions.put("toUpperCase", NullEvaluatorFunction);
    EvaluatorFunctions.put("trimString", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("toInt", Function_toInt);
    EvaluatorFunctions.put("toFloat", Function_toFloat);
    EvaluatorFunctions.put("toString", Function_toString);
    EvaluatorFunctions.put("toBool", Function_toBool);
    
    EvaluatorFunctions.put("typeOf", Function_typeOf);
    EvaluatorFunctions.put("newByteArray", NullEvaluatorFunction);
    EvaluatorFunctions.put("timeSince", NullEvaluatorFunction);
    
    return EvaluatorFunctions;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterAssignment> GetInterpreterAssignmentsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterAssignment> InterpreterAssignments = new HashMap <String, LooFInterpreterAssignment> ();
    if (!CompileSettings.AddDefaultInterpreterAssignments) return InterpreterAssignments;
    
    InterpreterAssignments.put("=", Assignment_Equals);
    InterpreterAssignments.put("defaultsTo", Assignment_DefaultsTo);
    
    return InterpreterAssignments;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterTweakAssignment> GetInterpreterTweakAssignmentsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterTweakAssignment> InterpreterTweakAssignments = new HashMap <String, LooFInterpreterTweakAssignment> ();
    if (!CompileSettings.AddDefaultInterpreterTweakAssignments) return InterpreterTweakAssignments;
    
    return InterpreterTweakAssignments;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterFunction> GetInterpreterFunctionsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterFunction> InterpreterFunctions = new HashMap <String, LooFInterpreterFunction> ();
    if (!CompileSettings.AddDefaultInterpreterTweakAssignments) return InterpreterFunctions;
    
    InterpreterFunctions.put("push", InterpreterFunction_Push);
    InterpreterFunctions.put("pop", InterpreterFunction_Pop);
    
    InterpreterFunctions.put("call", InterpreterFunction_Call);
    InterpreterFunctions.put("return", InterpreterFunction_Return);
    InterpreterFunctions.put("returnIf", InterpreterFunction_ReturnIf);
    
    InterpreterFunctions.put("if", InterpreterFunction_If);
    InterpreterFunctions.put("skip", InterpreterFunction_Skip);
    InterpreterFunctions.put("end", InterpreterFunction_End);
    
    InterpreterFunctions.put("loop", InterpreterFunction_Loop);
    InterpreterFunctions.put("forEach", InterpreterFunction_ForEach);
    InterpreterFunctions.put("while", InterpreterFunction_While);
    InterpreterFunctions.put("repeat", InterpreterFunction_Repeat);
    InterpreterFunctions.put("repeatIf", InterpreterFunction_RepeatIf);
    InterpreterFunctions.put("continue", InterpreterFunction_Continue);
    InterpreterFunctions.put("continueIf", InterpreterFunction_ContinueIf);
    InterpreterFunctions.put("break", InterpreterFunction_Break);
    InterpreterFunctions.put("breakIf", InterpreterFunction_BreakIf);
    
    InterpreterFunctions.put("error", InterpreterFunction_Error);
    InterpreterFunctions.put("errorIf", InterpreterFunction_ErrorIf);
    InterpreterFunctions.put("try", InterpreterFunction_Try);
    
    InterpreterFunctions.put("callOutside", InterpreterFunction_CallOutside);
    
    return InterpreterFunctions;
  }
  
  
  
  
  
  
  
  
  
  
  LooFLoadedFilesData LoadFilesIntoNewCodeDatas (File CodeFolder) {
    
    
    
    // vars used
    HashMap <String, LooFCodeData> AllCodeDatas = new HashMap <String, LooFCodeData> ();
    String[] HeaderFileContents = new String [0];
    File[] AllFiles;
    String[] AllFullFileNames;
    String[][] AllFileContents;
    
    
    
    // get all .LooF files in folder and find the Header.LOOF file (if made)
    ArrayList <File> AllFilesRaw = GetAllFilesInFolder (CodeFolder);
    for (int i = AllFilesRaw.size() - 1; i >= 0; i --) {
      File CurrentFile = AllFilesRaw.get(i);
      String CurrentFileName = CurrentFile.getName();
      if (!CurrentFileName.endsWith(".LOOF")) AllFilesRaw.remove(i);
      if (CurrentFileName.equals("Header.LOOF")) HeaderFileContents = loadStrings (AllFilesRaw.remove(i));
    }
    
    AllFiles = ArrayListToArray (AllFilesRaw, new File(""));
    
    
    
    // get file names
    AllFullFileNames = new String [AllFiles.length];
    boolean MainFileFound = false;
    for (int i = 0; i < AllFiles.length; i ++) {
      String CurrentFullFileName = GetFileFullName (AllFiles[i], CodeFolder);
      AllFullFileNames[i] = CurrentFullFileName;
      if (CurrentFullFileName.equals("Main.LOOF")) MainFileFound = true;
    }
    
    // error if main file was not found
    if (!MainFileFound) throw (new LooFCompileException ("No Main file was found. Please have a file named \"Main.LOOF\" in the folder being compiled."));
    
    
    
    // load file contents and apply header
    AllFileContents = new String [AllFiles.length] [];
    for (int i = 0; i < AllFiles.length; i ++) {
      AllFileContents[i] = loadStrings (AllFiles[i]);
    }
    
    
    
    // create CodeData-s
    for (int i = 0; i < AllFiles.length; i ++) {
      AllCodeDatas.put(AllFullFileNames[i], new LooFCodeData (AllFileContents[i], AllFullFileNames[i]));
    }
    
    
    
    return new LooFLoadedFilesData (AllCodeDatas, HeaderFileContents);
    
    
    
  }
  
  
  
  
  
  
  
  
  
  
  void PreProcessCodeData (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String[] HeaderFileContents) {
    
    //Log.println ("Pre-processing code...");
    if (HeaderFileContents.length > 0) {
      //Log.println ("     Inserting header");
      InsertHeader (CodeData, HeaderFileContents);
    }
    //Log.println ("     Removing initial trim");
    RemoveInitialTrim (CodeData);
    //Log.println ("     Processing if statements");
    ProcessIfStatements (CodeData);
    //Log.println ("     Processing includes");
    ProcessIncludes (CodeData, AllCodeDatas, HeaderFileContents.length);
    //Log.println ("     Processing replaces");
    ProcessReplaces (CodeData);
    //Log.println ("     Removing comments");
    RemoveComments (CodeData);
    //Log.println ("     Removing excess whitespace");
    RemoveExcessWhitespace (CodeData);
    //Log.println ("     Checking for incorrect pre-processor statements");
    CheckForIncorrectPreProcessorStatements (CodeData);
    //Log.println ("     Combining seperated lists");
    CombineSeperatedLists (CodeData);
    //Log.println ("Done");
    
  }
  
  
  
  
  
  
  
  
  
  
  void InsertHeader (LooFCodeData CodeData, String[] HeaderFileContents) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    // process #ignore_header
    if (Code.get(0).equals("#ignore_header")) {
      CodeData.IncludesHeader = false;
      Code.remove(0);
      LineNumbers.remove(0);
      LineFileOrigins.remove(0);
      return;
    }
    
    CodeData.IncludesHeader = true;
    
    // insert header
    int HeaderFileLength = HeaderFileContents.length;
    for (int i = 0; i < HeaderFileLength; i ++) {
      Code.add(i, HeaderFileContents[i]);
      LineNumbers.add(i, i - HeaderFileLength);
      LineFileOrigins.add(i, CodeData.FullFileName);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveInitialTrim (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = CurrentLine.trim();
      if (!NewLine.equals(CurrentLine)) Code.set (i, NewLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessReplaces (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (!CurrentLine.startsWith("#replace")) continue;
      
      if (CurrentLine.startsWith("#replace ")) {
        ReturnValue ReplacementData = GetReplacementData (CodeData, i, 10);
        String ReplaceBefore = ReplacementData.StringValue;
        String[] ReplaceAfter = ReplacementData.StringArrayValue;
        ReplaceAllStringOccurancesInCode (CodeData, ReplaceBefore, ReplaceAfter, false, false);
        i --;
        continue;
      }
      
      if (CurrentLine.startsWith("#replaceStart ")) {
        ReturnValue ReplacementData = GetReplacementData (CodeData, i, 15);
        String ReplaceBefore = ReplacementData.StringValue;
        String[] ReplaceAfter = ReplacementData.StringArrayValue;
        ReplaceAllStringOccurancesInCode (CodeData, ReplaceBefore, ReplaceAfter, true, false);
        i --;
        continue;
      }
      
      if (CurrentLine.startsWith("#replaceEnd ")) {
        ReturnValue ReplacementData = GetReplacementData (CodeData, i, 13);
        String ReplaceBefore = ReplacementData.StringValue;
        String[] ReplaceAfter = ReplacementData.StringArrayValue;
        ReplaceAllStringOccurancesInCode (CodeData, ReplaceBefore, ReplaceAfter, false, true);
        i --;
        continue;
      }
      
    }
  }
  
  
  
  ReturnValue GetReplacementData (LooFCodeData CodeData, int i, int SearchStart) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    String CurrentLine = Code.remove(i);
    LineNumbers.remove(i);
    LineFileOrigins.remove(i);
    
    String[] RawReplacementData = GetRawReplacementData (CurrentLine, SearchStart);
    
    String[] ReplaceBefore_Array = FormatBackslashes (RawReplacementData[0]);
    String[] ReplaceAfter = FormatBackslashes (RawReplacementData[1]);
    
    if (ReplaceBefore_Array.length > 1) throw (new LooFCompileException (CodeData, i, "#replace does not currently support multi-line functionality for the string to be replaced."));
    String ReplaceBefore = ReplaceBefore_Array[0];
    
    ReturnValue Return = new ReturnValue();
    Return.StringValue = ReplaceBefore;
    Return.StringArrayValue = ReplaceAfter;
    return Return;
  }
  
  
  
  String[] GetRawReplacementData (String CurrentLine, int SearchStart) {
    int CurrentLineLength = CurrentLine.length();
    
    // find first (not in string) '"'
    int i = SearchStart;
    for (int VOID = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int FirstMiddleQuote = i;
    
    // find second (not in string) '"'
    i ++;
    for (int VOID = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int SecondMiddleQuote = i;
    
    // get string parts based on quote locations
    String ReplaceBefore = CurrentLine.substring (SearchStart, FirstMiddleQuote);
    String ReplaceAfter  = CurrentLine.substring (SecondMiddleQuote + 1, CurrentLineLength - 1);
    
    return new String[] {ReplaceBefore, ReplaceAfter};
  }
  
  
  
  void ReplaceAllStringOccurancesInCode (LooFCodeData CodeData, String ReplaceBefore, String[] ReplaceAfter, boolean OnlyStart, boolean OnlyEnd) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int LinesToJumpPerReplace = ReplaceAfter.length - 1;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("#replace")) continue;  // NOT "#replace "
      ArrayList <Integer> AllReplacementPositions = GetAllPositionsOfString (CurrentLine, ReplaceBefore, OnlyStart, OnlyEnd);
      ReplaceAllStringOccurancesInLine (CodeData, CurrentLine, i, AllReplacementPositions, ReplaceBefore, ReplaceAfter);
      int LinesToJump = LinesToJumpPerReplace * AllReplacementPositions.size();
      i += LinesToJump;
    }
  }
  
  
  
  ArrayList <Integer> GetAllPositionsOfString (String StringIn, String StringToFind, boolean OnlyStart, boolean OnlyEnd) {
    ArrayList <Integer> Output = new ArrayList <Integer> ();
    if (OnlyStart) {
      if (StringIn.startsWith(StringToFind)) Output.add(0);
      return Output;
    }
    if (OnlyEnd) {
      if (StringIn.endsWith(StringToFind)) Output.add(StringIn.length() - StringToFind.length());
      return Output;
    }
    int FoundIndex = StringIn.indexOf(StringToFind);
    while (FoundIndex != -1) {
      Output.add(FoundIndex);
      FoundIndex = StringIn.indexOf(StringToFind, FoundIndex + 1);
    }
    return Output;
  }
  
  
  
  void ReplaceAllStringOccurancesInLine (LooFCodeData CodeData, String CurrentLine, int i, ArrayList <Integer> AllReplacementPositions, String ReplaceBefore, String[] ReplaceAfter) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    for (int j = AllReplacementPositions.size() - 1; j >= 0; j --) {
      int CurrentOccuranceIndex = AllReplacementPositions.get(j);
      
      // get new line of code
      String[] NewLine = ReplaceStringOccurance (CurrentLine, CurrentOccuranceIndex, ReplaceBefore, ReplaceAfter);
      CurrentLine = NewLine[0];
      
      // insert NewLine
      Code.remove(i);
      int LineNumber = LineNumbers.remove(i);
      String LineFileOrigin = LineFileOrigins.remove(i);
      for (int k = 0; k < NewLine.length; k ++) {
        Code.add(i + k, NewLine[k]);
        LineNumbers.add(i + k, LineNumber);
        LineFileOrigins.add(i + k, LineFileOrigin);
      }
      
    }
  }
  
  
  
  String[] ReplaceStringOccurance (String CurrentLine, int CurrentOccuranceIndex, String ReplaceBefore, String[] ReplaceAfter) {
    String[] NewLine = ReplaceAfter.clone();
    String CurrentLineStart = CurrentLine.substring(0, CurrentOccuranceIndex);
    String CurrentLineEnd = CurrentLine.substring(CurrentOccuranceIndex + ReplaceBefore.length());
    NewLine[0] = CurrentLineStart + NewLine[0];
    NewLine[NewLine.length - 1] += CurrentLineEnd;
    return NewLine;
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessIncludes (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int HeaderLength) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("#include ")) {
        Code.remove(i);
        int LineNumber = LineNumbers.remove(i);
        String LineFileOrigin = LineFileOrigins.remove(i);
        String FileName = CurrentLine.substring(9);
        
        // get file to include
        String FullFileName = GetFullFileNameFromPartialFileName (FileName, AllCodeDatas, CurrentLine, LineNumber, LineFileOrigin, CodeData.FullFileName);
        if (FullFileName == null) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullFileName, "could not include the file " + FileName + " because the file could not be found."));
        LooFCodeData FileToInclude = AllCodeDatas.get(FullFileName);
        
        // get code to include and data about it
        String[] FileToIncludeContents = FileToInclude.OriginalCode;
        String FileToIncludeName = FileToInclude.FullFileName;
        int LineNumberOffset = FileToInclude.IncludesHeader ? HeaderLength * -1 : 0;
        int StartIndex = FileToInclude.IncludesHeader ? 0 : 1;
        
        // insert code
        for (int j = StartIndex; j < FileToIncludeContents.length; j ++) {
          String LineToInsert = FileToIncludeContents[j];
          Code.add(i + j, LineToInsert);
          LineNumbers.add(i + j, j + LineNumberOffset);
          LineFileOrigins.add(i + j, FileToIncludeName);
        }
        
        // process new data
        ProcessIfStatements (CodeData, i, i + FileToIncludeContents.length);
        
        i --;  // for if the file being included starts with #include
      }
    }
  }
  
  
  
  
  
  String GetFullFileNameFromPartialFileName (String PartialFileName, HashMap <String, LooFCodeData> AllCodeDatas, String CurrentLine, int LineNumber, String LineFileOrigin, String FileName) {
    Set <String> AllFullFileNames = AllCodeDatas.keySet();
    String FoundFullFileName = null;
    for (String CurrentFullFileName : AllFullFileNames) {
      if (CurrentFullFileName.endsWith(PartialFileName)) {
        if (FoundFullFileName != null) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, FileName, "the file name \"" + PartialFileName + "\" is ambigous since it refers to both \"" + FoundFullFileName + "\" and \"" + CurrentFullFileName + "\"."));
        FoundFullFileName = CurrentFullFileName;
      }
    }
    return FoundFullFileName;
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessIfStatements (LooFCodeData CodeData) {
    ProcessIfStatements (CodeData, 0, CodeData.CodeArrayList.size());
  }
  
  
  
  void ProcessIfStatements (LooFCodeData CodeData, int StartIndex, int EndIndex) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = StartIndex; i < min (EndIndex, Code.size()); i ++) {
      String CurrentLine = Code.get(i).trim();
      if (!CurrentLine.startsWith("#if_")) continue;
      
      if (CurrentLine.startsWith("#if_equal ")) {
        String IfStatementData = CurrentLine.substring (10);
        boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, IfStatementData, i, "#if_equal", CodeData.FullFileName);
        if (!IfStatementResult) RemoveCodeUntilEndIf (CodeData, i);
        continue;
      }
      
      if (CurrentLine.startsWith("#if_not_equal ")) {
        String IfStatementData = CurrentLine.substring (14);
        boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, IfStatementData, i, "#if_not_equal", CodeData.FullFileName);
        if (IfStatementResult) RemoveCodeUntilEndIf (CodeData, i);
        continue;
      }
      
    }
  }
  
  
  
  boolean CheckIfIfStatementArgumentsMatch (LooFCodeData CodeData, String IfStatementData, int LineNumber, String PreProcessorStatementType, String FullFileName) {
    ArrayList <String> IfStatementArguments = GetSpaceSeperatedStrings (IfStatementData);
    int NumberOfArguments = IfStatementArguments.size();
    if (NumberOfArguments != 2) throw (new LooFCompileException (CodeData, LineNumber, PreProcessorStatementType + " takes 2 string arguments, but found " + NumberOfArguments + (NumberOfArguments == 1 ? " was" : " were") + " found."));
    String String1 = FillIfStatementArgument (IfStatementArguments.get(0), FullFileName);
    String String2 = FillIfStatementArgument (IfStatementArguments.get(1), FullFileName);
    return String1.equals(String2);
  }
  
  
  
  String FillIfStatementArgument (String StringIn, String FullFileName) {
    switch (StringIn) {
      
      default:
        return StringIn;
      
      case ("FILE_NAME"):
        return '"' + FullFileName + '"';
      
    }
  }
  
  
  
  void RemoveCodeUntilEndIf (LooFCodeData CodeData, int StartIndex) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    String FirstLine = Code.remove(StartIndex);
    int FirstLineNumber = LineNumbers.remove(StartIndex);
    String FirstLineFileOrigin = LineFileOrigins.remove(StartIndex);
    
    int Level = 0;
    
    for (int i = StartIndex; i < Code.size(); i ++) {
      String RemovedLine = Code.remove(i);
      LineNumbers.remove(i);
      LineFileOrigins.remove(i);
      
      if (RemovedLine.startsWith("#if_")) Level ++;
      
      // return if matching #end_if found
      if (RemovedLine.equals("#end_if")) {
        if (Level == 0) return;
        Level --;
      }
      
      i --;
    }
    
    throw (new LooFCompileException (FirstLine, FirstLineNumber, FirstLineFileOrigin, CodeData.FullFileName, "could not find matching \"#end_if\" for \"#if_...\" preprocessor statement."));
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveComments (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int CodeSize = Code.size();
    for (int i = 0; i < CodeSize; i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = RemoveCommentForLine (CurrentLine);
      if (NewLine != null) {
        Code.set(i, NewLine);
      }
    }
  }
  
  
  
  String RemoveCommentForLine (String CurrentLine) {
    
    // find index of comment
    int FoundCommentIndex = -1;
    int CurrentLineLength = CurrentLine.length() - 1;
    for (int i = 0; i < CurrentLineLength; i ++) {
      char CurrentChar = CurrentLine.charAt(i);
      
      // break if comment found
      if (CurrentChar == '/' && CurrentLine.charAt(i + 1) == '/') {
        FoundCommentIndex = i;
        break;
      }
      
      // skip strings
      if (CurrentChar == '"') {
        char PrevChar = CurrentChar;
        i ++;
        CurrentChar = CurrentLine.charAt(i);
        while (!(CurrentChar == '"' && PrevChar != '\\')) {
          PrevChar = CurrentChar;
          i ++;
          CurrentChar = CurrentLine.charAt(i);
        }
      }
      
    }
    
    // return if no comment found
    if (FoundCommentIndex == -1) return null;
    
    // remove comment
    return CurrentLine.substring(0, FoundCommentIndex);
    
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveExcessWhitespace (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    for (int i = Code.size() - 1; i >= 0; i --) {
      String CurrentLine = Code.get(i);
      String OriginalCurrentLine = CurrentLine;
      
      // remove leading and trailing whitespace
      CurrentLine = CurrentLine.trim();
      
      // remove if line is empty
      if (CurrentLine.length() == 0) {
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        continue;
      }
      
      // replace if line has changed
      if (!CurrentLine.equals(OriginalCurrentLine)) {
        Code.set(i, CurrentLine);
      }
      
    }
  }
  
  
  
  
  
  
  
  
  
  
  void CheckForIncorrectPreProcessorStatements (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      if (Code.get(i).startsWith("#")) {
        //throw (new LooFCompileException (CodeData, i, "unknown pre-processor statement."));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void CombineSeperatedLists (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = CurrentLine;
      if (CurrentLine.endsWith("{")) {
        
        boolean IsEnd = false;
        while (!IsEnd) {
          if (i + 1 == Code.size()) {
            throw (new LooFCompileException (CodeData, i, "could not find end of seperated list."));
          }
          CurrentLine = Code.remove(i + 1);
          LineNumbers.remove(i + 1);
          LineFileOrigins.remove(i + 1);
          IsEnd = CurrentLine.equals("}");
          NewLine += CurrentLine + (IsEnd ? "" : " ");
        }
        
        Code.set(i, NewLine);
        
      }
    }
  }
  
  
  
  
  
  
  
  
  
  void LinkAllCodeDatas (HashMap <String, LooFCodeData> AllCodeDatas) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    // simplify linking statements
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      FindLinkedFiles (CodeData, AllCodeDatas);
      FindFunctionLocations (CodeData);
    }
    
    // replace function references
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      ReplaceFunctionCalls (CodeData, AllCodeDatas);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void FindLinkedFiles (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    HashMap <String, String> LinkedFiles = CodeData.LinkedFiles;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("$link ")) {
        
        // remove line
        Code.remove(i);
        int LineNumber = LineNumbers.remove(i);
        String LineFileOrigin = LineFileOrigins.remove(i);
        
        // get link data
        String[] LinkData = GetLinkData (CurrentLine, LineNumber, LineFileOrigin, CodeData, AllCodeDatas);
        String LinkShortenedName = LinkData[0];
        String LinkFileName = LinkData[1];
        
        // add to LinkedFiles
        if (LinkedFiles.containsKey(LinkShortenedName)) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullFileName, "the shortened link name \"" + LinkShortenedName + "\" is already in use for file \"" + LinkedFiles.get(LinkShortenedName) + "\"."));
        LinkedFiles.put(LinkShortenedName, LinkFileName);
        
        i --;
      }
    }
  }
  
  
  
  String[] GetLinkData (String CurrentLine, int LineNumber, String LineFileOrigin, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // get the name of the file being linked
    int FoundSeperatorIndex = CurrentLine.indexOf(" as ");
    int LinkedFileNameEnd = (FoundSeperatorIndex == -1) ? CurrentLine.length() : FoundSeperatorIndex;
    String LinkedFileName = CurrentLine.substring(6, LinkedFileNameEnd);
    String LinkedFileFullName = GetFullFileNameFromPartialFileName (LinkedFileName, AllCodeDatas, CurrentLine, LineNumber, LineFileOrigin, CodeData.FullFileName);
    if (LinkedFileFullName == null) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullFileName, "could not link the file \"" + LinkedFileName + " because the file could not be found."));
    
    // return if done
    if (FoundSeperatorIndex == -1) return new String[] {RemoveFileExtention (LinkedFileFullName), LinkedFileFullName};
    
    // get the shortened file name
    String ShortenedName = CurrentLine.substring(FoundSeperatorIndex + 4);
    return new String[] {ShortenedName, LinkedFileFullName};
    
  }
  
  
  
  
  
  
  
  
  
  void FindFunctionLocations (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    HashMap <String, Integer> FunctionLocations = CodeData.FunctionLocations;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("$function ")) {
        
        String FunctionName = CurrentLine.substring(10);
        if (FunctionLocations.get(FunctionName) != null) throw (new LooFCompileException (CodeData, i, "function \"" + FunctionName + "\" already exists."));
        
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        
        FunctionLocations.put(FunctionName, i);
        
        i --;
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void ReplaceFunctionCalls (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.indexOf('$') == -1) continue;
      String NewLine = ReplaceFunctionCallsForLine (CurrentLine, CodeData, AllCodeDatas, i);
      Code.set(i, NewLine);
    }
  }
  
  
  
  
  
  String ReplaceFunctionCallsForLine (String CurrentLine, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int CurrentFunctionCallStart = CurrentLine.indexOf('$');
    while (CurrentFunctionCallStart != -1) {
      CurrentLine = ReplaceSingleFunctionCall (CurrentLine, CurrentFunctionCallStart, CodeData, AllCodeDatas, LineNumber);
      CurrentFunctionCallStart = CurrentLine.indexOf('$');
    }
    return CurrentLine;
  }
  
  
  
  
  
  String ReplaceSingleFunctionCall (String CurrentLine, int CurrentFunctionCallStart, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int CurrentFunctionCallEnd = GetFunctionCallEnd (CurrentLine, CurrentFunctionCallStart);
    String BeforeFunctionCall = CurrentLine.substring(0, CurrentFunctionCallStart);
    String FunctionCallData = CurrentLine.substring(CurrentFunctionCallStart + 1, CurrentFunctionCallEnd);
    String AfterFunctionCall = CurrentLine.substring(CurrentFunctionCallEnd);
    
    String NewFunctionCallData = GetLinkedFunctionCall (FunctionCallData, CodeData, AllCodeDatas, LineNumber);
    
    return BeforeFunctionCall + NewFunctionCallData + AfterFunctionCall;
  }
  
  
  
  int GetFunctionCallEnd (String CurrentLine, int CurrentLinkIndex) {
    int CurrentLineLength = CurrentLine.length();
    for (int i = CurrentLinkIndex + 1; i < CurrentLineLength; i ++) {
      if (CharStartsNewToken (CurrentLine.charAt(i))) return i;
    }
    return CurrentLineLength - 1;
  }
  
  
  
  
  
  String GetLinkedFunctionCall (String FunctionCallData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int LastPeriodIndex = FunctionCallData.lastIndexOf('.');
    if (LastPeriodIndex == -1) {
      return GetLinkedFunctionCall_WithinFile (FunctionCallData, CodeData, LineNumber);
    }
    return GetLinkedFunctionCall_OutsideFile (FunctionCallData, LastPeriodIndex, CodeData, AllCodeDatas, LineNumber);
  }
  
  
  
  String GetLinkedFunctionCall_WithinFile (String FunctionCallData, LooFCodeData CodeData, int LineNumber) {
    Integer FunctionLocation = CodeData.FunctionLocations.get(FunctionCallData);
    if (FunctionLocation == null) throw (new LooFCompileException (CodeData, LineNumber, "the function \"" + FunctionCallData + "\" is not defined or could not be found."));
    return FunctionLocation.toString();
  }
  
  
  
  String GetLinkedFunctionCall_OutsideFile (String FunctionCallData, int LastPeriodIndex, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    // get data from FunctionCallData
    String FunctionName = FunctionCallData.substring(LastPeriodIndex + 1);
    String ShortenedFileName = FunctionCallData.substring(0, LastPeriodIndex);
    
    // get full file name
    String FullFileName = CodeData.LinkedFiles.get(ShortenedFileName);
    if (FullFileName == null) throw (new LooFCompileException (CodeData, LineNumber, "no file was found linked as \"" + ShortenedFileName + "\"."));
    
    // get linked file
    LooFCodeData LinkedCodeData = AllCodeDatas.get(FullFileName);
    if (LinkedCodeData == null) throw new AssertionError();
    
    // get location of function
    Integer FunctionLocation = LinkedCodeData.FunctionLocations.get(FunctionName);
    if (FunctionLocation == null) throw (new LooFCompileException (CodeData, LineNumber, "no function named \"" + FunctionName + "\" was found in the file \"" + FullFileName + "\"."));
    
    // assemble and return new function data
    return "\"" + FullFileName + "\", " + FunctionLocation;
  }
  
  
  
  
  
  
  
  
  
  
  void ParseCodeData (LooFCodeData CodeData, String[] CombinedTokens) {
    TokenizeCode (CodeData);
    CombineTokensForCode (CodeData, CombinedTokens);
  }
  
  
  
  
  
  
  
  
  
  
  void TokenizeCode (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      ArrayList <String> TokenizedLine = TokenizeLine (CurrentLine, CodeData, i);
      CodeTokens.add(TokenizedLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  ArrayList <String> TokenizeLine (String CurrentLine, LooFCodeData CodeData, int LineNumber) {
    ArrayList <String> CurrentLineTokens = new ArrayList <String> ();
    int CurrentLineLength = CurrentLine.length();
    String CurrToken = CurrentLine.charAt(0) + "";
    for (int i = 1; i < CurrentLineLength; i ++) {
      char PrevChar = CurrentLine.charAt(i - 1);
      char CurrChar = CurrentLine.charAt(i);
      
      if (CurrChar == '"') {
        if (CurrToken.length() != 0) {
          CurrentLineTokens.add(CurrToken);
        }
        int EndQuoteIndex = GetEndQuoteIndex (CurrentLine, i, CodeData, LineNumber);
        CurrentLineTokens.add (CurrentLine.substring(i, EndQuoteIndex + 1));
        i = EndQuoteIndex;
        CurrToken = "";
        continue;
      }
      
      if (CharStartsNewToken (CurrChar) || CharStartsNewToken (PrevChar)) {
        if (CurrToken.equals("-") && CharIsDigit (CurrChar)) {
          CurrToken += CurrChar;
          continue;
        }
        if (CurrToken.length() != 0) {
          CurrentLineTokens.add(CurrToken);
          CurrToken = "";
        }
        if (!CharIsWhitespace (CurrChar)) {
          CurrToken += CurrChar;
        }
        continue;
      }
      
      CurrToken += CurrChar;
      continue;
      
    }
    if (CurrToken.length() != 0) CurrentLineTokens.add(CurrToken);
    return CurrentLineTokens;
  }
  
  
  
  
  
  int GetEndQuoteIndex (String CurrentLine, int i, LooFCodeData CodeData, int LineNumber) {
    int EndQuoteIndex = i;
    int FakeEndQuoteIndex = i - 1;
    while (EndQuoteIndex == FakeEndQuoteIndex + 1) {
      FakeEndQuoteIndex = CurrentLine.indexOf('\\', EndQuoteIndex + 1);
      EndQuoteIndex = CurrentLine.indexOf('"', EndQuoteIndex + 1);
      if (EndQuoteIndex == -1) {
        throw (new LooFCompileException (CodeData, LineNumber, "could not find a matching end-quote for the quote at index " + i + "."));
      }
    }
    return EndQuoteIndex;
  }
  
  
  
  
  
  
  
  
  
  
  void CombineTokensForCode (LooFCodeData CodeData, String[] CombinedTokens) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    for (int i = 0; i < CodeTokens.size(); i ++) {
      ArrayList <String> CurrentLineTokens = CodeTokens.get(i);
      CombineTokensForLine (CurrentLineTokens, CombinedTokens);
    }
  }
  
  
  
  
  
  void CombineTokensForLine (ArrayList <String> CurrentLineTokens, String[] CombinedTokens) {
    for (int i = 0; i < CurrentLineTokens.size(); i ++) {
      CombineTokensForLineAtPosition (CurrentLineTokens, CombinedTokens, i);
    }
  }
  
  
  
  
  
  void CombineTokensForLineAtPosition (ArrayList <String> CurrentLineTokens, String[] CombinedTokens, int StartIndex) {
    
    // find any fitting combined token
    ReturnValue FoundCombinedTokenData = GetCombinedTokenFromPosition (CurrentLineTokens, CombinedTokens, StartIndex);
    if (FoundCombinedTokenData == null) return;
    String FoundCombinedToken = FoundCombinedTokenData.StringValue;
    int FoundCombinedTokenEndIndex = FoundCombinedTokenData.IntegerValue;
    
    // remove tokens to combine
    for (int i = FoundCombinedTokenEndIndex; i > StartIndex; i --) {
      CurrentLineTokens.remove(i);
    }
    
    // replace start token with combined token
    CurrentLineTokens.set(StartIndex, FoundCombinedToken);
    
  }
  
  
  
  
  
  ReturnValue GetCombinedTokenFromPosition (ArrayList <String> CurrentLineTokens, String[] CombinedTokens, int StartIndex) {
    String PossibleCombinedToken = "";
    int ResultIndex = 0;
    int CurrentLineTokensSize = CurrentLineTokens.size();
    int CombinedTokensLength = CombinedTokens.length;
    
    ReturnValue Return = null;
    
    for (int i = StartIndex; i < CurrentLineTokensSize; i ++) {
      PossibleCombinedToken += CurrentLineTokens.get(i);
      
      // skip results that are too short
      while (CombinedTokens[ResultIndex].length() < PossibleCombinedToken.length()) {
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return Return;
      }
    
      // add another token if the next results are too long
      if (CombinedTokens[ResultIndex].length() > PossibleCombinedToken.length()) continue;
      
      // test results
      while (PossibleCombinedToken.length() == CombinedTokens[ResultIndex].length()) {
        if (PossibleCombinedToken.equals(CombinedTokens[ResultIndex])) {
          Return = new ReturnValue();
          Return.StringValue = PossibleCombinedToken;
          Return.IntegerValue = i;
        }
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return Return;
      }
      
    }
    
    return Return;
    
  }
  
  
  
  
  
  
  
  
  
  
  void LexCodeData (LooFCodeData CodeData, LooFAddonsData AddonsData) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    
    // generate basic statements
    LooFStatement[] Statements = new LooFStatement [CodeTokens.size()];
    for (int i = 0; i < Statements.length; i ++) {
      LooFStatement CurrentStatement = GetStatementFromLine (CodeTokens.get(i), AddonsData, CodeData, i);
      SimplifyNestedFormulasForStatement (CurrentStatement);
      Statements[i] = CurrentStatement;
    }
    
    CodeData.Statements = Statements;
    
    // make sure they will work and fill in any additional data
    for (int i = 0; i < Statements.length; i ++) {
      LooFStatement CurrentStatement = Statements[i];
      if (CurrentStatement.StatementType != StatementType_Function) continue;
      CurrentStatement.Function.FinishStatement (CurrentStatement, CodeData, i);
    }
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine (ArrayList <String> CurrentLineTokens, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    
    // get basic data
    ReturnValue BlocksData = GetAllBlockLevelsAndEnds (CurrentLineTokens, CodeData, LineNumber);
    ArrayList <Integer> BlockLevels = BlocksData.IntegerArrayListValue;
    ArrayList <Integer> BlockEnds = BlocksData.SecondIntegerArrayListValue;
    HashMap <String, LooFInterpreterAssignment> InterpreterAssignments = AddonsData.InterpreterAssignments;
    HashMap <String, LooFInterpreterTweakAssignment> InterpreterTweakAssignments = AddonsData.InterpreterTweakAssignments;
    HashMap <String, LooFInterpreterFunction> InterpreterFunctions = AddonsData.InterpreterFunctions;
    
    // interpreter functions
    LooFInterpreterFunction FoundInterpreterFunction = InterpreterFunctions.get(CurrentLineTokens.get(0));
    if (FoundInterpreterFunction != null) {
      return GetStatementFromLine_InterpreterFunction (CurrentLineTokens, FoundInterpreterFunction, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    }
    
    if (CurrentLineTokens.size() < 2) throw (new LooFCompileException (CodeData, LineNumber, "could not understand statement type. No interpreter function named \"" + CurrentLineTokens.get(0) + "\" exists, and statement is not long enough to be an assignment."));
    
    // get assignment token
    int PossibleAssignmentTokenIndex = 1;
    String PossibleAssignmentToken = CurrentLineTokens.get(PossibleAssignmentTokenIndex);
    while (PossibleAssignmentToken.equals("[")) {
      PossibleAssignmentTokenIndex = BlockEnds.get(PossibleAssignmentTokenIndex) + 1;
      PossibleAssignmentToken = CurrentLineTokens.get(PossibleAssignmentTokenIndex);
    }
    int AssignmentTokenIndex = PossibleAssignmentTokenIndex;
    String AssignmentToken = PossibleAssignmentToken;
    
    // interpreter assignments
    LooFInterpreterAssignment FoundInterpreterAssignment = InterpreterAssignments.get(AssignmentToken);
    if (FoundInterpreterAssignment != null) {
      return GetStatementFromLine_Assignment (CurrentLineTokens, FoundInterpreterAssignment, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    }
    
    // interpreter tweak assignments
    LooFInterpreterTweakAssignment FoundInterpreterTweakAssignment = InterpreterTweakAssignments.get(AssignmentToken);
    if (FoundInterpreterTweakAssignment != null) {
      return GetStatementFromLine_TweakAssignment (CurrentLineTokens, FoundInterpreterTweakAssignment, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    }
    
    // unknown statement type
    throw (new LooFCompileException (CodeData, LineNumber, "could not understand statement type. No interpreter function named \"" + CurrentLineTokens.get(0) + "\" exists, and token number " + AssignmentTokenIndex + " (\"" + AssignmentToken + "\") is not an assignment."));
    
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine_Assignment (ArrayList <String> CurrentLineTokens, LooFInterpreterAssignment InterpreterAssignment, int AssignmentTokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    
    // index queries
    LooFTokenBranch[] IndexQueries = GetIndexQueriesForStatement (CurrentLineTokens, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    
    // formula for new value
    LooFTokenBranch NewValueFormula = GetLexedFormula (CurrentLineTokens, AssignmentTokenIndex + 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    
    // assemble final statement
    String AssignmentName = CurrentLineTokens.get(AssignmentTokenIndex);
    String VarName = CurrentLineTokens.get(0);
    LooFStatement Output = new LooFStatement (AssignmentName, VarName, IndexQueries, InterpreterAssignment, NewValueFormula);
    
    return Output;
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine_TweakAssignment (ArrayList <String> CurrentLineTokens, LooFInterpreterTweakAssignment InterpreterTweakAssignment, int AssignmentTokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    
    // index queries
    LooFTokenBranch[] IndexQueries = GetIndexQueriesForStatement (CurrentLineTokens, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    
    // assemble final statement
    String TweakAssignmentName = CurrentLineTokens.get(AssignmentTokenIndex);
    String VarName = CurrentLineTokens.get(0);
    LooFStatement Output = new LooFStatement (TweakAssignmentName, VarName, IndexQueries, InterpreterTweakAssignment);
    
    return Output;
  }
  
  
  
  
  
  LooFTokenBranch[] GetIndexQueriesForStatement (ArrayList <String> CurrentLineTokens, int AssignmentTokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    ArrayList <LooFTokenBranch> IndexQueriesList = new ArrayList <LooFTokenBranch> ();
    int PossibleIndexIndex = 1;
    
    while (PossibleIndexIndex < AssignmentTokenIndex) {
      int IndexEndIndex = BlockEnds.get(PossibleIndexIndex) - 1;
      LooFTokenBranch IndexQueryFormula = GetLexedFormula (CurrentLineTokens, PossibleIndexIndex + 1, IndexEndIndex, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
      IndexQueryFormula.TokenType = TokenBranchType_Index;
      //IndexFormula.IsAction = true;  // this is more correct but it's not needed
      IndexQueriesList.add(IndexQueryFormula);
      PossibleIndexIndex = IndexEndIndex + 2;
    }
    
    return ArrayListToArray (IndexQueriesList, new LooFTokenBranch());
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine_InterpreterFunction (ArrayList <String> CurrentLineTokens, LooFInterpreterFunction InterpreterFunction, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    
    // get args
    LooFTokenBranch[] FunctionStatementArgs = GetFunctionStatementArgs (CurrentLineTokens, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    
    // assemble final statement
    LooFStatement Output = new LooFStatement (CurrentLineTokens.get(0), InterpreterFunction, FunctionStatementArgs);
    
    return Output;
  }
  
  
  
  LooFTokenBranch[] GetFunctionStatementArgs (ArrayList <String> CurrentLineTokens, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    if (CurrentLineTokens.size() == 1) return new LooFTokenBranch [0];
    LooFTokenBranch ArgsAsTable = GetLexedTable (CurrentLineTokens, 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
    return ArgsAsTable.Children;
  }
  
  
  
  
  
  LooFTokenBranch GetLexedFormula (ArrayList <String> CurrentLineTokens, int FormulaBlockStart, int FormulaBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    ArrayList <LooFTokenBranch> FormulaChildrenList = new ArrayList <LooFTokenBranch> ();
    for (int i = FormulaBlockStart; i < FormulaBlockEnd + 1; i ++) {
      String CurrentToken = CurrentLineTokens.get(i);
      LooFTokenBranch NewChild = GetTokenBranchFromToken (CurrentToken, CurrentLineTokens, i, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
      FormulaChildrenList.add(NewChild);
      int BlockEnd = BlockEnds.get(i);
      if (BlockEnd != -1) i = BlockEnd;
    }
    LooFTokenBranch[] FormulaChildren = ArrayListToArray (FormulaChildrenList, new LooFTokenBranch (0));
    EnsureFormulaTokensAreValid (FormulaChildren, CodeData, LineNumber, FormulaBlockStart);
    LooFTokenBranch LexedFormula = new LooFTokenBranch (TokenBranchType_Formula, FormulaChildren, false);
    FillFormulaTokenEvaluationOrders (LexedFormula);
    return LexedFormula;
  }
  
  
  
  LooFTokenBranch GetTokenBranchFromToken (String CurrentToken, ArrayList <String> CurrentLineTokens, int TokenNumber, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    
    switch (CurrentToken) {
      
      // Type_Null
      case ("null"):
        return new LooFTokenBranch();
      
      // Type_Formula
      case ("("):
        return GetLexedFormula (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
      
      // Type_Index
      case ("["):
        LooFTokenBranch IndexFormula = GetLexedFormula (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
        IndexFormula.TokenType = TokenBranchType_Index;
        IndexFormula.IsAction = true;
        return IndexFormula;
      
      // Type_Table
      case ("{"):
        return GetLexedTable (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber);
      
    }
    
    // Type_Operaion
    LooFEvaluatorOperation FoundOperation = AddonsData.EvaluatorOperations.get(CurrentToken);
    if (FoundOperation != null) {
      return new LooFTokenBranch (FoundOperation, CurrentToken);
    }
    
    // Type_Function
    LooFEvaluatorFunction FoundFunction = AddonsData.EvaluatorFunctions.get(CurrentToken);
    if (FoundFunction != null) {
      return new LooFTokenBranch (FoundFunction, CurrentToken);
    }
    
    // Type_String
    if (CurrentToken.charAt(0) == '"') {
      String StringValue = CurrentToken.substring(1, CurrentToken.length() - 1);
      return new LooFTokenBranch (TokenBranchType_String, StringValue, true, false);
    }
    
    // Type_Int
    if (TokenIsInt (CurrentToken)) {
      return new LooFTokenBranch (Long.parseLong(CurrentToken));
    }
    
    // Type_Float
    if (TokenIsFloat (CurrentToken)) {
      return new LooFTokenBranch (Double.parseDouble(CurrentToken));
    }
    
    // error if periods are missused
    int FoundPeriodIndex = CurrentToken.indexOf('.');
    if (FoundPeriodIndex != -1) {
      int FoundSecondPeriodIndex = CurrentToken.indexOf('.', FoundPeriodIndex + 1);
      if (FoundSecondPeriodIndex != -1) throw (new LooFCompileException (CodeData, LineNumber, TokenNumber, "a token cannot have more than one period."));
      throw (new LooFCompileException (CodeData, LineNumber, TokenNumber, "a token can only have a include a period if it is a float."));
    }
    
    // Type_VarName
    return new LooFTokenBranch (TokenBranchType_VarName, CurrentToken, true, false);
    
  }
  
  
  
  
  
  void EnsureFormulaTokensAreValid (LooFTokenBranch[] FormulaChildren, LooFCodeData CodeData, int LineNumber, int TokenOffset) {
    
    switch (FormulaChildren[0].TokenType) {
      
      case (TokenBranchType_Index):
        throw (new LooFCompileException (CodeData, LineNumber, TokenOffset, "formulas cannot start with an index query."));
      
      case (TokenBranchType_EvaluatorOperation):
        throw (new LooFCompileException (CodeData, LineNumber, TokenOffset, "formulas cannot start with an evaluator operation."));
      
    }
    
    switch (GetLastItemOf(FormulaChildren).TokenType) {
      
      case (TokenBranchType_EvaluatorOperation):
        throw (new LooFCompileException (CodeData, LineNumber, TokenOffset, "formulas cannot end with an evaluator operation."));
      
      case (TokenBranchType_EvaluatorFunction):
        throw (new LooFCompileException (CodeData, LineNumber, TokenOffset, "formulas cannot end with an evaluator function."));
      
    }
    
    // ensure index queries are valid
    for (int i = 1; i < FormulaChildren.length; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_Index) continue;
      LooFTokenBranch PrevToken = FormulaChildren[i - 1];
      if (!PrevToken.ConvertsToDataValue) throw (new LooFCompileException (CodeData, LineNumber, i + TokenOffset, "cannot index a token of type " + TokenBranchTypeNames[PrevToken.TokenType] + "."));
    }
    
    // ensure evaluator operations are valid
    for (int i = 1; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_EvaluatorOperation) continue;
      LooFTokenBranch PrevToken = FormulaChildren[i - 1];
      if (!PrevToken.ConvertsToDataValue) throw (new LooFCompileException (CodeData, LineNumber, i + TokenOffset, "cannot perform an evaluator operation where the left token is of type " + TokenBranchTypeNames[PrevToken.TokenType] + "."));
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (!NextToken.ConvertsToDataValue) throw (new LooFCompileException (CodeData, LineNumber, i + TokenOffset, "cannot perform an evaluator operation where the right token is of type " + TokenBranchTypeNames[NextToken.TokenType] + "."));
    }
    
    // ensure evaluator functions are valid
    for (int i = 0; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_EvaluatorFunction) continue;
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (!NextToken.ConvertsToDataValue) throw (new LooFCompileException (CodeData, LineNumber, i + TokenOffset, "cannot perform an evaluator function on a token of type " + TokenBranchTypeNames[NextToken.TokenType] + "."));
    }
    
    // ensure no double non-action tokens
    for (int i = 0; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.IsAction) continue;
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (NextToken.IsAction) continue;
      throw (new LooFCompileException (CodeData, LineNumber, i + TokenOffset, "cannot have two non-acting tokens next to each other (" + TokenBranchTypeNames[CurrentToken.TokenType] + " and " + TokenBranchTypeNames[NextToken.TokenType] + "). (maybe you misspelled a function name?)"));
    }
    
  }
  
  
  
  
  
  void FillFormulaTokenEvaluationOrders (LooFTokenBranch FormulaToken) {
    ArrayList <Integer> IndexQueryIndexes = new ArrayList <Integer> ();
    ArrayList <Integer> FunctionIndexes = new ArrayList <Integer> ();
    ArrayList <Integer> OperationIndexes = new ArrayList <Integer> ();
    ArrayList <Float> OperationOrders = new ArrayList <Float> ();
    LooFTokenBranch[] FormulaChildren = FormulaToken.Children;
    
    // get index query indexes
    for (int i = 1; i < FormulaChildren.length; i ++) {
      if (FormulaChildren[i].TokenType == TokenBranchType_Index) {
        IndexQueryIndexes.add(i);
      }
    }
    
    // get function indexes
    for (int i = FormulaChildren.length - 1; i >= 0; i --) {
      if (FormulaChildren[i].TokenType == TokenBranchType_EvaluatorFunction) {
        FunctionIndexes.add(i);
      }
    }
    
    // get operation indexes
    for (int i = 0; i < FormulaChildren.length; i ++) {
      if (FormulaChildren[i].TokenType == TokenBranchType_EvaluatorOperation) {
        OperationIndexes.add(i);
        OperationOrders.add(FormulaChildren[i].Operation.GetOrder());
      }
    }
    
    // sort operation indexes based on operation orders
    FloatIntPair[] OperationIndexesAndOrders = new FloatIntPair [OperationIndexes.size()];
    for (int i = 0; i < OperationIndexesAndOrders.length; i ++) {
      OperationIndexesAndOrders[i] = new FloatIntPair (OperationOrders.get(i), OperationIndexes.get(i));
    }
    Arrays.sort(OperationIndexesAndOrders, new FloatIntPairComparator());
    
    // fill orders
    FormulaToken.IndexQueryIndexes = ToPrimitive (ArrayListToArray (IndexQueryIndexes, 0));
    FormulaToken.FunctionIndexes = ToPrimitive (ArrayListToArray (FunctionIndexes, 0));
    FormulaToken.OperationIndexes = OperationIndexesAndOrders;
    
    ShiftAllFormulaTokenEvaluationOrders (FormulaToken);
    
  }
  
  
  
  
  
  void ShiftAllFormulaTokenEvaluationOrders (LooFTokenBranch FormulaToken) {
    
    int[] IndexQueryIndexes = FormulaToken.IndexQueryIndexes;
    int[] FunctionIndexes = FormulaToken.FunctionIndexes;
    FloatIntPair[] OperationIndexes = FormulaToken.OperationIndexes;
    
    for (int i = 0; i < IndexQueryIndexes.length; i ++) {
      int CurrentIndexQueryIndex = IndexQueryIndexes[i];
      ShiftEvaluationOrdersPastIndex (IndexQueryIndexes, CurrentIndexQueryIndex, -1);
      ShiftEvaluationOrdersPastIndex (FunctionIndexes, CurrentIndexQueryIndex, -1);
      ShiftOperationOrdersPastIndex (OperationIndexes, CurrentIndexQueryIndex, 1000000, -1);
    }
    
    for (int i = 0; i < FunctionIndexes.length; i ++) {
      int CurrentFormulaIndex = FunctionIndexes[i];
      ShiftEvaluationOrdersPastIndex (FunctionIndexes, CurrentFormulaIndex, -1);
      ShiftOperationOrdersPastIndex (OperationIndexes, CurrentFormulaIndex, 1000000, -1);
    }
    
    for (int i = 0; i < OperationIndexes.length; i ++) {
      FloatIntPair CurrentOperationIndex = OperationIndexes[i];
      ShiftOperationOrdersPastIndex (OperationIndexes, CurrentOperationIndex.IntValue, CurrentOperationIndex.FloatValue, -2);
    }
    
  }
  
  
  
  void ShiftEvaluationOrdersPastIndex (int[] EvaluationOrders, int StartIndex, int ShiftAmount) {
    for (int i = 0; i < EvaluationOrders.length; i ++) {
      if (EvaluationOrders[i] > StartIndex) EvaluationOrders[i] += ShiftAmount;
    }
  }
  
  
  
  void ShiftOperationOrdersPastIndex (FloatIntPair[] OperationIndexes, int StartIndex, float MaximumOrder, int ShiftAmount) {
    for (int i = 0; i < OperationIndexes.length; i ++) {
      FloatIntPair CurrentOperationIndex = OperationIndexes[i];
      if (CurrentOperationIndex.IntValue > StartIndex && CurrentOperationIndex.FloatValue <= MaximumOrder) {
        CurrentOperationIndex.IntValue += ShiftAmount;
      }
    }
  }
  
  
  
  
  
  LooFTokenBranch GetLexedTable (ArrayList <String> CurrentLineTokens, int TableBlockStart, int TableBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, int LineNumber) {
    if (TableBlockStart == TableBlockEnd + 1) return new LooFTokenBranch (TokenBranchType_Table, new LooFTokenBranch [0], false);
    int TableBlockLevel = BlockLevels.get(TableBlockStart);
    ArrayList <LooFTokenBranch> Items = new ArrayList <LooFTokenBranch> ();
    
    int ItemStartIndex = TableBlockStart;
    int PrevNextCommaIndex = ItemStartIndex - 1;
    int NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, TableBlockStart, TableBlockEnd, TableBlockLevel, BlockLevels);
    while (NextCommaIndex != -1) {
      Items.add (GetLexedFormula (CurrentLineTokens, ItemStartIndex, NextCommaIndex - 1, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber));
      ItemStartIndex = NextCommaIndex + 1;
      PrevNextCommaIndex = NextCommaIndex;
      NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, NextCommaIndex + 1, TableBlockEnd, TableBlockLevel, BlockLevels);
    }
    Items.add (GetLexedFormula (CurrentLineTokens, PrevNextCommaIndex + 1, TableBlockEnd, BlockLevels, BlockEnds, AddonsData, CodeData, LineNumber));
    
    return new LooFTokenBranch (TokenBranchType_Table, ArrayListToArray (Items, new LooFTokenBranch (0)), false);
  }
  
  
  
  
  
  int GetNextCommaIndex (ArrayList <String> CurrentLineTokens, int StartIndex, int TableBlockEnd, int TableBlockLevel, ArrayList <Integer> BlockLevels) {
    
    int NextCommaIndex = FindTokenIndex (",", CurrentLineTokens, StartIndex, TableBlockEnd);
    if (NextCommaIndex == -1) return -1;
    int NextCommaLevel = BlockLevels.get(NextCommaIndex);
    if (NextCommaLevel < TableBlockLevel) return -1;
    
    while (NextCommaLevel > TableBlockLevel) {
      NextCommaIndex = FindTokenIndex (",", CurrentLineTokens, NextCommaIndex + 1, TableBlockEnd);
      if (NextCommaIndex == -1) return -1;
      NextCommaLevel = BlockLevels.get(NextCommaIndex);
      if (NextCommaLevel < TableBlockLevel) return -1;
    }
    
    return NextCommaIndex;
    
  }
  
  
  
  
  
  int FindTokenIndex (String TokenToFind, ArrayList <String> CurrentLineTokens, int StartIndex) {
    return FindTokenIndex (TokenToFind, CurrentLineTokens, StartIndex, CurrentLineTokens.size() - 1);
  }
  
  int FindTokenIndex (String TokenToFind, ArrayList <String> CurrentLineTokens, int StartIndex, int EndIndex) {
    for (int i = StartIndex; i <= EndIndex; i ++) {
      if (CurrentLineTokens.get(i).equals(TokenToFind)) return i;
    }
    return -1;
  }
  
  
  
  
  
  ReturnValue GetAllBlockLevelsAndEnds (ArrayList <String> CurrentLineTokens, LooFCodeData CodeData, int LineNumber) {
    ArrayList <Integer> BlockLevels = new ArrayList <Integer> ();
    ArrayList <Integer> BlockEnds = CreateFilledArrayList (CurrentLineTokens.size(), -1);
    ArrayList <Integer> BlockTypes = new ArrayList <Integer> ();
    ArrayList <Integer> BlockStarts = new ArrayList <Integer> ();
    int CurrentBlockLevel = 0;
    int CurrentLineTokensSize = CurrentLineTokens.size();
    for (int i = 0; i < CurrentLineTokensSize; i ++) {
      BlockLevels.add(CurrentBlockLevel);
      
      char FirstTokenChar = CurrentLineTokens.get(i).charAt(0);
      int BracketType = GetBracketType (FirstTokenChar);
      
      // no bracket
      if (BracketType == 0) continue;
      
      // starting bracket
      if (BracketType > 0) {
        CurrentBlockLevel ++;
        BlockTypes.add(BracketType);
        BlockStarts.add(i);
        continue;
      }
      
      // ending brackets
      CurrentBlockLevel --;
      if (BlockTypes.size() == 0) throw (new LooFCompileException (CodeData, LineNumber, "unexpected ending bracket at token " + i + " (\"" + FirstTokenChar + "\"): no starting bracket found."));
      int LastBracketType = BlockTypes.remove(BlockTypes.size() - 1);
      if (BracketType * -1 != LastBracketType) throw (new LooFCompileException (CodeData, LineNumber, "unexpected ending bracket at token " + i + " (\"" + FirstTokenChar + "\"): miss-matched bracket types."));
      int BlockStart = BlockStarts.remove(BlockStarts.size() - 1);
      BlockEnds.set(BlockStart, i);
      
    }
    if (BlockTypes.size() > 0) throw (new LooFCompileException (CodeData, LineNumber, "no closing bracket was found for the bracket at token " + BlockStarts.get(BlockStarts.size() - 1) + " (\"" + GetBracketFromType (BlockTypes.get(BlockTypes.size() - 1)) + "\")."));
    ReturnValue Return = new ReturnValue ();
    Return.IntegerArrayListValue = BlockLevels;
    Return.SecondIntegerArrayListValue = BlockEnds;
    return Return;
  }
  
  
  
  int GetBracketType (char Bracket) {
    switch (Bracket) {
      
      default:
        return 0;
      
      case ('('):
        return 1;
      
      case (')'):
        return -1;
      
      case ('['):
        return 2;
      
      case (']'):
        return -2;
      
      case ('{'):
        return 3;
      
      case ('}'):
        return -3;
      
    }
  }
  
  
  
  char GetBracketFromType (int Type) {
    switch (Type) {
      
      default:
        return 0;
      
      case (1):
        return '(';
      
      case (-1):
        return ')';
      
      case (2):
        return '[';
      
      case (-2):
        return ']';
      
      case (3):
        return '{';
      
      case (-3):
        return '}';
      
    }
  }
  
  
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFStatement Statement, int CorrectNumberOfArgs, LooFCodeData CodeData, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs != CorrectNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + CorrectNumberOfArgs + " arguments, but " + (NumberOfArgs < CorrectNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFStatement Statement, int MinNumberOfArgs, int MaxNumberOfArgs, LooFCodeData CodeData, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs < MinNumberOfArgs || NumberOfArgs > MaxNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "either " : "between ") + MinNumberOfArgs + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "or " : "and ") + MaxNumberOfArgs + " arguments, but " + (NumberOfArgs < MinNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Unbounded (LooFStatement Statement, int MinNumberOfArgs, LooFCodeData CodeData, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs < MinNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + MinNumberOfArgs + " arguments, but only " + NumberOfArgs + " were found."));
  }
  
  
  
  
  
  void SimplifyAllOutputVars (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    for (int i = 0; i < NumberOfArgs; i ++) {
      SimplifySingleOutputVar (Statement, i, CodeData, LineNumber);
    }
  }
  
  
  
  void SimplifySingleOutputVar (LooFStatement Statement, int OutputVarIndex, LooFCodeData CodeData, int LineNumber) {
    LooFTokenBranch OutputArg = Statement.Args[OutputVarIndex];
    LooFTokenBranch[] OutputArgChildren = OutputArg.Children;
    if (OutputArgChildren.length != 1) throw (new LooFCompileException (CodeData, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to."));
    LooFTokenBranch OutputVarToken = OutputArgChildren[0];
    if (OutputVarToken.TokenType != TokenBranchType_VarName) throw (new LooFCompileException (CodeData, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to, not a " + TokenBranchTypeNames[OutputVarToken.TokenType] + "."));
    OutputVarToken.TokenType = TokenBranchType_OutputVar;
    Statement.Args[OutputVarIndex] = OutputVarToken;
  }
  
  
  
  
  
  void SimplifyNestedFormulasForStatement (LooFStatement Statement) {
    switch (Statement.StatementType) {
      
      case (StatementType_Assignment):
        Statement.NewValueFormula = GetSimplifyNestedFormulas (Statement.NewValueFormula);
        return;
      
      case (StatementType_TweakAssignment):
        return;
      
      case (StatementType_Function):
        if (Statement.Args.length == 0) return;
        LooFTokenBranch[] Args = Statement.Args;
        for (int i = 0; i < Args.length; i ++) {
          Args[i] = GetSimplifyNestedFormulas (Args[i]);
        }
        return;
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  LooFTokenBranch GetSimplifyNestedFormulas (LooFTokenBranch TokenBranch) {
    LooFTokenBranch[] Children = TokenBranch.Children;
    if (Children.length != 1) return TokenBranch;
    if (Children[0].TokenType != TokenBranchType_Formula) return TokenBranch;
    return Children[0];
  }
  
  
  
  
  
  int FindStatementOnSameLevel (String[] StatementToFind, int StartingLineNumber, int Increment, LooFStatement[] AllStatements, LooFCodeData CodeData) {
    int BlockLevel = 0;
    int StartIndex = StartingLineNumber + Increment;
    int EndIndex = (Increment > 0) ? AllStatements.length : -1;
    for (int i = StartIndex; i != EndIndex; i += Increment) {
      if (BlockLevel < 0) throw (new LooFCompileException (CodeData, StartingLineNumber, "could not find a matching statement of type {" + CombineStringsWithSeperator (StatementToFind, ", ") + "} (first statement found was not on the same block level)."));
      LooFStatement CurrentStatement = AllStatements[i];
      if (CurrentStatement.StatementType != StatementType_Function) continue;
      
      if (BlockLevel == 0 && TableContainsItem (StatementToFind, CurrentStatement.Name)) {
        return i;
      }
      
      LooFInterpreterFunction StatementFunction = CurrentStatement.Function;
      BlockLevel += StatementFunction.GetBlockLevelChange();
      
    }
    throw (new LooFCompileException (CodeData, StartingLineNumber, "could not find a matching statement of type {" + CombineStringsWithSeperator (StatementToFind, ", ") + "} (statement completely missing)."));
  }
  
  
  
  
  
  
  
  
  
  
  void PrintPreProcessorOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      PrintWriter FileOutput = createWriter (FileOutputName);
      
      ArrayList <String> Code = CodeData.CodeArrayList;
      ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
      ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
      for (int i = 0; i < Code.size(); i ++) {
        String Line = Code.get(i);
        int LineNumber = LineNumbers.get(i);
        String LineFileOrigin = LineFileOrigins.get(i);
        FileOutput.println (LineFileOrigin + " " + LineNumber + ": " + Line);
      }
      
      FileOutput.flush();
      FileOutput.close();
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintLinkerOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      PrintWriter FileOutput = createWriter (FileOutputName);
      
      ArrayList <String> Code = CodeData.CodeArrayList;
      ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
      ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
      for (int i = 0; i < Code.size(); i ++) {
        String Line = Code.get(i);
        int LineNumber = LineNumbers.get(i);
        String LineFileOrigin = LineFileOrigins.get(i);
        FileOutput.println (LineFileOrigin + " " + LineNumber + ": " + Line);
      }
      
      FileOutput.println();
      for (int j = 0; j < 100; j ++) FileOutput.print('-');
      FileOutput.println();
      HashMap <String, Integer> FunctionLocations = CodeData.FunctionLocations;
      Set <String> AllFunctionNames = FunctionLocations.keySet();
      for (String CurrFunctionName : AllFunctionNames) {
        int CurrFunctionLocation = FunctionLocations.get(CurrFunctionName);
        FileOutput.println ("Function \"" + CurrFunctionName + "\": " + CurrFunctionLocation);
      }
      
      FileOutput.flush();
      FileOutput.close();
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintLexerOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      PrintWriter FileOutput = createWriter (FileOutputName);
      
      ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
      ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
      ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
      for (int i = 0; i < CodeTokens.size(); i ++) {
        ArrayList <String> Line = CodeTokens.get(i);
        int LineNumber = LineNumbers.get(i);
        String LineFileOrigin = LineFileOrigins.get(i);
        FileOutput.println (LineFileOrigin + " " + LineNumber + ": \"" + CombineStringsWithSeperator (Line, "\"   \"") + "\"");
      }
      
      FileOutput.flush();
      FileOutput.close();
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintParserOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      PrintWriter FileOutput = createWriter (FileOutputName);
      
      LooFStatement[] Statements = CodeData.Statements;
      ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
      ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
      for (int i = 0; i < Statements.length; i ++) {
        LooFStatement CurrentStatement = Statements[i];
        int LineNumber = LineNumbers.get(i);
        String LineFileOrigin = LineFileOrigins.get(i);
        FileOutput.println (LineFileOrigin + " " + LineNumber + ": " + ConvertLooFStatementToString (CurrentStatement));
      }
      
      FileOutput.flush();
      FileOutput.close();
    }
  }
  
  
  
  
  
  
  
  
  
  
}
