LooFCompiler LooFCompiler = new LooFCompiler();

class LooFCompiler {
  
  
  
  
  
  
  
  
  
  
  LooFEnvironment CompileEnvironmentFromFolder (File CodeFolder, LooFCompileSettings CompileSettings) {
    
    if (CodeFolder == null) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument (File argument is null)."));
    if (!CodeFolder.exists()) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument (File does not exist)."));
    if (!CodeFolder.isDirectory()) throw (new LooFCompilerException ("AddNewEnvironment must take a folder as its argument. (File is not a folder)."));
    if (CompileSettings == null) throw (new LooFCompilerException ("AddNewEnvironment cannot take a null LoofCompileSettings object. Either pass a new LooFCompileSettings object or call AddNewEvironment with no LooFCompileSettings argument."));
    
    String CodeFolderPath;
    try {
      CodeFolderPath = CodeFolder.getCanonicalPath();
    } catch (IOException e) {
      throw (new LooFCompilerException ("IOException while determining the code folder's path: " + e.getMessage()));
    }
    
    long StartMillis = System.currentTimeMillis();
    
    ClearCompilerOutputs (CompileSettings);
    
    
    
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
    
    if (CompileSettings.PrintPreProcessedLooF) {
      PrintPreProcessorOutput (AllCodeDatas, CompileSettings.PreProcessorOutputPath, "PreProcessedLOOF");
    }
    
    
    
    // link CodeData-s
    LinkAllCodeDatas (AllCodeDatas, AllExceptions);
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.PrintLinkedLooF) {
      PrintLinkerOutput (AllCodeDatas, CompileSettings.LinkerOutputPath, "LinkedLOOF");
    }
    
    
    
    // lex CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      LexCodeData (CodeData, AllCodeDatas, CombinedTokens, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.PrintLexedLooF) {
      PrintLexerOutput (AllCodeDatas, CompileSettings.LexerOutputPath, "LexedLOOF");
    }
    
    
    
    // parse CodeData-s
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      ParseCodeData (CodeData, AllCodeDatas, AddonsData, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.PrintParsedLooF) {
      PrintParserOutput (AllCodeDatas, CompileSettings.ParserOutputPath, "ParsedLOOF");
    }
    
    
    
    // finish statements
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      FinishStatements (CodeData, AllCodeDatas, AddonsData, AllExceptions);
    }
    
    if (AllExceptions.size() > 0) {
      throw (new LooFCompilerException (AllExceptions));
    }
    
    if (CompileSettings.PrintFinalLooF) {
      PrintFinalOutput (AllCodeDatas, CompileSettings.FinalOutputPath, "FinalLOOF");
    }
    
    
    
    // Remove excess data
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      RemoveExcessData (CodeData);
    }
    
    
    
    // create environement
    
    HashMap <LooFInterpreterModule, LooFModuleData> ModuleDatas = new HashMap <LooFInterpreterModule, LooFModuleData> ();
    HashMap <String, LooFInterpreterModule> InterpreterModules = AddonsData.InterpreterModules;
    Set <String> InterpreterModuleNames = InterpreterModules.keySet();
    for (String CurrentModuleName : InterpreterModuleNames) {
      LooFInterpreterModule CurrentModule = InterpreterModules.get(CurrentModuleName);
      ModuleDatas.put(CurrentModule, CurrentModule.CreateModuleData());
    }
    
    LooFEnvironment NewEnvironment = new LooFEnvironment (CodeFolderPath, AllCodeDatas, AddonsData, ModuleDatas);
    
    
    
    long EndMillis = System.currentTimeMillis();
    
    System.out.println ("Compiled environment from folder " + CodeFolder + ".");
    System.out.println ("Total compile time: " + (EndMillis - StartMillis) + " ms.");
    
    
    
    return NewEnvironment;
    
  }
  
  
  
  
  
  
  
  
  
  
  void ClearCompilerOutputs (LooFCompileSettings CompileSettings) {
    if (CompileSettings.PreProcessorOutputPath != null) DeleteAllFilesOfType (CompileSettings.PreProcessorOutputPath, "PreProcessedLOOF");
    if (CompileSettings.LinkerOutputPath       != null) DeleteAllFilesOfType (CompileSettings.LinkerOutputPath      , "LinkedLOOF"      );
    if (CompileSettings.LexerOutputPath        != null) DeleteAllFilesOfType (CompileSettings.LexerOutputPath       , "LexedLOOF"       );
    if (CompileSettings.ParserOutputPath       != null) DeleteAllFilesOfType (CompileSettings.ParserOutputPath      , "ParsedLOOF"      );
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
    HashMap <String, LooFInterpreterModule> InterpreterModules = CompileSettings.CustomModules;
    if (!CompileSettings.AddDefaultInterpreterModules) return InterpreterModules;
    
    InterpreterModules.putIfAbsent("Interpreter", InterpreterModule_Interpreter);
    InterpreterModules.putIfAbsent("Console", InterpreterModule_Console);
    InterpreterModules.putIfAbsent("Files", InterpreterModule_Files);
    //InterpreterModules.putIfAbsent("Graphics", NullInterpreterModule);
    
    return InterpreterModules;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterAssignment> GetInterpreterAssignmentsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterAssignment> InterpreterAssignments = CompileSettings.CustomInterprererAssignments;
    if (!CompileSettings.AddDefaultInterpreterAssignments) return InterpreterAssignments;
    
    InterpreterAssignments.putIfAbsent("=", Assignment_Equals);
    InterpreterAssignments.putIfAbsent("+=", Assignment_PlusEquals);
    InterpreterAssignments.putIfAbsent("-=", Assignment_MinusEquals);
    InterpreterAssignments.putIfAbsent("*=", Assignment_TimesEquals);
    InterpreterAssignments.putIfAbsent("/=", Assignment_DivideEquals);
    InterpreterAssignments.putIfAbsent("^=", Assignment_PowerEquals);
    InterpreterAssignments.putIfAbsent("%=", Assignment_ModuloEquals);
    InterpreterAssignments.putIfAbsent("..=", Assignment_ConcatEquals);
    InterpreterAssignments.putIfAbsent("<defaultsTo", Assignment_SetDefaultsTo);
    InterpreterAssignments.putIfAbsent("<add", Assignment_SetAdd);
    InterpreterAssignments.putIfAbsent("<addAtIndex", Assignment_SetAddAtIndex);
    InterpreterAssignments.putIfAbsent("<addAll", Assignment_SetAddAll);
    InterpreterAssignments.putIfAbsent("<removeIndex", Assignment_SetRemoveIndex);
    
    InterpreterAssignments.putIfAbsent("++", Assignment_PlusPlus);
    InterpreterAssignments.putIfAbsent("--", Assignment_MinusMinus);
    InterpreterAssignments.putIfAbsent("!!", Assignment_NotNot);
    InterpreterAssignments.putIfAbsent("<clone", Assignment_GetClone);
    
    return InterpreterAssignments;
  }
  
  
  
  
  
  HashMap <String, LooFInterpreterFunction> GetInterpreterFunctionsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFInterpreterFunction> InterpreterFunctions = CompileSettings.CustomInterpreterFunctions;
    if (!CompileSettings.AddDefaultInterpreterTweakAssignments) return InterpreterFunctions;
    
    InterpreterFunctions.putIfAbsent("push", InterpreterFunction_Push);
    InterpreterFunctions.putIfAbsent("pop", InterpreterFunction_Pop);
    
    InterpreterFunctions.putIfAbsent("call", InterpreterFunction_Call);
    InterpreterFunctions.putIfAbsent("return", InterpreterFunction_Return);
    InterpreterFunctions.putIfAbsent("returnRaw", InterpreterFunction_ReturnRaw);
    InterpreterFunctions.putIfAbsent("returnIf", InterpreterFunction_ReturnIf);
    InterpreterFunctions.putIfAbsent("returnRawIf", InterpreterFunction_ReturnRawIf);
    
    InterpreterFunctions.putIfAbsent("if", InterpreterFunction_If);
    InterpreterFunctions.putIfAbsent("skip", InterpreterFunction_Skip);
    InterpreterFunctions.putIfAbsent("end", InterpreterFunction_End);
    
    InterpreterFunctions.putIfAbsent("loop", InterpreterFunction_Loop);
    InterpreterFunctions.putIfAbsent("forEach", InterpreterFunction_ForEach);
    InterpreterFunctions.putIfAbsent("while", InterpreterFunction_While);
    InterpreterFunctions.putIfAbsent("repeat", InterpreterFunction_Repeat);
    InterpreterFunctions.putIfAbsent("repeatIf", InterpreterFunction_RepeatIf);
    InterpreterFunctions.putIfAbsent("continue", InterpreterFunction_Continue);
    InterpreterFunctions.putIfAbsent("continueIf", InterpreterFunction_ContinueIf);
    InterpreterFunctions.putIfAbsent("break", InterpreterFunction_Break);
    InterpreterFunctions.putIfAbsent("breakIf", InterpreterFunction_BreakIf);
    
    InterpreterFunctions.putIfAbsent("error", InterpreterFunction_Error);
    InterpreterFunctions.putIfAbsent("errorIf", InterpreterFunction_ErrorIf);
    InterpreterFunctions.putIfAbsent("setPassedErrors", InterpreterFunction_SetPassedErrors);
    InterpreterFunctions.putIfAbsent("try", InterpreterFunction_Try);
    
    InterpreterFunctions.putIfAbsent("callOutside", InterpreterFunction_CallOutside);
    InterpreterFunctions.putIfAbsent("TODO:", InterpreterFunction_TODO);
    
    return InterpreterFunctions;
  }
  
  
  
  
  
  HashMap <String, LooFEvaluatorOperation> GetEvaluatorOperationsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFEvaluatorOperation> EvaluatorOperations = CompileSettings.CustomEvaluatorOperations;
    if (!CompileSettings.AddDefaultEvaluatorOperations) return EvaluatorOperations;
    
    EvaluatorOperations.putIfAbsent("+", Operation_Add);
    EvaluatorOperations.putIfAbsent("-", Operation_Subtract);
    EvaluatorOperations.putIfAbsent("*", Operation_Multiply);
    EvaluatorOperations.putIfAbsent("/", Operation_Divide);
    EvaluatorOperations.putIfAbsent("^", Operation_Power);
    EvaluatorOperations.putIfAbsent("%", Operation_Modulo);
    EvaluatorOperations.putIfAbsent("..", Operation_Concat);
    EvaluatorOperations.putIfAbsent("==", Operation_Equals);
    EvaluatorOperations.putIfAbsent("===", Operation_StrictEquals);
    EvaluatorOperations.putIfAbsent(">", Operation_GreaterThan);
    EvaluatorOperations.putIfAbsent("<", Operation_LessThan);
    EvaluatorOperations.putIfAbsent("!=", Operation_NotEquals);
    EvaluatorOperations.putIfAbsent("!==", Operation_StrictNotEquals);
    EvaluatorOperations.putIfAbsent(">=", Operation_GreaterThanOrEqual);
    EvaluatorOperations.putIfAbsent("<=", Operation_LessThanOrEqual);
    EvaluatorOperations.putIfAbsent("and", Operation_And);
    EvaluatorOperations.putIfAbsent("or", Operation_Or);
    EvaluatorOperations.putIfAbsent("orDefault", Operation_OrDefault);
    EvaluatorOperations.putIfAbsent("xor", Operation_Xor);
    EvaluatorOperations.putIfAbsent("&&", Operation_BitwiseAnd);
    EvaluatorOperations.putIfAbsent("||", Operation_BitwiseOr);
    EvaluatorOperations.putIfAbsent("^^", Operation_BitwiseXor);
    EvaluatorOperations.putIfAbsent("<<", Operation_ShiftRight);
    EvaluatorOperations.putIfAbsent(">>", Operation_ShiftLeft);
    
    return EvaluatorOperations;
  }
  
  
  
  
  
  HashMap <String, LooFEvaluatorFunction> GetEvaluatorFunctionsForEnvironment (LooFCompileSettings CompileSettings) {
    HashMap <String, LooFEvaluatorFunction> EvaluatorFunctions = CompileSettings.CustomEvaluatorFunctions;
    if (!CompileSettings.AddDefaultEvaluatorFunctions) return EvaluatorFunctions;
    
    EvaluatorFunctions.putIfAbsent("round", Function_Round);
    EvaluatorFunctions.putIfAbsent("floor", Function_Floor);
    EvaluatorFunctions.putIfAbsent("ceil", Function_Ceil);
    EvaluatorFunctions.putIfAbsent("abs", Function_Abs);
    EvaluatorFunctions.putIfAbsent("sqrt", Function_Sqrt);
    EvaluatorFunctions.putIfAbsent("sign", Function_Sign);
    EvaluatorFunctions.putIfAbsent("min", Function_Min);
    EvaluatorFunctions.putIfAbsent("max", Function_Max);
    EvaluatorFunctions.putIfAbsent("clamp", Function_Clamp);
    EvaluatorFunctions.putIfAbsent("log", Function_Log);
    EvaluatorFunctions.putIfAbsent("log10", Function_Log10);
    EvaluatorFunctions.putIfAbsent("ln", Function_Ln);
    EvaluatorFunctions.putIfAbsent("toDregees", Function_ToDegrees);
    EvaluatorFunctions.putIfAbsent("toRadians", Function_ToRadians);
    
    EvaluatorFunctions.putIfAbsent("not", Function_Not);
    EvaluatorFunctions.putIfAbsent("!!", Function_BitwiseNot);
    EvaluatorFunctions.putIfAbsent("isNaN", Function_IsNaN);
    EvaluatorFunctions.putIfAbsent("isInfinity", Function_IsInfinity);
    
    EvaluatorFunctions.putIfAbsent("sin", Function_Sin);
    EvaluatorFunctions.putIfAbsent("cos", Function_Cos);
    EvaluatorFunctions.putIfAbsent("tan", Function_Tan);
    EvaluatorFunctions.putIfAbsent("asin", Function_ASin);
    EvaluatorFunctions.putIfAbsent("acos", Function_ACos);
    EvaluatorFunctions.putIfAbsent("atan", Function_ATan);
    EvaluatorFunctions.putIfAbsent("atan2", Function_ATan2);
    EvaluatorFunctions.putIfAbsent("sinh", Function_SinH);
    EvaluatorFunctions.putIfAbsent("cosh", Function_CosH);
    EvaluatorFunctions.putIfAbsent("tanh", Function_TanH);
    
    EvaluatorFunctions.putIfAbsent("random", Function_Random);
    EvaluatorFunctions.putIfAbsent("randomInt", Function_RandomInt);
    EvaluatorFunctions.putIfAbsent("chance", Function_Chance);
    
    EvaluatorFunctions.putIfAbsent("lengthOf", Function_LengthOf);
    //EvaluatorFunctions.putIfAbsent("isEmpty", NullEvaluatorFunction);
    EvaluatorFunctions.putIfAbsent("totalLengthOf", Function_TotalLengthOf);
    //EvaluatorFunctions.putIfAbsent("lengthOfHashMap", NullEvaluatorFunction);
    EvaluatorFunctions.putIfAbsent("endOf", Function_EndOf);
    EvaluatorFunctions.putIfAbsent("lastItemOf", Function_LastItemOf);
    EvaluatorFunctions.putIfAbsent("keysOf", Function_KeysOf);
    EvaluatorFunctions.putIfAbsent("valuesOf", Function_ValuesOf);
    EvaluatorFunctions.putIfAbsent("randomArrayItem", Function_RandomArrayItem);
    EvaluatorFunctions.putIfAbsent("randomHashmapItem", Function_RandomHashmapItem);
    EvaluatorFunctions.putIfAbsent("randomByteArrayItem", Function_RandomHashmapItem);
    EvaluatorFunctions.putIfAbsent("firstIndexOfItem", Function_FirstIndexOfItem);
    EvaluatorFunctions.putIfAbsent("lastIndexOfItem", Function_LastIndexOfItem);
    //EvaluatorFunctions.putIfAbsent("allIndexesOfItem", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("tableContainsItem", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("arrayContainsItem", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("hashmapContainsItem", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("byteArrayContainsItems", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("removeDuplicateItems", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("deepCloneTable", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("createFilledTable", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("createFilledByteArray", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("getSubArray", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("replaceSubArray", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("splitArray", NullEvaluatorFunction);
    
    EvaluatorFunctions.putIfAbsent("getChar", Function_GetChar);
    EvaluatorFunctions.putIfAbsent("getCharInts", Function_GetCharInts);
    EvaluatorFunctions.putIfAbsent("getCharByes", Function_GetCharBytes);
    EvaluatorFunctions.putIfAbsent("getSubString", Function_GetSubString);
    //EvaluatorFunctions.putIfAbsent("replaceSubString", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("replaceStrings", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("firstIndexOfString", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("lastIndexOfString", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("allIndexesOfString", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("splitString", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("stringStartsWith", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("stringEndsWith", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("toLowerCase", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("toUpperCase", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("trimString", NullEvaluatorFunction);
    
    EvaluatorFunctions.putIfAbsent("toInt", Function_ToInt);
    EvaluatorFunctions.putIfAbsent("toFloat", Function_ToFloat);
    EvaluatorFunctions.putIfAbsent("toString", Function_ToString);
    EvaluatorFunctions.putIfAbsent("toBool", Function_ToBool);
    
    EvaluatorFunctions.putIfAbsent("newFunction", Function_NewFunction);
    //EvaluatorFunctions.putIfAbsent("getFunctionLine", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("getFunctionFile", NullEvaluatorFunction);
    
    EvaluatorFunctions.putIfAbsent("typeOf", Function_TypeOf);
    //EvaluatorFunctions.putIfAbsent("isNumber", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("isLocked", NullEvaluatorFunction);
    EvaluatorFunctions.putIfAbsent("cloneValue", Function_CloneValue);
    //EvaluatorFunctions.putIfAbsent("serialize", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("deserialize", NullEvaluatorFunction);
    //EvaluatorFunctions.putIfAbsent("newByteArray", NullEvaluatorFunction);
    EvaluatorFunctions.putIfAbsent("timeSince", Function_TimeSince);
    //EvaluatorFunctions.putIfAbsent("switch", NullEvaluatorFunction);
    
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
    return ListToArray (CombinedTokens, String.class);
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
    
    AllFiles = ListToArray (AllFilesRaw, File.class);
    
    
    
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
    HashMap <String, boolean[]> CharsInQuotesCache = new HashMap <String, boolean[]> ();
    
    InsertHeader (CodeData, HeaderFileContents);
    AddPaddingLines (CodeData);
    RemoveComments (CodeData, CharsInQuotesCache, AllCodeDatas, AllExceptions);
    RemoveInitialTrim (CodeData);
    ProcessIfStatements (CodeData, AllCodeDatas, AllExceptions);
    ProcessIncludes (CodeData, AllCodeDatas, CharsInQuotesCache, AllExceptions);
    ProcessReplaces (CodeData, CharsInQuotesCache, AllCodeDatas, AllExceptions);
    RemoveExcessWhitespace (CodeData);
    CheckForIncorrectPreProcessorStatements (CodeData, AllCodeDatas, AllExceptions);
    
  }
  
  
  
  
  
  
  
  
  
  
  void InsertHeader (LooFCodeData CodeData, String[] HeaderFileContents) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    // process #ignore_header
    CodeData.IncludesHeader = !Code.get(0).equals("#ignore_header");
    if (!CodeData.IncludesHeader) {
      Code.remove(0);
      LineNumbers.remove(0);
      LineFileOrigins.remove(0);
      return;
    }
    
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
  
  
  
  
  
  
  
  
  
  
  void RemoveComments (LooFCodeData CodeData, HashMap <String, boolean[]> CharsInQuotesCache, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        RemoveLineEndComments (Code, i, CharsInQuotesCache);
        RemoveBlockComments (CodeData, i, CharsInQuotesCache, AllCodeDatas);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void RemoveLineEndComments (ArrayList <String> Code, int LineNumber, HashMap <String, boolean[]> CharsInQuotesCache) {
    String CurrentLine = Code.get(LineNumber);
    boolean[] CharsInQuotes = CharsInQuotesCache.getOrDefault (CurrentLine, null);
    if (CharsInQuotes == null) {
      CharsInQuotes = GetCharsInQuotes (CurrentLine);
      CharsInQuotesCache.put(CurrentLine, CharsInQuotes);
    }
    
    // find index of comment
    int PossibleCommentIndex = CurrentLine.indexOf("//");
    while (PossibleCommentIndex != -1 && CharsInQuotes[PossibleCommentIndex]) {
      PossibleCommentIndex = CurrentLine.indexOf("//");
    }
    int FoundCommentIndex = PossibleCommentIndex;
    
    // return if no comment found
    if (FoundCommentIndex == -1) return;
    
    // remove comment
    Code.set(LineNumber, CurrentLine.substring(0, FoundCommentIndex));
    
  }
  
  
  
  
  
  void RemoveBlockComments (LooFCodeData CodeData, int LineNumber, HashMap <String, boolean[]> CharsInQuotesCache, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    String CurrentLine = Code.get(LineNumber);
    
    boolean[] CharsInQuotes = CharsInQuotesCache.getOrDefault (CurrentLine, null);
    if (CharsInQuotes == null) {
      CharsInQuotes = GetCharsInQuotes (CurrentLine);
      CharsInQuotesCache.put(CurrentLine, CharsInQuotes);
    }
    
    // find index of comment
    int PossibleCommentIndex = CurrentLine.indexOf("/*");
    while (PossibleCommentIndex != -1 && CharsInQuotes[PossibleCommentIndex]) {
      PossibleCommentIndex = CurrentLine.indexOf("/*");
    }
    int CommentStart = PossibleCommentIndex;
    
    // return if no comment found
    if (CommentStart == -1) return;
    
    // find index of commend end
    Tuple2 <Integer, Integer> CommentEnd = FindBlockCommentEnd (Code, LineNumber, CommentStart, CodeData, AllCodeDatas);
    
    // remove middle
    for (int i = LineNumber + 1; i < CommentEnd.Value1; i ++) {
      Code.remove(LineNumber);
      LineNumbers.remove(LineNumber);
      LineFileOrigins.remove(LineNumber);
    }
    
    // remove from start and end
    Code.set(LineNumber, CurrentLine.substring(0, CommentStart) + Code.get(LineNumber + 1).substring(CommentEnd.Value2));
    Code.remove(LineNumber + 1);
    LineNumbers.remove(LineNumber + 1);
    LineFileOrigins.remove(LineNumber + 1);
    
  }
  
  
  
  Tuple2 <Integer, Integer> FindBlockCommentEnd (ArrayList <String> Code, int LineNumber, int CommentStart, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // if comment ends on the same line (there could be a "*/" before the "/*", and this deals with that)
    int PossibleCommentEndIndex = Code.get(LineNumber).indexOf("*/", CommentStart + 2);
    if (PossibleCommentEndIndex != -1) return new Tuple2 <Integer, Integer> (LineNumber, PossibleCommentEndIndex + 2);
    
    for (int i = LineNumber + 1; i < Code.size(); i ++) {
      PossibleCommentEndIndex = Code.get(i).indexOf("*/");
      if (PossibleCommentEndIndex != -1) return new Tuple2 <Integer, Integer> (i, PossibleCommentEndIndex + 2);
    }
    
    throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find the end of the block comment."));
    
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveInitialTrim (LooFCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = CurrentLine.trim();
      if (!NewLine.equals(CurrentLine)) Code.set (i, NewLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessReplaces (LooFCodeData CodeData, HashMap <String, boolean[]> CharsInQuotesCache, HashMap <String, LooFCodeData> AllCodeDatas, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        String CurrentLine = Code.get(i);
        if (!CurrentLine.startsWith("#replace")) continue;
        ProcessReplaceForLine (CurrentLine, CodeData, AllCodeDatas, CharsInQuotesCache, i);
        i --;
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void ProcessReplaceForLine (String CurrentLine, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, HashMap <String, boolean[]> CharsInQuotesCache, int LineNumber) {
        
    if (CurrentLine.startsWith("#replace ")) {
      String[][] ReplacementData = GetReplacementData (CodeData, LineNumber, 10, false, AllCodeDatas, LineNumber);
      ReplaceAllStringOccurances (CodeData, ReplacementData[0][0], ReplacementData[1], CharsInQuotesCache, false);
      return;
    }
    
    if (CurrentLine.startsWith("#replaceIgnoreQuotes ")) {
      String[][] ReplacementData = GetReplacementData (CodeData, LineNumber, 22, false, AllCodeDatas, LineNumber);
      ReplaceAllStringOccurances (CodeData, ReplacementData[0][0], ReplacementData[1], CharsInQuotesCache, true);
      return;
    }
    
    if (CurrentLine.startsWith("#replaceMultiLine ")) {
      String[][] ReplacementData = GetReplacementData (CodeData, LineNumber, 19, true, AllCodeDatas, LineNumber);
      ReplaceAllStringOccurances_MultiLine (CodeData, ReplacementData[0], ReplacementData[1]);
      return;
    }
    
    throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "cannot understand this #replace statement."));
    
  }
  
  
  
  String[][] GetReplacementData (LooFCodeData CodeData, int i, int SearchStart, boolean AllowMultiLineDetect, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    
    String CurrentLine = Code.remove(i);
    LineNumbers.remove(i);
    LineFileOrigins.remove(i);
    
    String[] RawReplacementData = GetRawReplacementData (CurrentLine, SearchStart);
    
    String[] ReplaceBefore = FormatBackslashes (RawReplacementData[0]);
    String[] ReplaceAfter = FormatBackslashes (RawReplacementData[1]);
    
    if (!AllowMultiLineDetect && ReplaceBefore.length > 1) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "'#replaceIgnoreQuotes' cannot detect multi-line strings, either remove the '\\n' or use '#replaceMultiLine'."));
    
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
  
  
  
  
  
  void ReplaceAllStringOccurances (LooFCodeData CodeData, String ReplaceBefore, String[] ReplaceAfter, HashMap <String, boolean[]> CharsInQuotesCache, boolean IgnoreQuotes) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    int LinesToJumpPerReplace = ReplaceAfter.length - 1;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.startsWith("#replace")) continue;  // NOT "#replace "
      ArrayList <Integer> AllReplacementPositions = GetAllPositionsOfString (CurrentLine, CharsInQuotesCache, ReplaceBefore, IgnoreQuotes);
      ReplaceAllStringOccurancesInLine (CodeData, CurrentLine, i, AllReplacementPositions, ReplaceBefore, ReplaceAfter);
      int LinesToJump = LinesToJumpPerReplace * AllReplacementPositions.size();
      i += LinesToJump;
    }
  }
  
  
  
  ArrayList <Integer> GetAllPositionsOfString (String StringIn, HashMap <String, boolean[]> CharsInQuotesCache, String StringToFind, boolean IgnoreQuotes) {
    ArrayList <Integer> Output = new ArrayList <Integer> ();
    
    boolean[] CharsInQuotes = null;
    if (!IgnoreQuotes) {
      CharsInQuotes = CharsInQuotesCache.getOrDefault (StringIn, null);
      if (CharsInQuotes == null) {
        CharsInQuotes = GetCharsInQuotes (StringIn);
        CharsInQuotesCache.put(StringIn, CharsInQuotes);
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
        Code.add(i + k, NewLine[k].trim());
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
    
    for (int i = 1; i < ReplaceBefore.length - 1; i ++) {
      if (!Code.get(i + StartIndex).equals(ReplaceBefore[i])) return false;
    }
    
    return true;
    
  }
  
  
  
  void ReplaceMultiLineString (LooFCodeData CodeData, int LineNumber, String[] ReplaceBefore, String[] ReplaceAfter) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
    ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
    int CurrentLineNumber = LineNumbers.get(LineNumber);
    String CurrentLineFileOrigin = LineFileOrigins.get(LineNumber);
    if (ReplaceBefore[0].equals("") && ReplaceAfter[0].equals("")) CurrentLineNumber ++;
    
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
    Code.set(LineNumber, ReplacedAreaStart.trim());
    Code.set(AreaEndIndex, ReplacedAreaEnd.trim());
    
    for (int i = 1; i < ReplaceAfter.length - 1; i ++) {
      Code.add(i + LineNumber, ReplaceAfter[i]);
      LineNumbers.add(i + LineNumber, CurrentLineNumber);
      LineFileOrigins.add(i + LineNumber, CurrentLineFileOrigin);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessIncludes (LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, HashMap <String, boolean[]> CharsInQuotesCache, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      try {
        String CurrentLine = Code.get(i);
        if (!CurrentLine.startsWith("#include ")) continue;
        ProcessIncludesForLine (CodeData, CurrentLine, i, AllCodeDatas, CharsInQuotesCache, AllExceptions);
        i --; // for if the included file starts with an #include
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void ProcessIncludesForLine (LooFCodeData CodeData, String CurrentLine, int LineNumber, HashMap <String, LooFCodeData> AllCodeDatas, HashMap <String, boolean[]> CharsInQuotesCache, ArrayList <LooFCompilerException> AllExceptions) {
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
      LineNumbers.add(InsertionStartIndex + i, i);
      LineFileOrigins.add(InsertionStartIndex + i, FileToIncludeName);
    }
    
    // process new data
    AddPaddingLines (CodeData);
    RemoveComments (CodeData, CharsInQuotesCache, AllCodeDatas, AllExceptions);
    RemoveInitialTrim (CodeData);
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
      
      // remove leading and trailing whitespace
      CurrentLine = CurrentLine.trim();
      
      // remove if line is empty
      if (CurrentLine.length() == 0) {
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        continue;
      }
      
      Code.set(i, CurrentLine);
      
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
        
        String FunctionName = CurrentLine.substring(10).trim();
        if (!FunctionNameIsValid (FunctionName)) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "invalid funciton name."));
        if (FunctionLineNumbers.get(FunctionName) != null) throw (new LooFCompilerException (CodeData, AllCodeDatas, i, "function \"" + FunctionName + "\" already exists."));
        
        Code.remove(i);
        LineNumbers.remove(i);
        LineFileOrigins.remove(i);
        
        FunctionLineNumbers.put(FunctionName, i);
        
        i --;
      }
    }
  }
  
  
  
  boolean FunctionNameIsValid (String FunctionName) {
    char[] FunctionNameChars = FunctionName.toCharArray();
    for (int i = 0; i < FunctionNameChars.length; i ++) {
      char CurrChar = FunctionNameChars[i];
      if (CharIsWhitespace (CurrChar) || CharStartsNewToken (CurrChar)) return false;
    }
    return true;
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
      boolean SkipReplacement = CurrentFunctionCallStart > 0 && CurrentLine.charAt(CurrentFunctionCallStart - 1) == '\\';
      if (!SkipReplacement) CurrentLine = ReplaceSingleFunctionCall (CurrentLine, CurrentFunctionCallStart, CodeData, AllCodeDatas, LineNumber);
      CurrentFunctionCallStart = CurrentLine.indexOf('$', CurrentFunctionCallStart + 1);
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
  
  
  
  
  
  int GetEndQuoteIndex (String CurrentLine, int StartQuoteIndex, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    int EndQuoteIndex = CurrentLine.indexOf('"', StartQuoteIndex + 1);
    while (true) {
      if (EndQuoteIndex == -1) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find a matching end-quote for the quote at char " + StartQuoteIndex + "."));
      if (CurrentLine.charAt(EndQuoteIndex - 1) != '\\') return EndQuoteIndex;
      EndQuoteIndex = CurrentLine.indexOf('"', EndQuoteIndex + 1);
    }
  }
  
  
  
  
  
  
  
  
  
  
  void CombineTokensForCode (LooFCodeData CodeData, String[] CombinedTokens, ArrayList <LooFCompilerException> AllExceptions) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    for (int i = 0; i < CodeTokens.size(); i ++) {
      try {
        CombineTokensForLine (CodeData, CombinedTokens, i);
      } catch (LooFCompilerException e) {
        AllExceptions.add(e);
      }
    }
  }
  
  
  
  void CombineTokensForLine (LooFCodeData CodeData, String[] CombinedTokens, int LineNumber) {
    ArrayList <String> CurrentLineTokens = CodeData.CodeTokens.get(LineNumber);
    ArrayList <Boolean> CurrentLineTokensFollowedBySpaces = CodeData.TokensFollowedBySpaces.get(LineNumber);
    for (int i = 0; i < CurrentLineTokens.size(); i ++) {
      CombineTokensForLineAtPosition (CurrentLineTokens, CurrentLineTokensFollowedBySpaces, CombinedTokens, i);
    }
  }
  
  
  
  
  
  void CombineTokensForLineAtPosition (ArrayList <String> CurrentLineTokens, ArrayList <Boolean> TokensFollowedBySpaces, String[] CombinedTokens, int StartIndex) {
    
    // find any fitting combined token
    Tuple2 <String, Integer> FoundCombinedTokenData = GetCombinedTokenFromPosition (CurrentLineTokens, TokensFollowedBySpaces, CombinedTokens, StartIndex);
    if (FoundCombinedTokenData == null) return;
    String FoundCombinedToken = FoundCombinedTokenData.Value1;
    int FoundCombinedTokenEndIndex = FoundCombinedTokenData.Value2;
    
    // replace start token with combined token
    CurrentLineTokens.set(StartIndex, FoundCombinedToken);
    TokensFollowedBySpaces.set(StartIndex, TokensFollowedBySpaces.get(FoundCombinedTokenEndIndex));
    
    // remove tokens to combine
    for (int i = FoundCombinedTokenEndIndex; i > StartIndex; i --) {
      CurrentLineTokens.remove(i);
      TokensFollowedBySpaces.remove(i);
    }
    
  }
  
  
  
  
  
  Tuple2 <String, Integer> GetCombinedTokenFromPosition (ArrayList <String> CurrentLineTokens, ArrayList <Boolean> TokensFollowedBySpaces, String[] CombinedTokens, int StartIndex) {
    if (CombinedTokens.length == 0) return null;
    String PossibleCombinedToken = "";
    int ResultIndex = 0;
    int CurrentLineTokensSize = CurrentLineTokens.size();
    int CombinedTokensLength = CombinedTokens.length;
    
    Tuple2 <String, Integer> ReturnValue = null;
    
    for (int i = StartIndex; i < CurrentLineTokensSize; i ++) {
      if (i > StartIndex && TokensFollowedBySpaces.get(i - 1)) return ReturnValue;
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
    LooFInterpreterFunction FoundInterpreterFunction = InterpreterFunctions.getOrDefault(CurrentLineTokens.get(0), null);
    if (FoundInterpreterFunction != null) {
      return GetStatementFromLine_InterpreterFunction (CurrentLineTokens, FoundInterpreterFunction, BlockLevels, BlockEnds, AddonsData, CodeData, AllCodeDatas, LineNumber);
    }
    
    if (CurrentLineTokens.size() < 2) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not understand statement type. No interpreter function named \"" + CurrentLineTokens.get(0) + "\" exists, and statement is not long enough to be an assignment."));
    
    // get assignment token's string and index
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
    
    return ListToArray (IndexQueriesList, LooFTokenBranch.class);
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
    LooFTokenBranch[] FormulaChildren = ListToArray (FormulaChildrenList, LooFTokenBranch.class);
    EnsureFormulaTokensAreValid (FormulaChildren, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch ParsedFormula = new LooFTokenBranch (FormulaBlockStart - 1, "(", FormulaChildren);
    FillFormulaTokenEvaluationOrders (ParsedFormula);
    FillTokenBranchCanBePreEvaluated (ParsedFormula);
    return ParsedFormula;
  }
  
  
  
  LooFTokenBranch GetTokenBranchFromToken (String CurrentToken, ArrayList <String> CurrentLineTokens, int TokenIndex, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    
    switch (CurrentToken) {
      
      // constants
      case ("MATH_PI"): return new LooFTokenBranch (TokenIndex, CurrentToken, Math.PI);
      
      case ("MATH_E"): return new LooFTokenBranch (TokenIndex, CurrentToken, Math.E);
      
      case ("MATH_MAX_INT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Long.MAX_VALUE);
      
      case ("MATH_MIN_INT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Long.MIN_VALUE);
      
      case ("MATH_MAX_FLOAT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.MAX_VALUE);
      
      case ("MATH_MIN_FLOAT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.MIN_VALUE);
      
      case ("MATH_POSITIVE_INFINITY"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.POSITIVE_INFINITY);
      
      case ("MATH_NEGATIVE_INFINITY"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.NEGATIVE_INFINITY);
      
      case ("MATH_NAN_FLOAT"): return new LooFTokenBranch (TokenIndex, CurrentToken, Double.NaN);
      
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
      StringValue = FormatBackslashes_SingleStringReturn (StringValue);
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
    if (FormulaChildren.length == 0) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "empty formulas are not allowed."));
    
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
    FormulaToken.IndexQueryIndexes = ToPrimitive (ListToArray (IndexQueryIndexes, Integer.class));
    FormulaToken.FunctionIndexes = ToPrimitive (ListToArray (FunctionIndexes, Integer.class));
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
      ShiftOperationOrdersPastIndex (OperationIndexes, CurrentIndexQueryIndex, Integer.MAX_VALUE, -1);
    }
    
    for (int i = 0; i < FunctionIndexes.length; i ++) {
      int CurrentFunctionIndex = FunctionIndexes[i];
      ShiftOperationOrdersPastIndex (OperationIndexes, CurrentFunctionIndex, Integer.MAX_VALUE, -1);
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
    
    for (LooFTokenBranch CurrentToken : TokenBranch.Children) {
      if (
        !CurrentToken.CanBePreEvaluated ||
        CurrentToken.TokenType == TokenBranchType_VarName ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorOperation && !CurrentToken.Operation.CanBePreEvaluated()) ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorFunction && !CurrentToken.Function.CanBePreEvaluated())
      ) {
        TokenBranch.CanBePreEvaluated = false;
        return;
      }
    }
    
    if (TokenBranch.TokenType != TokenBranchType_Table) return;
    
    Set <String> KeySet = TokenBranch.HashMapChildren.keySet();
    for (String CurrentKey : KeySet) {
      LooFTokenBranch CurrentToken = TokenBranch.HashMapChildren.get(CurrentKey);
      if (
        !CurrentToken.CanBePreEvaluated ||
        CurrentToken.TokenType == TokenBranchType_VarName ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorOperation && !CurrentToken.Operation.CanBePreEvaluated()) ||
        (CurrentToken.TokenType == TokenBranchType_EvaluatorFunction && !CurrentToken.Function.CanBePreEvaluated())
      ) {
        TokenBranch.CanBePreEvaluated = false;
        return;
      }
    }
    
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
    
    LooFTokenBranch ParsedTable = new LooFTokenBranch (TableBlockStart - 1, "{", ListToArray (ArrayItems, LooFTokenBranch.class), HashMapItems);
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
    if (NumberOfArgs < MinNumberOfArgs || NumberOfArgs > MaxNumberOfArgs) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "this statement takes " + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "either " : "between ") + MinNumberOfArgs + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? " or " : " and ") + MaxNumberOfArgs + " arguments, but " + (NumberOfArgs < MinNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
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
    if (OutputArg.TokenType == TokenBranchType_PreEvaluatedFormula) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to."));
    LooFTokenBranch[] OutputArgChildren = OutputArg.Children;
    if (OutputArgChildren.length != 1) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to."));
    LooFTokenBranch OutputVarToken = OutputArgChildren[0];
    if (OutputVarToken.TokenType != TokenBranchType_VarName) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to, not a token of type " + TokenBranchTypeNames[OutputVarToken.TokenType] + "."));
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
      LooFStatement CurrentStatement = AllStatements[i];
      if (CurrentStatement.StatementType != StatementType_Function) continue;
      
      if (BlockLevel == 0 && ArrayContainsItem (StatementToFind, CurrentStatement.Name)) {
        return i;
      }
      
      LooFInterpreterFunction StatementFunction = CurrentStatement.Function;
      BlockLevel += StatementFunction.GetBlockLevelChange() * Math.signum(Increment);
      
      if (BlockLevel < 0) throw (new LooFCompilerException (CodeData, AllCodeDatas, StartingLineNumber, "could not find a matching statement of type {" + CombineStringsWithSeperator (StatementToFind, ", ") + "} (block ended with wrong statement type ('" + CurrentStatement.Name + "' at line " + CodeData.LineNumbers.get(i) + "))."));
      
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
    
    // if it can be evaluated, return evaluated result
    if (Formula.CanBePreEvaluated) {
      LooFDataValue Result = LooFInterpreter.EvaluateFormula (Formula, null, CodeData, AllCodeDatas);
      return new LooFTokenBranch (Formula.OriginalTokenIndex, Formula.OriginalString, Result);
    }
    
    // if it can't be evaluated, still try to evaluate children
    LooFTokenBranch[] Children = Formula.Children;
    for (int i = 0; i < Children.length; i ++) {
      if (Children[i].TokenType == TokenBranchType_Formula) Children[i] = PreEvaluateFormula (Children[i], CodeData, AllCodeDatas, LineNumber);
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
  
  
  
  Boolean GetBoolFromStatementArg (LooFTokenBranch InputArg, int ArgNumber, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    if (InputArg.TokenType != TokenBranchType_PreEvaluatedFormula) return null;
    LooFDataValue InputArgValue = InputArg.Result;
    if (InputArgValue.ValueType != DataValueType_Bool) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "arg number " + ArgNumber + " was expected to be a bool, but the value given was of type " + TokenBranchTypeNames[InputArgValue.ValueType] + "."));
    return InputArgValue.BoolValue;
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
  
  
  
  
  
  
  
  
  
  void RemoveExcessData (LooFCodeData CodeData) {
    CodeData.CodeTokens = null;
    CodeData.TokensFollowedBySpaces = null;
    CodeData.LinkedFiles = null;
  }
  
  
  
  
  
  
  
  
  
  
  void PrintPreProcessorOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    if (OutputPath == null) throw (new LooFCompilerException ("PrintPreProcessedLooF in CompileSettings is set to true but PreProcessorOutputPath is null."));
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      try {
        PrintWriter FileOutput = new PrintWriter (FileOutputName);
        
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
      } catch (java.io.FileNotFoundException e) {
        throw (new LooFCompilerException ("Error while printing the PreProcessor's output: " + e.toString()));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintLinkerOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    if (OutputPath == null) throw (new LooFCompilerException ("PrintLinkedLooF in CompileSettings is set to true but LinkerOutputPath is null."));
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      try {
        PrintWriter FileOutput = new PrintWriter (FileOutputName);
        
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
      } catch (java.io.FileNotFoundException e) {
        throw (new LooFCompilerException ("Error while printing the Linker's output: " + e.toString()));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintLexerOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    if (OutputPath == null) throw (new LooFCompilerException ("PrintLexedLooF in CompileSettings is set to true but LexerOutputPath is null."));
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      try {
        PrintWriter FileOutput = new PrintWriter (FileOutputName);
        
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
      } catch (java.io.FileNotFoundException e) {
        throw (new LooFCompilerException ("Error while printing the Lexer's output: " + e.toString()));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintParserOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    if (OutputPath == null) throw (new LooFCompilerException ("PrintParsedLooF in CompileSettings is set to true but ParserOutputPath is null."));
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      try {
        PrintWriter FileOutput = new PrintWriter (FileOutputName);
        
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
      } catch (java.io.FileNotFoundException e) {
        throw (new LooFCompilerException ("Error while printing the Parser's output: " + e.toString()));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void PrintFinalOutput (HashMap <String, LooFCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    if (OutputPath == null) throw (new LooFCompilerException ("PrintFinalLooF in CompileSettings is set to true but FinalOutputPath is null."));
    Collection <LooFCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.OriginalFileName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      try {
        PrintWriter FileOutput = new PrintWriter (FileOutputName);
        
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
      } catch (java.io.FileNotFoundException e) {
        throw (new LooFCompilerException ("Error while printing the Final output: " + e.toString()));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
}
