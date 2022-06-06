LooFCompiler LooFCompiler = new LooFCompiler();

class LooFCompiler {
  
  
  
  
  
  
  
  
  
  
  LooFEnvironment CompileEnvironmentFromFolder (File CodeFolder, LooFCompileSettings CompileSettings) {
    
    if (CodeFolder == null) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument (File argument is null)."));
    if (!CodeFolder.exists()) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument (File does not exist)."));
    if (!CodeFolder.isDirectory()) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument. (File is not a folder)."));
    if (CompileSettings == null) throw (new LooFCompilerException ("AddNewEnvironment cannot take a null LoofCompileSettings object. Either pass a new LooFCompileSettings object or call AddNewEvironment with no LooFCompileSettings argument."));
    
    StartTimer ("Total");
    
    ClearCompilerOutputs (CompileSettings);
    
    StartTimer ("OnlyCompilation");
    
    
    
    ArrayList <LooFCompilerException> AllExceptions = new ArrayList <LooFCompilerException> ();
    
    
    
    // get default addons
    LooFAddonsData AddonsData = GetAddonsDataForEnvironment (CompileSettings);
    
    String[] CombinedTokens = GetCombinedTokens (AddonsData);
    
    
    
    // start CodeData-s
    Tuple2 <HashMap <String, LooFCodeData>, String[]> LoadedPagesData;
    try {
      LoadedPagesData = LoadFilesIntoNewCodeDatas (CodeFolder);
    } catch (IOException e) {
      throw (new LooFCompilerException ("could not load files into CodeData-s: " + e.toString()));
    }
    HashMap <String, LooFCodeData> AllCodeDatas = LoadedPagesData.Value1;
    String[] HeaderFileContents = LoadedPagesData.Value2;
    
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    
    
    // pre-process CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      PreProcessCodeData (CodeData, AllCodeDatas, HeaderFileContents, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.PreProcessorOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintPreProcessorOutput (AllCodeDatas, CompileSettings.PreProcessorOutputPath, "PreProcessedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // link CodeData-s
    LinkAllCodeDatas (AllCodeDatas, AllExceptions);
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.LinkerOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintLinkerOutput (AllCodeDatas, CompileSettings.LinkerOutputPath, "LinkedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // lex CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      LexCodeData (CodeData, AllCodeDatas, CombinedTokens, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.LexerOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintLexerOutput (AllCodeDatas, CompileSettings.LexerOutputPath, "LexedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // parse CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      ParseCodeData (CodeData, AllCodeDatas, AddonsData, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.ParserOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintParserOutput (AllCodeDatas, CompileSettings.ParserOutputPath, "ParsedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // finish statements
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      FinishStatements (CodeData, AllCodeDatas, AddonsData, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.FinalOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintFinalOutput (AllCodeDatas, CompileSettings.FinalOutputPath, "FinalLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // create environement
    LooFEnvironment NewEnvironment = new LooFEnvironment (AllCodeDatas, AddonsData);
    
    
    
    StopTimer ("OnlyCompilation");
    StopTimer ("Total");
    
    System.out.println ("Compiled environment from folder " + CodeFolder + ".");
    System.out.println ("Total time for only compiling: " + GetTimerMillis ("OnlyCompilation") + " ms.");
    System.out.println ("Total time: " + GetTimerMillis ("Total") + " ms.");
    
    
    
    return NewEnvironment;
    
  }
  
  
  
  
  
  
  
  
  
  
  void ClearCompilerOutputs (LooFCompileSettings CompileSettings) {
    if (CompileSettings.PreProcessorOutputPath != null) DeleteAllFilesOfType (CompileSettings.PreProcessorOutputPath, "PreProcessedLOOF");
    if (CompileSettings.LinkerOutputPath       != null) DeleteAllFilesOfType (CompileSettings.LinkerOutputPath      , "LinkedLOOF"      );
    if (CompileSettings.LexerOutputPath        != null) DeleteAllFilesOfType (CompileSettings.LexerOutputPath       , "LexerLOOF"       );
    if (CompileSettings.ParserOutputPath       != null) DeleteAllFilesOfType (CompileSettings.ParserOutputPath      , "ParserLOOF"      );
    if (CompileSettings.FinalOutputPath        != null) DeleteAllFilesOfType (CompileSettings.FinalOutputPath       , "FinalLOOF"       );
  }
  
  
  
  
  
  
  
  
  
  
  LooFAddonsData GetAddonsDataForEnvironment (LooFCompileSettings CompileSettings) {
    LooFAddonsData AddonsData = new LooFAddonsData();
    AddonsData.InterpreterModules     = GetInterpreterModulesForEnvironment     (CompileSettings);
    AddonsData.InterpreterAssignments = GetInterpreterAssignmentsForEnvironment (CompileSettings);
    AddonsData.InterpreterFunctions   = GetInterpreterFunctionsForEnvironment   (CompileSettings);
    AddonsData.EvaluatorOperations    = GetEvaluatorOperationsForEnvironment    (CompileSettings);
    AddonsData.EvaluatorFunctions     = GetEvaluatorFunctionsForEnvironment     (CompileSettings);
    return AddonsData;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterModule> GetInterpreterModulesForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterModule> InterpreterModules = new HashMap <String, LooFInterpreterModule> ();
    if (!CompileSettings.AddDefaultInterpreterModules) return InterpreterModules;
    
    InterpreterModules.put("Console", NullInterpreterModule);
    InterpreterModules.put("Interpreter", NullInterpreterModule);
    InterpreterModules.put("Files", NullInterpreterModule);
    InterpreterModules.put("Graphics", NullInterpreterModule);
    
    return InterpreterModules;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterAssignment> GetInterpreterAssignmentsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterAssignment> InterpreterAssignments = new HashMap <String, LooFInterpreterAssignment> ();
    if (!CompileSettings.AddDefaultInterpreterAssignments) return InterpreterAssignments;
    
    InterpreterAssignments.put("=", Assignment_Equals);
    InterpreterAssignments.put("defaultsTo", Assignment_DefaultsTo);
    InterpreterAssignments.put("+=", Assignment_PlusEquals);
    InterpreterAssignments.put("-=", Assignment_MinusEquals);
    InterpreterAssignments.put("*=", Assignment_TimesEquals);
    InterpreterAssignments.put("/=", Assignment_DivideEquals);
    InterpreterAssignments.put("^=", Assignment_PowerEquals);
    InterpreterAssignments.put("%=", Assignment_ModuloEquals);
    InterpreterAssignments.put("..=", Assignment_ConcatEquals);
    
    InterpreterAssignments.put("++", Assignment_PlusPlus);
    InterpreterAssignments.put("--", Assignment_MinusMinus);
    InterpreterAssignments.put("!!", Assignment_NotNot);
    InterpreterAssignments.put("getClone", Assignment_GetClone);
    
    return InterpreterAssignments;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterFunction> GetInterpreterFunctionsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterFunction> InterpreterFunctions = new HashMap <String, LooFInterpreterFunction> ();
    if (!CompileSettings.AddDefaultInterpreterTweakAssignments) return InterpreterFunctions;
    
    InterpreterFunctions.put("push", InterpreterFunction_Push);
    InterpreterFunctions.put("pop", InterpreterFunction_Pop);
    InterpreterFunctions.put("conditionalPop", InterpreterFunction_ConditionalPop);
    
    InterpreterFunctions.put("call", InterpreterFunction_Call);
    InterpreterFunctions.put("return", InterpreterFunction_Return);
    InterpreterFunctions.put("returnRaw", InterpreterFunction_ReturnRaw);
    InterpreterFunctions.put("returnIf", InterpreterFunction_ReturnIf);
    InterpreterFunctions.put("returnRawIf", InterpreterFunction_ReturnRawIf);
    
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
    InterpreterFunctions.put("setPassedErrors", InterpreterFunction_SetPassedErrors);
    InterpreterFunctions.put("try", InterpreterFunction_Try);
    
    InterpreterFunctions.put("callOutside", InterpreterFunction_CallOutside);
    
    return InterpreterFunctions;
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
    EvaluatorOperations.put("orDefault", Operation_OrDefault);
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
    
    EvaluatorFunctions.put("round", Function_Round);
    EvaluatorFunctions.put("floor", Function_Floor);
    EvaluatorFunctions.put("ceil", Function_Ceil);
    EvaluatorFunctions.put("abs", Function_Abs);
    EvaluatorFunctions.put("sqrt", Function_Sqrt);
    EvaluatorFunctions.put("sign", Function_Sign);
    EvaluatorFunctions.put("min", Function_Min);
    EvaluatorFunctions.put("max", Function_Max);
    EvaluatorFunctions.put("clamp", Function_Clamp);
    EvaluatorFunctions.put("log", Function_Log);
    EvaluatorFunctions.put("log10", Function_Log10);
    EvaluatorFunctions.put("ln", Function_Ln);
    EvaluatorFunctions.put("toDregees", Function_ToDegrees);
    EvaluatorFunctions.put("toRadians", Function_ToRadians);
    
    EvaluatorFunctions.put("not", Function_Not);
    EvaluatorFunctions.put("!!", Function_BitwiseNot);
    EvaluatorFunctions.put("isNaN", Function_IsNaN);
    EvaluatorFunctions.put("isInfinity", Function_IsInfinity);
    
    EvaluatorFunctions.put("sin", Function_Sin);
    EvaluatorFunctions.put("cos", Function_Cos);
    EvaluatorFunctions.put("tan", Function_Tan);
    EvaluatorFunctions.put("asin", Function_ASin);
    EvaluatorFunctions.put("acos", Function_ACos);
    EvaluatorFunctions.put("atan", Function_ATan);
    EvaluatorFunctions.put("atan2", Function_ATan2);
    EvaluatorFunctions.put("sinh", Function_SinH);
    EvaluatorFunctions.put("cosh", Function_CosH);
    EvaluatorFunctions.put("tanh", Function_TanH);
    
    EvaluatorFunctions.put("random", Function_Random);
    EvaluatorFunctions.put("randomInt", Function_RandomInt);
    EvaluatorFunctions.put("chance", Function_Chance);
    
    EvaluatorFunctions.put("lengthOf", Function_LengthOf);
    EvaluatorFunctions.put("isEmpty", NullEvaluatorFunction);
    EvaluatorFunctions.put("totalItemsIn", Function_TotalItemsIn);
    EvaluatorFunctions.put("endOf", Function_EndOf);
    EvaluatorFunctions.put("lastItemOf", Function_LastItemOf);
    EvaluatorFunctions.put("keysOf", Function_KeysOf);
    EvaluatorFunctions.put("valuesOf", Function_ValuesOf);
    EvaluatorFunctions.put("randomItem", Function_RandomItem);
    EvaluatorFunctions.put("randomValue", Function_RandomValue);
    EvaluatorFunctions.put("firstIndexOfItem", Function_FirstIndexOfItem);
    EvaluatorFunctions.put("lastIndexOfItem", Function_LastIndexOfItem);
    EvaluatorFunctions.put("allIndexesOfItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("tableContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("arrayContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("hashmapContainsItem", NullEvaluatorFunction);
    EvaluatorFunctions.put("byteArrayContainsItems", NullEvaluatorFunction);
    EvaluatorFunctions.put("splitTable", NullEvaluatorFunction);
    EvaluatorFunctions.put("removeDuplicateItems", NullEvaluatorFunction);
    EvaluatorFunctions.put("deepCloneTable", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("getChar", Function_GetChar);
    EvaluatorFunctions.put("getCharInts", Function_GetCharInts);
    EvaluatorFunctions.put("getCharByes", Function_GetCharBytes);
    EvaluatorFunctions.put("getSubString", Function_GetSubString);
    EvaluatorFunctions.put("replaceSubString", NullEvaluatorFunction);
    EvaluatorFunctions.put("replaceStrings", NullEvaluatorFunction);
    EvaluatorFunctions.put("firstIndexOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("lastIndexOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("allIndexesOfString", NullEvaluatorFunction);
    EvaluatorFunctions.put("splitString", NullEvaluatorFunction);
    EvaluatorFunctions.put("stringStartsWith", NullEvaluatorFunction);
    EvaluatorFunctions.put("stringEndsWith", NullEvaluatorFunction);
    EvaluatorFunctions.put("toLowerCase", NullEvaluatorFunction);
    EvaluatorFunctions.put("toUpperCase", NullEvaluatorFunction);
    EvaluatorFunctions.put("trimString", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("toInt", Function_ToInt);
    EvaluatorFunctions.put("toFloat", Function_ToFloat);
    EvaluatorFunctions.put("toString", Function_ToString);
    EvaluatorFunctions.put("toBool", Function_ToBool);
    
    EvaluatorFunctions.put("newFunction", Function_NewFunction);
    EvaluatorFunctions.put("getFunctionLine", NullEvaluatorFunction);
    EvaluatorFunctions.put("getFunctionFile", NullEvaluatorFunction);
    
    EvaluatorFunctions.put("typeOf", Function_TypeOf);
    EvaluatorFunctions.put("cloneValue", Function_CloneValue);
    EvaluatorFunctions.put("newByteArray", NullEvaluatorFunction);
    EvaluatorFunctions.put("timeSince", NullEvaluatorFunction);
    EvaluatorFunctions.put("switch", NullEvaluatorFunction);
    
    return EvaluatorFunctions;
  }
  
  
  
  
  
  
  
  
  
  
  String[] GetCombinedTokens (LooFAddonsData AddonsData) {
    ArrayList <String> CombinedTokens = new ArrayList <String> ();
    
    Set <String> InterpreterAssignmentNames = AddonsData.InterpreterAssignments.keySet();
    Set <String> InterpreterFunctionNames = AddonsData.InterpreterFunctions.keySet();
    Set <String> EvaluatorOperationNames = AddonsData.EvaluatorOperations.keySet();
    Set <String> EvaluatorFunctionNames = AddonsData.EvaluatorFunctions.keySet();
    
    for (String CurrentName : InterpreterAssignmentNames) {
      LooFInterpreterAssignment CurrentAddon = AddonsData.InterpreterAssignments.get(CurrentName);
      if (CurrentAddon.AddToCombinedTokens()) CombinedTokens.add(CurrentName);
    }
    
    for (String CurrentName : InterpreterFunctionNames) {
      LooFInterpreterFunction CurrentAddon = AddonsData.InterpreterFunctions.get(CurrentName);
      if (CurrentAddon.AddToCombinedTokens()) CombinedTokens.add(CurrentName);
    }
    
    for (String CurrentName : EvaluatorOperationNames) {
      LooFEvaluatorOperation CurrentAddon = AddonsData.EvaluatorOperations.get(CurrentName);
      if (CurrentAddon.AddToCombinedTokens()) CombinedTokens.add(CurrentName);
    }
    
    for (String CurrentName : EvaluatorFunctionNames) {
      LooFEvaluatorFunction CurrentAddon = AddonsData.EvaluatorFunctions.get(CurrentName);
      if (CurrentAddon.AddToCombinedTokens()) CombinedTokens.add(CurrentName);
    }
    
    CombinedTokens.sort(new StringComparator_ShortestToLongest());
    return ListToArray (CombinedTokens, "");
  }
  
  
  
  
  
  
  
  
  
  
  Tuple2 <HashMap <String, LooFCodeData>, String[]> LoadFilesIntoNewCodeDatas (File CodeFolder) throws IOException {
    
    
    
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
      if (CurrentFileName.equals("Header.LOOF")) HeaderFileContents = ReadFileAsStrings (AllFilesRaw.remove(i));
    }
    
    AllFiles = ListToArray (AllFilesRaw, new File(""));
    
    
    
    // get file names
    AllFullFileNames = new String [AllFiles.length];
    boolean MainFileFound = false;
    for (int i = 0; i < AllFiles.length; i ++) {
      String CurrentFullFileName = GetFileFullName (AllFiles[i], CodeFolder);
      AllFullFileNames[i] = CurrentFullFileName;
      if (CurrentFullFileName.equals("Main.LOOF")) MainFileFound = true;
    }
    
    // error if main file was not found
    if (!MainFileFound) throw (new LooFCompilerException ("No Main file was found. Please have a file named \"Main.LOOF\" in the folder being compiled."));
    
    
    
    // load file contents and apply header
    AllFileContents = new String [AllFiles.length] [];
    for (int i = 0; i < AllFiles.length; i ++) {
      AllFileContents[i] = ReadFileAsStrings (AllFiles[i]);
    }
    
    
    
    // create CodeData-s
    for (int i = 0; i < AllFiles.length; i ++) {
      AllCodeDatas.put(AllFullFileNames[i], new LooFCodeData (AllFileContents[i], AllFullFileNames[i]));
    }
    
    
    
    Tuple2 ReturnValue = new Tuple2 <HashMap <String, LooFCodeData>, String[]> (AllCodeDatas, HeaderFileContents);
    return ReturnValue;
  }
  
  
  
  
  
  
  
  
  
  
  void PreProcessCodeData (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String[] HeaderFileContents, ArrayList <LooFCompilerException> AllExceptions) {
    
    if (HeaderFileContents.length > 0) {
      InsertHeader (CodeData, HeaderFileContents);
    }
    AddPaddingLines (CodeData);
    RemoveComments (CodeData);
    RemoveInitialTrim (CodeData);
    ProcessIfStatements (CodeData, AllCodeDatas, AllExceptions);
    ProcessIncludes (CodeData, AllCodeDatas, HeaderFileContents.length, AllExceptions);
    ProcessReplaces (CodeData, AllCodeDatas, AllExceptions);
    RemoveExcessWhitespace (CodeData);
    CheckForIncorrectPreProcessorStatements (CodeData, AllCodeDatas, AllExceptions);
    
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
      LineFileOrigins.add(i, CodeData.OriginalFileName);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void AddPaddingLines (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    // start padding
    Code.add(0, "");
    LineNumbers.add(0, LineNumbers.get(0));
    LineFileOrigins.add(0, LineFileOrigins.get(0));
    
    // end padding
    Code.add("");
    LineNumbers.add(LastItemOf (LineNumbers));
    LineFileOrigins.add(LastItemOf (LineFileOrigins));
    
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
  
  
  
  
  
  
  
  
  
  
  void RemoveInitialTrim (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = CurrentLine.trim();
      if (!NewLine.equals(CurrentLine)) Code.set (i, NewLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessReplaces (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    HashMap <String, Boolean[]> AllCharsInQuotes = new HashMap <String, Boolean[]> ();
    for (int i = 0; i < Code.size(); i ++) {
      try {
        String CurrentLine = Code.get(i);
        if (!CurrentLine.startsWith("#replace")) continue;
        
        if (CurrentLine.startsWith("#replace ")) {
          String[][] ReplacementData = GetReplacementData (CodeData, i, 10);
          String[] ReplaceBefore = ReplacementData[0];
          String[] ReplaceAfter = ReplacementData[1];
          if (ReplaceBefore.length > 1) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "'#replace' cannot detect multi-line strings, either remove the '\\n' or use '#replaceMultiLine'."));
          ReplaceAllStringOccurances (CodeData, ReplaceBefore[0], ReplaceAfter, AllCharsInQuotes, false);
          i --;
          continue;
        }
        
        if (CurrentLine.startsWith("#replaceIgnoreQuotes ")) {
          String[][] ReplacementData = GetReplacementData (CodeData, i, 22);
          String[] ReplaceBefore = ReplacementData[0];
          String[] ReplaceAfter = ReplacementData[1];
          if (ReplaceBefore.length > 1) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "'#replaceIgnoreQuotes' cannot detect multi-line strings, either remove the '\\n' or use '#replaceMultiLine'."));
          ReplaceAllStringOccurances (CodeData, ReplaceBefore[0], ReplaceAfter, AllCharsInQuotes, true);
          i --;
          continue;
        }
        
        if (CurrentLine.startsWith("#replaceMultiLine ")) {
          String[][] ReplacementData = GetReplacementData (CodeData, i, 19);
          String[] ReplaceBefore = ReplacementData[0];
          String[] ReplaceAfter = ReplacementData[1];
          ReplaceAllStringOccurances_MultiLine (CodeData, ReplaceBefore, ReplaceAfter);
          i --;
          continue;
        }
        
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  String[][] GetReplacementData (LooFCodeData CodeData, int i, int SearchStart) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    String CurrentLine = Code.remove(i);
    LineNumbers.remove(i);
    LineFileOrigins.remove(i);
    
    String[] RawReplacementData = GetRawReplacementData (CurrentLine, SearchStart);
    
    String[] ReplaceBefore = FormatBackslashes (RawReplacementData[0]);
    String[] ReplaceAfter = FormatBackslashes (RawReplacementData[1]);
    
    return new String[][] {ReplaceBefore, ReplaceAfter};
  }
  
  
  
  String[] GetRawReplacementData (String CurrentLine, int SearchStart) {
    int CurrentLineLength = CurrentLine.length();
    
    // find first (not in string) '"'
    int i = SearchStart;
    for (@SuppressWarnings("unused") int VOID = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int FirstMiddleQuote = i;
    
    // find second (not in string) '"'
    i ++;
    for (@SuppressWarnings("unused") int VOID = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int SecondMiddleQuote = i;
    
    // get string parts based on quote locations
    String ReplaceBefore = CurrentLine.substring (SearchStart, FirstMiddleQuote);
    String ReplaceAfter  = CurrentLine.substring (SecondMiddleQuote + 1, CurrentLineLength - 1);
    
    return new String[] {ReplaceBefore, ReplaceAfter};
  }
  
  
  
  
  
  void ReplaceAllStringOccurances (LooFCodeData CodeData, String ReplaceBefore, String[] ReplaceAfter, HashMap <String, Boolean[]> AllCharsInQuotes, boolean IgnoreQuotes) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int LinesToJumpPerReplace = ReplaceAfter.length - 1;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("#replace")) continue;  // NOT "#replace "
      ArrayList <Integer> AllReplacementPositions = GetAllPositionsOfString (CurrentLine, AllCharsInQuotes, ReplaceBefore, IgnoreQuotes);
      ReplaceAllStringOccurancesInLine (CodeData, CurrentLine, i, AllReplacementPositions, ReplaceBefore, ReplaceAfter);
      int LinesToJump = LinesToJumpPerReplace * AllReplacementPositions.size();
      i += LinesToJump;
    }
  }
  
  
  
  ArrayList <Integer> GetAllPositionsOfString (String StringIn, HashMap <String, Boolean[]> AllCharsInQuotes, String StringToFind, boolean IgnoreQuotes) {
    ArrayList <Integer> Output = new ArrayList <Integer> ();
    
    Boolean[] CharsInQuotes = null;
    if (!IgnoreQuotes) {
      CharsInQuotes = AllCharsInQuotes.getOrDefault (StringIn, null);
      if (CharsInQuotes == null) {
        CharsInQuotes = ToObject (GetCharsInQuotes (StringIn));
        AllCharsInQuotes.put(StringIn, CharsInQuotes);
      }
    }
    
    int FoundIndex = StringIn.indexOf(StringToFind);
    while (FoundIndex != -1) {
      if (IgnoreQuotes || !CharsInQuotes[FoundIndex]) Output.add(FoundIndex);
      FoundIndex = StringIn.indexOf(StringToFind, FoundIndex + 1);
    }
    return Output;
    
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
  
  
  
  
  
  void ReplaceAllStringOccurances_MultiLine (LooFCodeData CodeData, String[] ReplaceBefore, String[] ReplaceAfter) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int LinesToJump = ReplaceAfter.length - ReplaceBefore.length;
    for (int i = 0; i < Code.size() - ReplaceBefore.length + 1; i ++) {
      if (!MultiLineReplaceMatchesLine (Code, i, ReplaceBefore)) continue;
      ReplaceMultiLineString (CodeData, i, ReplaceBefore, ReplaceAfter);
      i += LinesToJump;
    }
  }
  
  
  
  boolean MultiLineReplaceMatchesLine (ArrayList <String> Code, int LineNumber, String[] ReplaceBefore) {
    int StartIndex = LineNumber;
    int EndIndex = LineNumber + ReplaceBefore.length - 1;
    
    if (!Code.get(StartIndex).endsWith(ReplaceBefore[0])) return false;
    if (!Code.get(EndIndex).startsWith(LastItemOf (ReplaceBefore))) return false;
    
    for (int i = 1; i < ReplaceBefore.length - 2; i ++) {
      String CurrentLineToMatch = ReplaceBefore[i];
      if (!Code.get(i + StartIndex).equals(CurrentLineToMatch)) return false;
    }
    
    return true;
    
  }
  
  
  
  void ReplaceMultiLineString (LooFCodeData CodeData, int LineNumber, String[] ReplaceBefore, String[] ReplaceAfter) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    int CurrentLineNumber = LineNumbers.get(LineNumber);
    String CurrentLineFileOrigin = LineFileOrigins.get(LineNumber);
    
    // remove the lines inside the replaced area
    for (int i = 1; i < ReplaceBefore.length - 1; i ++) {
      Code.remove(i + LineNumber);
      LineNumbers.remove(i + LineNumber);
      LineFileOrigins.remove(i + LineNumber);
    }
    
    // get edges of the replaced area
    int AreaEndIndex = LineNumber + ReplaceBefore.length - 1;
    String ReplacedAreaStart = Code.get(LineNumber);
    String ReplacedAreaEnd = Code.get(AreaEndIndex);
    ReplacedAreaStart = ReplacedAreaStart.substring (0, ReplacedAreaStart.length() - ReplaceBefore[0].length());
    ReplacedAreaEnd = ReplacedAreaEnd.substring (LastItemOf (ReplaceBefore).length());
    
    // single line replacement
    if (ReplaceAfter.length == 1) {
      Code.remove(LineNumber);
      LineNumbers.remove(LineNumber);
      LineFileOrigins.remove(LineNumber);
      Code.set(LineNumber, ReplacedAreaStart + ReplaceAfter[0] + ReplacedAreaEnd);
      LineNumbers.set(LineNumber, CurrentLineNumber);
      LineFileOrigins.set(LineNumber, CurrentLineFileOrigin);
      return;
    }
    
    // multi-line replacement
    ReplacedAreaStart += ReplaceAfter[0];
    ReplacedAreaEnd = LastItemOf (ReplaceAfter) + ReplacedAreaEnd;
    Code.set(LineNumber, ReplacedAreaStart);
    Code.set(AreaEndIndex, ReplacedAreaEnd);
    
    for (int i = 1; i < ReplaceAfter.length - 1; i ++) {
      Code.add(i + LineNumber, ReplaceAfter[i]);
      LineNumbers.add(i + LineNumber, CurrentLineNumber);
      LineFileOrigins.add(i + LineNumber, CurrentLineFileOrigin);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessIncludes (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int HeaderLength, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        String CurrentLine = Code.get(i);
        if (!CurrentLine.startsWith("#include ")) continue;
        ProcessIncludesForLine (CodeData, CurrentLine, i, AllCodeDatas, HeaderLength, AllExceptions);
        i --; // for if the included file starts with an #include
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void ProcessIncludesForLine (LooFCodeData CodeData, String CurrentLine, int LineNumber, HashMap <String, LooFCodeData> AllCodeDatas, int HeaderLength, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    String FileName = CurrentLine.substring(9);
    
    // get file to include
    String FullFileName = GetFullFileNameFromPartialFileName (FileName, AllCodeDatas, CodeData, LineNumber);
    if (FullFileName == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not include the file " + FileName + " because the file could not be found."));
    LooFCodeData FileToInclude = AllCodeDatas.get(FullFileName);
    
    // get code to include and data about it
    String[] FileToIncludeContents = FileToInclude.OriginalCode;
    String FileToIncludeName = FileToInclude.OriginalFileName;
    int LineNumberOffset = FileToInclude.IncludesHeader ? -HeaderLength : 0;
    int InsertionStartIndex = LineNumber - 1;
    
    // remove #include (has to be done here to not mess up the error messages)
    Code.remove(LineNumber);
    LineNumbers.remove(LineNumber);
    LineFileOrigins.remove(LineNumber);
    
    // insert code
    int FileToIncludeStartIndex = FileToInclude.IncludesHeader ? 0 : 1; // for skipping #ignore_header
    for (int i = FileToIncludeStartIndex; i < FileToIncludeContents.length; i ++) {
      String LineToInsert = FileToIncludeContents[i];
      Code.add(InsertionStartIndex + i, LineToInsert);
      LineNumbers.add(InsertionStartIndex + i, i + LineNumberOffset);
      LineFileOrigins.add(InsertionStartIndex + i, FileToIncludeName);
    }
    
    // process new data
    ProcessIfStatements (CodeData, AllCodeDatas, LineNumber, LineNumber + FileToIncludeContents.length, AllExceptions);
    
  }
  
  
  
  
  
  String GetFullFileNameFromPartialFileName (String PartialFileName, HashMap <String, LooFCodeData> AllCodeDatas, LooFCodeData CodeData, int LineNumber) {
    Set <String> AllFullFileNames = AllCodeDatas.keySet();
    String FoundFullFileName = null;
    for (String CurrentFullFileName : AllFullFileNames) {
      if (CurrentFullFileName.endsWith(PartialFileName)) {
        if (FoundFullFileName != null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "the file name \"" + PartialFileName + "\" is ambigous since it refers to both \"" + FoundFullFileName + "\" and \"" + CurrentFullFileName + "\"."));
        FoundFullFileName = CurrentFullFileName;
      }
    }
    return FoundFullFileName;
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessIfStatements (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ProcessIfStatements (CodeData, AllCodeDatas, 0, CodeData.CodeArrayList.size(), AllExceptions);
  }
  
  
  
  void ProcessIfStatements (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int StartIndex, int EndIndex, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = StartIndex; i < min (EndIndex, Code.size()); i ++) {
      try {
        String CurrentLine = Code.get(i).trim();
        if (!CurrentLine.startsWith("#if_")) continue;
        
        if (CurrentLine.startsWith("#if_equal ")) {
          String IfStatementData = CurrentLine.substring (10);
          boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, AllCodeDatas, IfStatementData, i, "#if_equal", CodeData.OriginalFileName);
          if (!IfStatementResult) RemoveCodeUntilEndIf (CodeData, AllCodeDatas, i);
          continue;
        }
        
        if (CurrentLine.startsWith("#if_not_equal ")) {
          String IfStatementData = CurrentLine.substring (14);
          boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, AllCodeDatas, IfStatementData, i, "#if_not_equal", CodeData.OriginalFileName);
          if (IfStatementResult) RemoveCodeUntilEndIf (CodeData, AllCodeDatas, i);
          continue;
        }
        
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  boolean CheckIfIfStatementArgumentsMatch (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String IfStatementData, int LineNumber, String PreProcessorStatementType, String OriginalFileName) {
    ArrayList <String> IfStatementArguments = GetSpaceSeperatedStrings (IfStatementData);
    int NumberOfArguments = IfStatementArguments.size();
    if (NumberOfArguments != 2) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, PreProcessorStatementType + " takes 2 string arguments, but found " + NumberOfArguments + (NumberOfArguments == 1 ? " was" : " were") + " found."));
    String String1 = FillIfStatementArgument (IfStatementArguments.get(0), OriginalFileName);
    String String2 = FillIfStatementArgument (IfStatementArguments.get(1), OriginalFileName);
    return String1.equals(String2);
  }
  
  
  
  String FillIfStatementArgument (String StringIn, String OriginalFileName) {
    switch (StringIn) {
      
      default:
        return StringIn;
      
      case ("FILE_NAME"):
        return '"' + OriginalFileName + '"';
      
    }
  }
  
  
  
  void RemoveCodeUntilEndIf (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int StartIndex) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    int EndIfIndex = FindNextEndIf (CodeData, AllCodeDatas, StartIndex);
    
    for (int i = StartIndex; i <= EndIfIndex; i ++) {
      Code.remove(i);
      LineNumbers.remove(i);
      LineFileOrigins.remove(i);
    }
    
  }
  
  
  
  int FindNextEndIf (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int StartIndex) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int Level = 0;
    for (int i = StartIndex; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("#if_")) Level ++;
      if (CurrentLine.equals("#end_if")) {
        Level --;
        if (Level == 0) return i;
      }
    }
    throw (new LooFCompilerException (CodeData, AllCodeDatas, StartIndex, "could not find matching \"#end_if\" for \"#if_...\" preprocessor statement."));
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
  
  
  
  
  
  
  
  
  
  
  void CheckForIncorrectPreProcessorStatements (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        if (Code.get(i).startsWith("#")) {
          throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "unknown pre-processor statement."));
        }
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  
  
  
  
  
  
  void LinkAllCodeDatas (HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    // simplify linking statements
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      try {
        FindLinkedFiles (CodeData, AllCodeDatas);
        FindFunctionLocations (CodeData, AllCodeDatas);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
    
    // replace function references
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      try {
        ReplaceFunctionCalls (CodeData, AllCodeDatas);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
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
        
        // get link data
        String[] LinkData = GetLinkData (CurrentLine, AllCodeDatas, CodeData, i);
        String LinkShortenedName = LinkData[0];
        String LinkFileName = LinkData[1];
        
        // add to LinkedFiles
        if (LinkedFiles.containsKey(LinkShortenedName)) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "the shortened link name \"" + LinkShortenedName + "\" is already in use for file \"" + LinkedFiles.get(LinkShortenedName) + "\"."));
        LinkedFiles.put(LinkShortenedName, LinkFileName);
        
        // remove line (has to be done here to not mess up the error messages)
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        i --;
        
      }
    }
  }
  
  
  
  String[] GetLinkData (String CurrentLine, HashMap <String, LooFCodeData> AllCodeDatas, LooFCodeData CodeData, int LineNumber) {
    
    // get the name of the file being linked
    int FoundSeperatorIndex = CurrentLine.indexOf(" as ");
    int LinkedFileNameEnd = (FoundSeperatorIndex == -1) ? CurrentLine.length() : FoundSeperatorIndex;
    String LinkedFileName = CurrentLine.substring(6, LinkedFileNameEnd);
    String LinkedFileFullName = GetFullFileNameFromPartialFileName (LinkedFileName, AllCodeDatas, CodeData, LineNumber);
    if (LinkedFileFullName == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not link the file \"" + LinkedFileName + " because the file could not be found."));
    
    // return if done
    if (FoundSeperatorIndex == -1) return new String[] {RemoveFileExtention (LinkedFileFullName), LinkedFileFullName};
    
    // get the shortened file name
    String ShortenedName = CurrentLine.substring(FoundSeperatorIndex + 4);
    return new String[] {ShortenedName, LinkedFileFullName};
    
  }
  
  
  
  
  
  
  
  
  
  void FindFunctionLocations (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    HashMap <String, Integer> FunctionLineNumbers = CodeData.FunctionLineNumbers;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("$function ")) {
        
        String FunctionName = CurrentLine.substring(10);
        if (FunctionLineNumbers.get(FunctionName) != null) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "function \"" + FunctionName + "\" already exists."));
        
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        
        FunctionLineNumbers.put(FunctionName, i);
        
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
  
  
  
  
  
  String ReplaceSingleFunctionCall (String CurrentLine, int FunctionCallStart, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int FunctionCallEnd = GetFunctionCallEnd (CurrentLine, FunctionCallStart);
    String BeforeFunctionCall = CurrentLine.substring(0, FunctionCallStart);
    String FunctionCallData = CurrentLine.substring(FunctionCallStart + 1, FunctionCallEnd);
    String AfterFunctionCall = CurrentLine.substring(FunctionCallEnd);
    
    String NewFunctionCallData = GetLinkedFunctionCall (FunctionCallData, CodeData, AllCodeDatas, LineNumber);
    
    return BeforeFunctionCall + NewFunctionCallData + AfterFunctionCall;
  }
  
  
  
  int GetFunctionCallEnd (String CurrentLine, int FunctionCallStart) {
    int CurrentLineLength = CurrentLine.length();
    for (int i = FunctionCallStart + 1; i < CurrentLineLength; i ++) {
      if (CharStartsNewToken (CurrentLine.charAt(i))) return i;
    }
    return CurrentLineLength;
  }
  
  
  
  
  
  String GetLinkedFunctionCall (String FunctionCallData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int LastPeriodIndex = FunctionCallData.lastIndexOf('.');
    if (LastPeriodIndex == -1) {
      return GetLinkedFunctionCall_WithinFile (FunctionCallData, CodeData, AllCodeDatas, LineNumber);
    }
    return GetLinkedFunctionCall_OutsideFile (FunctionCallData, LastPeriodIndex, CodeData, AllCodeDatas, LineNumber);
  }
  
  
  
  String GetLinkedFunctionCall_WithinFile (String FunctionCallData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    Integer FunctionLocation = CodeData.FunctionLineNumbers.get(FunctionCallData);
    if (FunctionLocation == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "no function named \"" + FunctionCallData + "\" could be found."));
    return "newFunction {" + FunctionLocation.toString() + "}";
  }
  
  
  
  String GetLinkedFunctionCall_OutsideFile (String FunctionCallData, int LastPeriodIndex, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    // get data from FunctionCallData
    String FunctionName = FunctionCallData.substring(LastPeriodIndex + 1);
    String ShortenedFileName = FunctionCallData.substring(0, LastPeriodIndex);
    
    // get full file name
    String FullFileName = CodeData.LinkedFiles.get(ShortenedFileName);
    if (FullFileName == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "no file was found linked as \"" + ShortenedFileName + "\"."));
    
    // get linked file
    LooFCodeData LinkedCodeData = AllCodeDatas.get(FullFileName);
    if (LinkedCodeData == null) throw new AssertionError();
    
    // get location of function
    Integer FunctionLocation = LinkedCodeData.FunctionLineNumbers.get(FunctionName);
    if (FunctionLocation == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "no function named \"" + FunctionName + "\" could be found in the file \"" + FullFileName + "\"."));
    
    // assemble and return new function data
    return "newFunction {" + FunctionLocation + ", \"" + FullFileName + "\"}";
  }
  
  
  
  
  
  
  
  
  
  
  void LexCodeData (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, String[] CombinedTokens, ArrayList <LooFCompilerException> AllExceptions) {
    TokenizeCode (CodeData, AllCodeDatas, AllExceptions);
    CombineTokensForCode (CodeData, CombinedTokens, AllExceptions);
  }
  
  
  
  
  
  
  
  
  
  
  void TokenizeCode (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    ArrayList <ArrayList <Boolean>> TokensFollowedBySpaces = CodeData.TokensFollowedBySpaces;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        String CurrentLine = Code.get(i);
        Tuple2 <ArrayList <String>, ArrayList <Boolean>> TokenizedLineData = TokenizeLineOfCode (CurrentLine, CodeData, AllCodeDatas, i);
        CodeTokens.add(TokenizedLineData.Value1);
        TokensFollowedBySpaces.add(TokenizedLineData.Value2);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  Tuple2 <ArrayList <String>, ArrayList <Boolean>> TokenizeLineOfCode (String CurrentLine, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    ArrayList <String> CurrentLineTokens = new ArrayList <String> ();
    ArrayList <Boolean> TokensFollowedBySpaces = new ArrayList <Boolean> ();
    int CurrentLineLength = CurrentLine.length();
    String CurrToken = CurrentLine.charAt(0) + "";
    for (int i = 1; i < CurrentLineLength; i ++) {
      char PrevChar = CurrentLine.charAt(i - 1);
      char CurrChar = CurrentLine.charAt(i);
      
      if (CurrChar == '"') {
        if (CurrToken.length() != 0) {
          CurrentLineTokens.add(CurrToken);
          TokensFollowedBySpaces.add(PrevChar == ' ');
        }
        int EndQuoteIndex = GetEndQuoteIndex (CurrentLine, i, CodeData, AllCodeDatas, LineNumber);
        CurrentLineTokens.add(CurrentLine.substring(i, EndQuoteIndex + 1));
        TokensFollowedBySpaces.add((EndQuoteIndex == CurrentLineLength - 1) ? false : CurrentLine.charAt (EndQuoteIndex + 1) == ' ');
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
          TokensFollowedBySpaces.add((i == CurrentLineLength - 1) ? false : CurrentLine.charAt (i) == ' ');
          CurrToken = "";
        }
        if (!CharIsWhitespace (CurrChar)) {
          CurrToken += CurrChar;
        }
        continue;
      }
      
      if (!CharIsWhitespace (CurrChar)) {
        CurrToken += CurrChar;
      }
      
    }
    if (CurrToken.length() != 0) {
      CurrentLineTokens.add(CurrToken);
      TokensFollowedBySpaces.add(CurrentLine.charAt(CurrentLineLength - 1) == ' ');
    }
    Tuple2 <ArrayList <String>, ArrayList <Boolean>> ReturnValue = new Tuple2 <ArrayList <String>, ArrayList <Boolean>> (CurrentLineTokens, TokensFollowedBySpaces);
    return ReturnValue;
  }
  
  
  
  
  
  int GetEndQuoteIndex (String CurrentLine, int i, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int EndQuoteIndex = i;
    int FakeEndQuoteIndex = i - 1;
    while (EndQuoteIndex == FakeEndQuoteIndex + 1) {
      FakeEndQuoteIndex = CurrentLine.indexOf('\\', EndQuoteIndex + 1);
      EndQuoteIndex = CurrentLine.indexOf('"', EndQuoteIndex + 1);
      if (EndQuoteIndex == -1) {
        throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find a matching end-quote for the quote at char " + i + "."));
      }
    }
    return EndQuoteIndex;
  }
  
  
  
  
  
  
  
  
  
  
  void CombineTokensForCode (LooFCodeData CodeData, String[] CombinedTokens, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    ArrayList <ArrayList <Boolean>> TokensFollowedBySpaces = CodeData.TokensFollowedBySpaces;
    for (int i = 0; i < CodeTokens.size(); i ++) {
      try {
        ArrayList <String> CurrentLineTokens = CodeTokens.get(i);
        ArrayList <Boolean> CurrentLineTokensFollowedBySpaces = TokensFollowedBySpaces.get(i);
        CombineTokensForLine (CurrentLineTokens, CurrentLineTokensFollowedBySpaces, CombinedTokens);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  
  
  void CombineTokensForLine (ArrayList <String> CurrentLineTokens, ArrayList <Boolean> TokensFollowedBySpaces, String[] CombinedTokens) {
    for (int i = 0; i < CurrentLineTokens.size(); i ++) {
      CombineTokensForLineAtPosition (CurrentLineTokens, TokensFollowedBySpaces, CombinedTokens, i);
    }
  }
  
  
  
  
  
  void CombineTokensForLineAtPosition (ArrayList <String> CurrentLineTokens, ArrayList <Boolean> TokensFollowedBySpaces, String[] CombinedTokens, int StartIndex) {
    
    // find any fitting combined token
    Tuple2 <String, Integer> FoundCombinedTokenData = GetCombinedTokenFromPosition (CurrentLineTokens, TokensFollowedBySpaces, CombinedTokens, StartIndex);
    if (FoundCombinedTokenData == null) return;
    String FoundCombinedToken = FoundCombinedTokenData.Value1;
    int FoundCombinedTokenEndIndex = FoundCombinedTokenData.Value2;
    
    // remove tokens to combine
    for (int i = FoundCombinedTokenEndIndex; i > StartIndex; i --) {
      CurrentLineTokens.remove(i);
    }
    
    // replace start token with combined token
    CurrentLineTokens.set(StartIndex, FoundCombinedToken);
    
  }
  
  
  
  
  
  Tuple2 <String, Integer> GetCombinedTokenFromPosition (ArrayList <String> CurrentLineTokens, ArrayList <Boolean> TokensFollowedBySpaces, String[] CombinedTokens, int StartIndex) {
    if (CombinedTokens.length == 0) return null;
    String PossibleCombinedToken = "";
    int ResultIndex = 0;
    int CurrentLineTokensSize = CurrentLineTokens.size();
    int CombinedTokensLength = CombinedTokens.length;
    
    Tuple2 <String, Integer> ReturnValue = null;
    
    for (int i = StartIndex; i < CurrentLineTokensSize; i ++) {
      if (i != StartIndex && TokensFollowedBySpaces.get(i - 1)) return ReturnValue;
      PossibleCombinedToken += CurrentLineTokens.get(i);
      
      // skip results that are too short
      while (CombinedTokens[ResultIndex].length() < PossibleCombinedToken.length()) {
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return ReturnValue;
      }
    
      // add another token if the next results are too long
      if (CombinedTokens[ResultIndex].length() > PossibleCombinedToken.length()) continue;
      
      // test results
      while (PossibleCombinedToken.length() == CombinedTokens[ResultIndex].length()) {
        if (PossibleCombinedToken.equals(CombinedTokens[ResultIndex])) {
          ReturnValue = new Tuple2 <String, Integer> (PossibleCombinedToken, i);
        }
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return ReturnValue;
      }
      
    }
    
    return ReturnValue;
    
  }
  
  
  
  
  
  
  
  
  
  
  void ParseCodeData (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, LooFAddonsData AddonsData, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    LooFStatement[] Statements = new LooFStatement [CodeTokens.size()];
    for (int i = 0; i < Statements.length; i ++) {
      try {
        
        LooFStatement CurrentStatement = GetStatementFromLine (CodeTokens.get(i), AddonsData, CodeData, AllCodeDatas, i);
        SimplifyNestedFormulasForStatement (CurrentStatement);
        Statements[i] = CurrentStatement;
        
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
    CodeData.Statements = Statements;
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine (ArrayList <String> CurrentLineTokens, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    // get basic data
    Tuple2 <ArrayList <Integer>, ArrayList <Integer>> BlocksData = GetAllBlockLevelsAndEnds (CurrentLineTokens, CodeData, AllCodeDatas, LineNumber);
    ArrayList <Integer> BlockLevels = BlocksData.Value1;
    ArrayList <Integer> BlockEnds = BlocksData.Value2;
    HashMap <String, LooFInterpreterAssignment> InterpreterAssignments = AddonsData.InterpreterAssignments;
    HashMap <String, LooFInterpreterFunction> InterpreterFunctions = AddonsData.InterpreterFunctions;
    
    // interpreter functions
    LooFInterpreterFunction FoundInterpreterFunction = InterpreterFunctions.get(CurrentLineTokens.get(0));
    if (FoundInterpreterFunction != null) {
      return GetStatementFromLine_InterpreterFunction (CurrentLineTokens, FoundInterpreterFunction, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    }
    
    if (CurrentLineTokens.size() < 2) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not understand statement type. No interpreter function named \"" + CurrentLineTokens.get(0) + "\" exists, and statement is not long enough to be an assignment."));
    
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
      return GetStatementFromLine_Assignment (CurrentLineTokens, FoundInterpreterAssignment, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    }
    
    // unknown statement type
    throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not understand statement type. No interpreter function named \"" + CurrentLineTokens.get(0) + "\" exists, and token number " + AssignmentTokenIndex + " (\"" + AssignmentToken + "\") is not an assignment."));
    
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine_Assignment (ArrayList <String> CurrentLineTokens, LooFInterpreterAssignment Assignment, int AssignmentTokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    // check for args
    boolean HasArgs = CurrentLineTokens.size() > AssignmentTokenIndex + 1;
    boolean AssignmentTakesArgs = Assignment.TakesArgs();
    if (HasArgs != AssignmentTakesArgs) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "this assignment " + (AssignmentTakesArgs ? "takes" : "does not take") + " arguments, but arguments " + (HasArgs ? "were" : "were not") + " found."));
    
    // index queries
    LooFTokenBranch[] IndexQueries = GetIndexQueriesForStatement (CurrentLineTokens, AssignmentTokenIndex, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    
    // formula for new value
    LooFTokenBranch NewValueFormula = null;
    if (HasArgs) {
      NewValueFormula = GetParsedFormula (CurrentLineTokens, AssignmentTokenIndex + 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    }
    
    // assemble final statement
    String AssignmentName = CurrentLineTokens.get(AssignmentTokenIndex);
    String VarName = CurrentLineTokens.get(0);
    LooFStatement Output = new LooFStatement (AssignmentName, VarName, IndexQueries, Assignment, NewValueFormula);
    
    return Output;
  }
  
  
  
  
  
  LooFTokenBranch[] GetIndexQueriesForStatement (ArrayList <String> CurrentLineTokens, int AssignmentTokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    ArrayList <LooFTokenBranch> IndexQueriesList = new ArrayList <LooFTokenBranch> ();
    int PossibleIndexIndex = 1;
    
    while (PossibleIndexIndex < AssignmentTokenIndex) {
      int IndexEndIndex = BlockEnds.get(PossibleIndexIndex) - 1;
      LooFTokenBranch IndexQueryFormula = GetParsedFormula (CurrentLineTokens, PossibleIndexIndex + 1, IndexEndIndex, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      IndexQueryFormula.TokenType = TokenBranchType_Index;
      IndexQueryFormula.OriginalString = "[";
      //IndexFormula.IsAction = true;  // this is more correct but it's not needed
      IndexQueriesList.add(IndexQueryFormula);
      PossibleIndexIndex = IndexEndIndex + 2;
    }
    
    return ListToArray (IndexQueriesList, new LooFTokenBranch (0, ""));
  }
  
  
  
  
  
  LooFStatement GetStatementFromLine_InterpreterFunction (ArrayList <String> CurrentLineTokens, LooFInterpreterFunction InterpreterFunction, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    // get args
    LooFTokenBranch[] FunctionStatementArgs = GetFunctionStatementArgs (CurrentLineTokens, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    
    // assemble final statement
    LooFStatement Output = new LooFStatement (CurrentLineTokens.get(0), (LooFInterpreterFunction) InterpreterFunction, FunctionStatementArgs);
    
    return Output;
  }
  
  
  
  LooFTokenBranch[] GetFunctionStatementArgs (ArrayList <String> CurrentLineTokens, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (CurrentLineTokens.size() == 1) return new LooFTokenBranch [0];
    LooFTokenBranch ArgsAsTable = GetParsedTable (CurrentLineTokens, 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    return ArgsAsTable.Children;
  }
  
  
  
  
  
  LooFTokenBranch GetParsedFormula (ArrayList <String> CurrentLineTokens, int FormulaBlockStart, int FormulaBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    ArrayList <LooFTokenBranch> FormulaChildrenList = new ArrayList <LooFTokenBranch> ();
    for (int i = FormulaBlockStart; i < FormulaBlockEnd + 1; i ++) {
      String CurrentToken = CurrentLineTokens.get(i);
      LooFTokenBranch NewChild = GetTokenBranchFromToken (CurrentToken, CurrentLineTokens, i, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      FormulaChildrenList.add(NewChild);
      int BlockEnd = BlockEnds.get(i);
      if (BlockEnd != -1) i = BlockEnd;
    }
    LooFTokenBranch[] FormulaChildren = ListToArray (FormulaChildrenList, new LooFTokenBranch (0, ""));
    EnsureFormulaTokensAreValid (FormulaChildren, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch ParsedFormula = new LooFTokenBranch (FormulaBlockStart - 1, "(", FormulaChildren, new HashMap <String, LooFTokenBranch> ());
    FillFormulaTokenEvaluationOrders (ParsedFormula);
    FillTokenBranchCanBePreEvaluated (ParsedFormula);
    return ParsedFormula;
  }
  
  
  
  LooFTokenBranch GetTokenBranchFromToken (String CurrentToken, ArrayList <String> CurrentLineTokens, int TokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    switch (CurrentToken) {
      
      // constants
      case ("PI"): return new LooFTokenBranch (TokenIndex, CurrentToken, Math.PI);
      
      case ("E"): return new LooFTokenBranch (TokenIndex, CurrentToken, Math.E);
      
      case ("MAX_INT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Long.MAX_VALUE);
      
      case ("MIN_INT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Long.MIN_VALUE);
      
      case ("MAX_FLOAT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.MAX_VALUE);
      
      case ("MIN_FLOAT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.MIN_VALUE);
      
      case ("POSITIVE_INFINITY"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.POSITIVE_INFINITY);
      
      case ("NEGATIVE_INFINITY"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.NEGATIVE_INFINITY);
      
      case ("FLOAT_NAN"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.NaN);
      
      // Type_Bool
      case ("true"): return new LooFTokenBranch (TokenIndex, CurrentToken, true);
      case ("false"): return new LooFTokenBranch (TokenIndex, CurrentToken, false);
      
      // Type_Null
      case ("null"):
        return new LooFTokenBranch (TokenIndex, CurrentToken);
      
      // Type_Formula
      case ("("):
        return GetParsedFormula (CurrentLineTokens, TokenIndex + 1, BlockEnds.get(TokenIndex) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      
      // Type_Index
      case ("["):
        LooFTokenBranch IndexFormula = GetParsedFormula (CurrentLineTokens, TokenIndex + 1, BlockEnds.get(TokenIndex) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
        IndexFormula.TokenType = TokenBranchType_Index;
        IndexFormula.OriginalString = "[";
        IndexFormula.IsAction = true;
        return IndexFormula;
      
      // Type_Table
      case ("{"):
        return GetParsedTable (CurrentLineTokens, TokenIndex + 1, BlockEnds.get(TokenIndex) - 1, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      
    }
    
    // Type_Operaion
    LooFEvaluatorOperation FoundOperation = AddonsData.EvaluatorOperations.get(CurrentToken);
    if (FoundOperation != null) {
      return new LooFTokenBranch (TokenIndex, CurrentToken, FoundOperation);
    }
    
    // Type_Function
    LooFEvaluatorFunction FoundFunction = AddonsData.EvaluatorFunctions.get(CurrentToken);
    if (FoundFunction != null) {
      return new LooFTokenBranch (TokenIndex, CurrentToken, FoundFunction);
    }
    
    // Type_String
    if (CurrentToken.charAt(0) == '"') {
      String StringValue = CurrentToken.substring(1, CurrentToken.length() - 1);
      return new LooFTokenBranch (TokenIndex, CurrentToken, TokenBranchType_String, StringValue, true, false);
    }
    
    // Type_Int
    Long CurrentTokenAsLong = GetLongFromToken (CurrentToken, CodeData, AllCodeDatas, LineNumber, TokenIndex);
    if (CurrentTokenAsLong != null) {
      return new LooFTokenBranch (TokenIndex, CurrentToken, CurrentTokenAsLong);
    }
    
    // Type_Float
    if (TokenIsFloat (CurrentToken)) {
      return new LooFTokenBranch (TokenIndex, CurrentToken, Double.parseDouble(CurrentToken));
    }
    
    // error if periods are missused
    int FoundPeriodIndex = CurrentToken.indexOf('.');
    if (FoundPeriodIndex != -1) {
      int FoundSecondPeriodIndex = CurrentToken.indexOf('.', FoundPeriodIndex + 1);
      if (FoundSecondPeriodIndex != -1) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, TokenIndex, "a token cannot have more than one period."));
      throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, TokenIndex, "a token can only have a include a period if it is a float."));
    }
    
    if (!(StringContainsLetters (CurrentToken) || CurrentToken.equals("_"))) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, TokenIndex, "cannot recognize token type for \"" + CurrentToken + "\"."));
    
    // Type_VarName
    return new LooFTokenBranch (TokenIndex, CurrentToken, TokenBranchType_VarName, CurrentToken, true, false);
    
  }
  
  
  
  
  
  Long GetLongFromToken (String CurrentToken, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber, int TokenIndex) {
    
    if (TokenIsInt (CurrentToken)) return Long.parseLong(CurrentToken);
    
    if (CurrentToken.length() < 3) return null;
    boolean TokenIsNegative = CurrentToken.charAt(0) == '-';
    if (TokenIsNegative) CurrentToken = CurrentToken.substring(1);
    if (CurrentToken.charAt(0) != '0') return null;
    
    int Base = 0;
    switch (CurrentToken.charAt(1)) {
      case ('x'):
        Base = 16;
        break;
      case ('b'):
        Base = 2;
        break;
      default:
        return null;
    }
    
    try {
      
      Long Output = Long.parseLong (CurrentToken.substring(2), Base);
      Output *= TokenIsNegative ? -1 : 1;
      return Output;
      
    } catch (NumberFormatException e) {
      throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, TokenIndex, "cannot cast token to int."));
    }
    
  }
  
  
  
  
  
  void EnsureFormulaTokensAreValid (LooFTokenBranch[] FormulaChildren, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (FormulaChildren.length == 0) return;
    
    LooFTokenBranch FirstToken = FormulaChildren[0];
    switch (FirstToken.TokenType) {
      
      case (TokenBranchType_Index):
        throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, FirstToken.OriginalTokenIndex, "formulas cannot start with an index query."));
      
      case (TokenBranchType_EvaluatorOperation):
        throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, FirstToken.OriginalTokenIndex, "formulas cannot start with an evaluator operation."));
      
    }
    
    LooFTokenBranch LastToken = LastItemOf(FormulaChildren);
    switch (LastToken.TokenType) {
      
      case (TokenBranchType_EvaluatorOperation):
        throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, LastToken.OriginalTokenIndex, "formulas cannot end with an evaluator operation."));
      
      case (TokenBranchType_EvaluatorFunction):
        throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, LastToken.OriginalTokenIndex, "formulas cannot end with an evaluator function."));
      
    }
    
    // ensure index queries are valid
    for (int i = 1; i < FormulaChildren.length; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_Index) continue;
      LooFTokenBranch PrevToken = FormulaChildren[i - 1];
      if (!PrevToken.ConvertsToDataValue) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, CurrentToken.OriginalTokenIndex, "cannot index a token of type " + TokenBranchTypeNames[PrevToken.TokenType] + "."));
    }
    
    // ensure evaluator operations are valid
    for (int i = 1; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_EvaluatorOperation) continue;
      LooFTokenBranch PrevToken = FormulaChildren[i - 1];
      if (!PrevToken.ConvertsToDataValue) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, CurrentToken.OriginalTokenIndex, "cannot perform an evaluator operation where the left token is of type " + TokenBranchTypeNames[PrevToken.TokenType] + "."));
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (!NextToken.ConvertsToDataValue) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, CurrentToken.OriginalTokenIndex, "cannot perform an evaluator operation where the right token is of type " + TokenBranchTypeNames[NextToken.TokenType] + "."));
    }
    
    // ensure evaluator functions are valid
    for (int i = 0; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.TokenType != TokenBranchType_EvaluatorFunction) continue;
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (!NextToken.ConvertsToDataValue) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, CurrentToken.OriginalTokenIndex, "cannot perform an evaluator function on a token of type " + TokenBranchTypeNames[NextToken.TokenType] + "."));
    }
    
    // ensure no double non-action tokens
    for (int i = 0; i < FormulaChildren.length - 1; i ++) {
      LooFTokenBranch CurrentToken = FormulaChildren[i];
      if (CurrentToken.IsAction) continue;
      LooFTokenBranch NextToken = FormulaChildren[i + 1];
      if (NextToken.IsAction) continue;
      throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, CurrentToken.OriginalTokenIndex, "cannot have two non-acting tokens next to each other (" + ConvertLooFTokenBranchToString(CurrentToken) + " and " + ConvertLooFTokenBranchToString(NextToken) + "). (maybe you misspelled a function name?)"));
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
    FormulaToken.IndexQueryIndexes = ToPrimitive (ListToArray (IndexQueryIndexes, 0));
    FormulaToken.FunctionIndexes = ToPrimitive (ListToArray (FunctionIndexes, 0));
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
  
  
  
  
  
  void FillTokenBranchCanBePreEvaluated (LooFTokenBranch TokenBranch) {
    boolean CanBePreEvaluated = true;
    for (LooFTokenBranch CurrentToken : TokenBranch.Children) {
      if (
        !CurrentToken.CanBePreEvaluated ||
        CurrentToken.TokenType == TokenBranchType_VarName ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorOperation && !CurrentToken.Operation.CanBePreEvaluated()) ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorFunction && !CurrentToken.Function.CanBePreEvaluated())
      ) {
        CanBePreEvaluated = false;
        break;
      }
    }
    TokenBranch.CanBePreEvaluated = CanBePreEvaluated;
  }
  
  
  
  
  
  LooFTokenBranch GetParsedTable (ArrayList <String> CurrentLineTokens, int TableBlockStart, int TableBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (TableBlockStart == TableBlockEnd + 1) return new LooFTokenBranch (TableBlockStart - 1, "{", new LooFTokenBranch [0], new HashMap <String, LooFTokenBranch> ());
    int TableBlockLevel = BlockLevels.get(TableBlockStart);
    ArrayList <LooFTokenBranch> ArrayItems = new ArrayList <LooFTokenBranch> ();
    HashMap <String, LooFTokenBranch> HashMapItems = new HashMap <String, LooFTokenBranch> ();
    
    int ItemStartIndex = TableBlockStart;
    int PrevNextCommaIndex = ItemStartIndex - 1;
    int NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, TableBlockStart, TableBlockEnd, TableBlockLevel, BlockLevels);
    while (NextCommaIndex != -1) {
      PasrseAndAddTableItem (CurrentLineTokens, ItemStartIndex, NextCommaIndex - 1, ArrayItems, HashMapItems, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      ItemStartIndex = NextCommaIndex + 1;
      PrevNextCommaIndex = NextCommaIndex;
      NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, NextCommaIndex + 1, TableBlockEnd, TableBlockLevel, BlockLevels);
    }
    if (PrevNextCommaIndex != TableBlockEnd)
      PasrseAndAddTableItem (CurrentLineTokens, PrevNextCommaIndex + 1, TableBlockEnd, ArrayItems, HashMapItems, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    
    LooFTokenBranch ParsedTable = new LooFTokenBranch (TableBlockStart - 1, "{", ListToArray (ArrayItems, new LooFTokenBranch (0, "")), HashMapItems);
    FillTokenBranchCanBePreEvaluated (ParsedTable);
    return ParsedTable;
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
  
  
  
  
  
  void PasrseAndAddTableItem (ArrayList <String> CurrentLineTokens, int FormulaBlockStart, int FormulaBlockEnd, ArrayList <LooFTokenBranch> ArrayItems, HashMap <String, LooFTokenBranch> HashMapItems, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    Tuple2 <String, LooFTokenBranch> ParsedTableItem = GetParsedTableItem (CurrentLineTokens, FormulaBlockStart, FormulaBlockEnd, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    if (ParsedTableItem.Value1 != null) {
      HashMapItems.put(ParsedTableItem.Value1, ParsedTableItem.Value2);
      return;
    }
    ArrayItems.add(ParsedTableItem.Value2);
  }
  
  
  
  Tuple2 <String, LooFTokenBranch> GetParsedTableItem (ArrayList <String> CurrentLineTokens, int FormulaBlockStart, int FormulaBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    int PossibleColonIndex = FormulaBlockStart + 1;
    boolean IsHashMapItem = PossibleColonIndex < CurrentLineTokens.size() && CurrentLineTokens.get(PossibleColonIndex).equals(":");
    if (IsHashMapItem) {
      if (FormulaBlockEnd == PossibleColonIndex) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "cannot set a hashmap value with an empty formula. (if you want the value to be null, you must write null)"));
      String HashMapKey = CurrentLineTokens.get(FormulaBlockStart);
      LooFTokenBranch ParsedFormula = GetParsedFormula (CurrentLineTokens, FormulaBlockStart + 2, FormulaBlockEnd, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
      return new Tuple2 <String, LooFTokenBranch> (HashMapKey, ParsedFormula);
    }
    
    LooFTokenBranch ParsedFormula = GetParsedFormula (CurrentLineTokens, FormulaBlockStart, FormulaBlockEnd, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    return new Tuple2 <String, LooFTokenBranch> (null, ParsedFormula);
    
  }
  
  
  
  
  
  Tuple2 <ArrayList <Integer>, ArrayList <Integer>> GetAllBlockLevelsAndEnds (ArrayList <String> CurrentLineTokens, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
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
      if (BlockTypes.size() == 0) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "unexpected ending bracket at token " + i + " (\"" + FirstTokenChar + "\"): no starting bracket found."));
      int LastBracketType = BlockTypes.remove(BlockTypes.size() - 1);
      if (BracketType * -1 != LastBracketType) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "unexpected ending bracket at token " + i + " (\"" + FirstTokenChar + "\"): miss-matched bracket types."));
      int BlockStart = BlockStarts.remove(BlockStarts.size() - 1);
      BlockEnds.set(BlockStart, i);
      
    }
    if (BlockTypes.size() > 0) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "no closing bracket was found for the bracket at token " + BlockStarts.get(BlockStarts.size() - 1) + " (\"" + GetBracketFromType (BlockTypes.get(BlockTypes.size() - 1)) + "\")."));
    Tuple2 <ArrayList <Integer>, ArrayList <Integer>> ReturnValue = new Tuple2 <ArrayList <Integer>, ArrayList <Integer>> (BlockLevels, BlockEnds);
    return ReturnValue;
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
  
  
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFStatement Statement, int CorrectNumberOfArgs, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs != CorrectNumberOfArgs) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "this statement takes " + CorrectNumberOfArgs + " arguments, but " + (NumberOfArgs < CorrectNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFStatement Statement, int MinNumberOfArgs, int MaxNumberOfArgs, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs < MinNumberOfArgs || NumberOfArgs > MaxNumberOfArgs) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "this statement takes " + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "either " : "between ") + MinNumberOfArgs + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "or " : "and ") + MaxNumberOfArgs + " arguments, but " + (NumberOfArgs < MinNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Unbounded (LooFStatement Statement, int MinNumberOfArgs, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    if (NumberOfArgs < MinNumberOfArgs) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "this statement takes " + MinNumberOfArgs + " arguments, but only " + NumberOfArgs + " were found."));
  }
  
  
  
  
  
  void SimplifyAllOutputVars (LooFStatement Statement, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int NumberOfArgs = Statement.Args.length;
    for (int i = 0; i < NumberOfArgs; i ++) {
      SimplifySingleOutputVar (Statement, i, CodeData, AllCodeDatas, LineNumber);
    }
  }
  
  
  
  void SimplifySingleOutputVar (LooFStatement Statement, int OutputVarIndex, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFTokenBranch OutputArg = Statement.Args[OutputVarIndex];
    LooFTokenBranch[] OutputArgChildren = OutputArg.Children;
    if (OutputArgChildren.length != 1) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to."));
    LooFTokenBranch OutputVarToken = OutputArgChildren[0];
    if (OutputVarToken.TokenType != TokenBranchType_VarName) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to, not " + TokenBranchTypeNames_PlusA[OutputVarToken.TokenType] + "."));
    OutputVarToken.TokenType = TokenBranchType_OutputVar;
    Statement.Args[OutputVarIndex] = OutputVarToken;
  }
  
  
  
  
  
  void SimplifyNestedFormulasForStatement (LooFStatement Statement) {
    switch (Statement.StatementType) {
      
      case (StatementType_Assignment):
        if (!Statement.Assignment.TakesArgs()) return;
        Statement.NewValueFormula = GetSimplifyNestedFormulas (Statement.NewValueFormula);
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
  
  
  
  
  
  int FindStatementOnSameLevel (String[] StatementToFind, int StartingLineNumber, int Increment, LooFStatement[] AllStatements, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    int BlockLevel = 0;
    int StartIndex = StartingLineNumber + Increment;
    int EndIndex = (Increment > 0) ? AllStatements.length : -1;
    for (int i = StartIndex; i != EndIndex; i += Increment) {
      if (BlockLevel < 0) throw (new LooFCompilerException (CodeData, AllCodeDatas, StartingLineNumber, "could not find a matching statement of type {" + CombineStringsWithSeperator (StatementToFind, ", ") + "} (block ended with wrong statement type)."));
      LooFStatement CurrentStatement = AllStatements[i];
      if (CurrentStatement.StatementType != StatementType_Function) continue;
      
      if (BlockLevel == 0 && TableContainsItem (StatementToFind, CurrentStatement.Name)) {
        return i;
      }
      
      LooFInterpreterFunction StatementFunction = CurrentStatement.Function;
      BlockLevel += StatementFunction.GetBlockLevelChange();
      
    }
    throw (new LooFCompilerException (CodeData, AllCodeDatas, StartingLineNumber, "could not find a matching statement of type {" + CombineStringsWithSeperator (StatementToFind, ", ") + "} (statement completely missing)."));
  }
  
  
  
  
  
  
  
  
  
  
  void FinishStatements (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, LooFAddonsData AddonsData, ArrayList <LooFCompilerException> AllExceptions) {
    LooFStatement[] Statements = CodeData.Statements;
    for (int i = 0; i < Statements.length; i ++) {
      try {
        LooFStatement CurrentStatement = Statements[i];
        FinishSingleStatement (CurrentStatement, AddonsData, CodeData, AllCodeDatas, i);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void FinishSingleStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    if (CurrentStatement.StatementType == StatementType_Assignment) {
      PreEvaluateStatementIndexQueries (CurrentStatement, CodeData, AllCodeDatas, LineNumber);
      if (CurrentStatement.NewValueFormula == null) return;
      CurrentStatement.NewValueFormula = PreEvaluateFormula (CurrentStatement.NewValueFormula, CodeData, AllCodeDatas, LineNumber);
      return;
    }
    
    PreEvaluateStatementArgs (CurrentStatement, CodeData, AllCodeDatas, LineNumber);
    CurrentStatement.Function.FinishStatement (CurrentStatement, AddonsData, CodeData, AllCodeDatas, LineNumber);
    
  }
  
  
  
  
  
  void PreEvaluateStatementIndexQueries (LooFStatement Statement, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFTokenBranch[] IndexQueries = Statement.IndexQueries;
    for (int i = 0; i < IndexQueries.length; i ++) {
      IndexQueries[i] = PreEvaluateFormula (IndexQueries[i], CodeData, AllCodeDatas, LineNumber);
    }
  }
  
  
  
  void PreEvaluateStatementArgs (LooFStatement CurrentStatement, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFTokenBranch[] Args = CurrentStatement.Args;
    for (int i = 0; i < Args.length; i ++) {
      Args[i] = PreEvaluateFormula (Args[i], CodeData, AllCodeDatas, LineNumber);
    }
  }
  
  
  
  
  
  LooFTokenBranch PreEvaluateFormula (LooFTokenBranch Formula, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    CodeData.CurrentLineNumber = LineNumber;
    
    if (Formula.CanBePreEvaluated) {
      LooFDataValue Result = LooFInterpreter.EvaluateFormula (Formula, null, CodeData, AllCodeDatas);
      return new LooFTokenBranch (Formula.OriginalTokenIndex, Formula.OriginalString, Result);
    }
    
    LooFTokenBranch[] Children = Formula.Children;
    for (int i = 0; i < Children.length; i ++) {
      LooFTokenBranch CurrentChild = Children[i];
      if (CurrentChild.TokenType == TokenBranchType_Formula) Children[i] = PreEvaluateFormula (CurrentChild, CodeData, AllCodeDatas, LineNumber);
    }
    return Formula;
    
  }
  
  
  
  
  
  
  
  
  
  
  Long GetLongFromStatementArg (LooFTokenBranch InputArg, int ArgNumber, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (InputArg.TokenType != TokenBranchType_PreEvaluatedFormula) return null;
    LooFDataValue InputArgValue = InputArg.Result;
    if (InputArgValue.ValueType != DataValueType_Int) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "arg number " + ArgNumber + " was expected to be an int, but the value given was of type " + TokenBranchTypeNames[InputArgValue.ValueType] + "."));
    return InputArgValue.IntValue;
  }
  
  
  
  String GetStringFromStatementArg (LooFTokenBranch InputArg, int ArgNumber, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (InputArg.TokenType != TokenBranchType_PreEvaluatedFormula) return null;
    LooFDataValue InputArgValue = InputArg.Result;
    if (InputArgValue.ValueType != DataValueType_String) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "arg number " + ArgNumber + " was expected to be an string, but the value given was of type " + TokenBranchTypeNames[InputArgValue.ValueType] + "."));
    return InputArgValue.StringValue;
  }
  
  
  
  
  
  String[] GetStringArrayFromStatementArg (LooFTokenBranch InputArg, int ArgNumber, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (InputArg.TokenType != TokenBranchType_PreEvaluatedFormula) return null;
    LooFDataValue InputArgValue = InputArg.Result;
    if (InputArgValue.ValueType != DataValueType_Table) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "arg number " + ArgNumber + " was expected to be a table, but the value given was of type " + TokenBranchTypeNames[InputArgValue.ValueType] + "."));
    ArrayList <LooFDataValue> InputArgsAsValues = InputArgValue.ArrayValue;
    String[] StringArrayOut = new String [InputArgsAsValues.size()];
    for (int i = 0; i < StringArrayOut.length; i ++) {
      LooFDataValue CurrentStringAsValue = InputArgsAsValues.get(i);
      if (CurrentStringAsValue.ValueType != DataValueType_String) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "arg number " + ArgNumber + " was expected to be a table of strings, but the table given contained a value of type " + TokenBranchTypeNames[CurrentStringAsValue.ValueType] + "."));
      String CurrentString = CurrentStringAsValue.StringValue;
      StringArrayOut[i] = CurrentString;
    }
    return StringArrayOut;
  }
  
  
  
  
  
  
  
  
  
  
  void PrintPreProcessorOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
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
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
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
      HashMap <String, Integer> FunctionLocations = CodeData.FunctionLineNumbers;
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
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
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
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
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
  
  
  
  
  
  
  
  
  
  
  void PrintFinalOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
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
