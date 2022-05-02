LooFCompiler LooFCompiler = new LooFCompiler();

class LooFCompiler {
  
  
  
  
  
  
  
  
  
  
  LooFEnvironment CompileEnvironmentFromFolder (File CodeFolder, LooFCompileSettings CompileSettings) {
    StartTimer ("Total");
    StartTimer ("OnlyCompilation");
    
    
    
    // MUST BE ORDERED SHORTEST TO LONGEST
    final String[] CombinedTokens = {
      "==",
      "!=",
      ">=",
      "<=",
      "..",
    };
    
    
    
    // start CodeData-s
    LooFLoadedFilesData LoadedFilesData = LoadFilesIntoNewCodeDatas (CodeFolder);
    HashMap <String, LooFFileCodeData> AllCodeDatas = LoadedFilesData.AllCodeDatas;
    String[] HeaderFileContents = LoadedFilesData.HeaderFileContents;
    
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    
    
    // pre-process CodeData-s
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
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
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      ParseCodeData (CodeData, CombinedTokens);
    }
    
    if (CompileSettings.ParserOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintParserOutput (AllCodeDatas, CompileSettings.ParserOutputPath, "ParsedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    // lex CodeData-s
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      LexCodeData (CodeData);
    }
    
    if (CompileSettings.LexerOutputPath != null) {
      StopTimer ("OnlyCompilation");
      PrintLexerOutput (AllCodeDatas, CompileSettings.LexerOutputPath, "LexedLOOF");
      StartTimer ("OnlyCompilation");
    }
    
    
    
    StopTimer ("OnlyCompilation");
    StopTimer ("Total");
    
    println ("Added environment from folder " + CodeFolder + ".");
    println ("Total time for only compiling: " + GetTimerMillis ("OnlyCompilation") + " ms.");
    println ("Total time: " + GetTimerMillis ("Total") + " ms.");
    
    
    
    return null;
    
  }
  
  
  
  
  
  
  
  
  
  
  LooFLoadedFilesData LoadFilesIntoNewCodeDatas (File CodeFolder) {
    
    
    
    // vars used
    HashMap <String, LooFFileCodeData> AllCodeDatas = new HashMap <String, LooFFileCodeData> ();
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
      AllCodeDatas.put(AllFullFileNames[i], new LooFFileCodeData (AllFileContents[i], AllFullFileNames[i]));
    }
    
    
    
    return new LooFLoadedFilesData (AllCodeDatas, HeaderFileContents);
    
    
    
  }
  
  
  
  
  
  
  
  
  
  
  void PreProcessCodeData (LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, String[] HeaderFileContents) {
    
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
  
  
  
  
  
  
  
  
  
  
  void InsertHeader (LooFFileCodeData CodeData, String[] HeaderFileContents) {
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
      LineFileOrigins.add(i, CodeData.FullName);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveInitialTrim (LooFFileCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      String NewLine = CurrentLine.trim();
      if (!NewLine.equals(CurrentLine)) Code.set (i, NewLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  void ProcessReplaces (LooFFileCodeData CodeData) {
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
  
  
  
  ReturnValue GetReplacementData (LooFFileCodeData CodeData, int i, int SearchStart) {
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
    for (int _ = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int FirstMiddleQuote = i;
    
    // find second (not in string) '"'
    i ++;
    for (int _ = 0; i < CurrentLineLength; i ++) {
      if (CurrentLine.charAt(i) == '"' && CurrentLine.charAt(i - 1) != '\\') break;
    }
    int SecondMiddleQuote = i;
    
    // get string parts based on quote locations
    String ReplaceBefore = CurrentLine.substring (SearchStart, FirstMiddleQuote);
    String ReplaceAfter  = CurrentLine.substring (SecondMiddleQuote + 1, CurrentLineLength - 1);
    
    return new String[] {ReplaceBefore, ReplaceAfter};
  }
  
  
  
  void ReplaceAllStringOccurancesInCode (LooFFileCodeData CodeData, String ReplaceBefore, String[] ReplaceAfter, boolean OnlyStart, boolean OnlyEnd) {
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
  
  
  
  void ReplaceAllStringOccurancesInLine (LooFFileCodeData CodeData, String CurrentLine, int i, ArrayList <Integer> AllReplacementPositions, String ReplaceBefore, String[] ReplaceAfter) {
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
  
  
  
  
  
  
  
  
  
  
  void ProcessIncludes (LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, int HeaderLength) {
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
        String FullFileName = GetFullFileNameFromPartialFileName (FileName, AllCodeDatas, CurrentLine, LineNumber, LineFileOrigin, CodeData.FullName);
        if (FullFileName == null) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullName, "could not include the file " + FileName + " because the file could not be found."));
        LooFFileCodeData FileToInclude = AllCodeDatas.get(FullFileName);
        
        // get code to include and data about it
        String[] FileToIncludeContents = FileToInclude.OriginalCode;
        String FileToIncludeName = FileToInclude.FullName;
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
  
  
  
  
  
  String GetFullFileNameFromPartialFileName (String PartialFileName, HashMap <String, LooFFileCodeData> AllCodeDatas, String CurrentLine, int LineNumber, String LineFileOrigin, String FileName) {
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
  
  
  
  
  
  
  
  
  
  
  void ProcessIfStatements (LooFFileCodeData CodeData) {
    ProcessIfStatements (CodeData, 0, CodeData.CodeArrayList.size());
  }
  
  
  
  void ProcessIfStatements (LooFFileCodeData CodeData, int StartIndex, int EndIndex) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = StartIndex; i < min (EndIndex, Code.size()); i ++) {
      String CurrentLine = Code.get(i).trim();
      if (!CurrentLine.startsWith("#if_")) continue;
      
      if (CurrentLine.startsWith("#if_equal ")) {
        String IfStatementData = CurrentLine.substring (10);
        boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, IfStatementData, i, "#if_equal", CodeData.FullName);
        if (!IfStatementResult) RemoveCodeUntilEndIf (CodeData, i);
        continue;
      }
      
      if (CurrentLine.startsWith("#if_not_equal ")) {
        String IfStatementData = CurrentLine.substring (14);
        boolean IfStatementResult = CheckIfIfStatementArgumentsMatch (CodeData, IfStatementData, i, "#if_not_equal", CodeData.FullName);
        if (IfStatementResult) RemoveCodeUntilEndIf (CodeData, i);
        continue;
      }
      
    }
  }
  
  
  
  boolean CheckIfIfStatementArgumentsMatch (LooFFileCodeData CodeData, String IfStatementData, int LineNumber, String PreProcessorStatementType, String FullFileName) {
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
  
  
  
  void RemoveCodeUntilEndIf (LooFFileCodeData CodeData, int StartIndex) {
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
    
    throw (new LooFCompileException (FirstLine, FirstLineNumber, FirstLineFileOrigin, CodeData.FullName, "could not find matching \"#end_if\" for \"#if_...\" preprocessor statement."));
  }
  
  
  
  
  
  
  
  
  
  
  void RemoveComments (LooFFileCodeData CodeData) {
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
  
  
  
  
  
  
  
  
  
  
  void RemoveExcessWhitespace (LooFFileCodeData CodeData) {
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
  
  
  
  
  
  
  
  
  
  
  void CheckForIncorrectPreProcessorStatements (LooFFileCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      if (Code.get(i).startsWith("#")) {
        //throw (new LooFCompileException (CodeData, i, "unknown pre-processor statement."));
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  void CombineSeperatedLists (LooFFileCodeData CodeData) {
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
  
  
  
  
  
  
  
  
  
  void LinkAllCodeDatas (HashMap <String, LooFFileCodeData> AllCodeDatas) {
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    
    // simplify linking statements
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      FindLinkedFiles (CodeData, AllCodeDatas);
      FindFunctionLocations (CodeData);
    }
    
    // replace function references
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      ReplaceFunctionCalls (CodeData, AllCodeDatas);
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void FindLinkedFiles (LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas) {
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
        if (LinkedFiles.containsKey(LinkShortenedName)) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullName, "the shortened link name \"" + LinkShortenedName + "\" is already in use for file \"" + LinkedFiles.get(LinkShortenedName) + "\"."));
        LinkedFiles.put(LinkShortenedName, LinkFileName);
        
        i --;
      }
    }
  }
  
  
  
  String[] GetLinkData (String CurrentLine, int LineNumber, String LineFileOrigin, LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas) {
    
    // get the name of the file being linked
    int FoundSeperatorIndex = CurrentLine.indexOf(" as ");
    int LinkedFileNameEnd = (FoundSeperatorIndex == -1) ? CurrentLine.length() : FoundSeperatorIndex;
    String LinkedFileName = CurrentLine.substring(6, LinkedFileNameEnd);
    String LinkedFileFullName = GetFullFileNameFromPartialFileName (LinkedFileName, AllCodeDatas, CurrentLine, LineNumber, LineFileOrigin, CodeData.FullName);
    if (LinkedFileFullName == null) throw (new LooFCompileException (CurrentLine, LineNumber, LineFileOrigin, CodeData.FullName, "could not link the file \"" + LinkedFileName + " because the file could not be found."));
    
    // return if done
    if (FoundSeperatorIndex == -1) return new String[] {RemoveFileExtention (LinkedFileFullName), LinkedFileFullName};
    
    // get the shortened file name
    String ShortenedName = CurrentLine.substring(FoundSeperatorIndex + 4);
    return new String[] {ShortenedName, LinkedFileFullName};
    
  }
  
  
  
  
  
  
  
  
  
  void FindFunctionLocations (LooFFileCodeData CodeData) {
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
  
  
  
  
  
  
  
  
  
  
  void ReplaceFunctionCalls (LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      if (CurrentLine.indexOf('$') == -1) continue;
      String NewLine = ReplaceFunctionCallsForLine (CurrentLine, CodeData, AllCodeDatas, i);
      Code.set(i, NewLine);
    }
  }
  
  
  
  
  
  String ReplaceFunctionCallsForLine (String CurrentLine, LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, int LineNumber) {
    int CurrentFunctionCallStart = CurrentLine.indexOf('$');
    while (CurrentFunctionCallStart != -1) {
      CurrentLine = ReplaceSingleFunctionCall (CurrentLine, CurrentFunctionCallStart, CodeData, AllCodeDatas, LineNumber);
      CurrentFunctionCallStart = CurrentLine.indexOf('$');
    }
    return CurrentLine;
  }
  
  
  
  
  
  String ReplaceSingleFunctionCall (String CurrentLine, int CurrentFunctionCallStart, LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, int LineNumber) {
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
  
  
  
  
  
  String GetLinkedFunctionCall (String FunctionCallData, LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, int LineNumber) {
    int LastPeriodIndex = FunctionCallData.lastIndexOf('.');
    if (LastPeriodIndex == -1) {
      return GetLinkedFunctionCall_WithinFile (FunctionCallData, CodeData, LineNumber);
    }
    return GetLinkedFunctionCall_OutsideFile (FunctionCallData, LastPeriodIndex, CodeData, AllCodeDatas, LineNumber);
  }
  
  
  
  String GetLinkedFunctionCall_WithinFile (String FunctionCallData, LooFFileCodeData CodeData, int LineNumber) {
    Integer FunctionLocation = CodeData.FunctionLocations.get(FunctionCallData);
    if (FunctionLocation == null) throw (new LooFCompileException (CodeData, LineNumber, "the function \"" + FunctionCallData + "\" is not defined or could not be found."));
    return FunctionLocation.toString();
  }
  
  
  
  String GetLinkedFunctionCall_OutsideFile (String FunctionCallData, int LastPeriodIndex, LooFFileCodeData CodeData, HashMap <String, LooFFileCodeData> AllCodeDatas, int LineNumber) {
    
    // get data from FunctionCallData
    String FunctionName = FunctionCallData.substring(LastPeriodIndex + 1);
    String ShortenedFileName = FunctionCallData.substring(0, LastPeriodIndex);
    
    // get full file name
    String FullFileName = CodeData.LinkedFiles.get(ShortenedFileName);
    if (FullFileName == null) throw (new LooFCompileException (CodeData, LineNumber, "no file was found linked as \"" + ShortenedFileName + "\"."));
    
    // get linked file
    LooFFileCodeData LinkedCodeData = AllCodeDatas.get(FullFileName);
    if (LinkedCodeData == null) throw (new RuntimeException ("INTERNAL ERROR: LooFCompiler.GetLinkedFunctionCall_OutsideFile found that the file linked as \"" + ShortenedFileName + "\" points to the non-existant file \"" + FullFileName + "\"."));
    
    // get location of function
    Integer FunctionLocation = LinkedCodeData.FunctionLocations.get(FunctionName);
    if (FunctionLocation == null) throw (new LooFCompileException (CodeData, LineNumber, "no function named \"" + FunctionName + "\" was found in the file \"" + FullFileName + "\"."));
    
    // assemble and return new function data
    return "\"" + FullFileName + "\", " + FunctionLocation;
  }
  
  
  
  
  
  
  
  
  
  
  void ParseCodeData (LooFFileCodeData CodeData, String[] CombinedTokens) {
    TokenizeCode (CodeData);
    CombineTokensForCode (CodeData, CombinedTokens);
  }
  
  
  
  
  
  
  
  
  
  
  void TokenizeCode (LooFFileCodeData CodeData) {
    ArrayList <String> Code = CodeData.CodeArrayList;
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    for (int i = 0; i < Code.size(); i ++) {
      String CurrentLine = Code.get(i);
      ArrayList <String> TokenizedLine = TokenizeLine (CurrentLine, CodeData, i);
      CodeTokens.add(TokenizedLine);
    }
  }
  
  
  
  
  
  
  
  
  
  
  ArrayList <String> TokenizeLine (String CurrentLine, LooFFileCodeData CodeData, int LineNumber) {
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
  
  
  
  
  
  int GetEndQuoteIndex (String CurrentLine, int i, LooFFileCodeData CodeData, int LineNumber) {
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
  
  
  
  
  
  
  
  
  
  
  void CombineTokensForCode (LooFFileCodeData CodeData, String[] CombinedTokens) {
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
    
    for (int i = StartIndex; i < CurrentLineTokensSize; i ++) {
      PossibleCombinedToken += CurrentLineTokens.get(i);
      
      // skip results that are too short
      while (CombinedTokens[ResultIndex].length() < PossibleCombinedToken.length()) {
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return null;
      }
    
      // add another token if the next results are too long
      if (CombinedTokens[ResultIndex].length() > PossibleCombinedToken.length()) continue;
      
      // test results
      while (PossibleCombinedToken.length() == CombinedTokens[ResultIndex].length()) {
        if (PossibleCombinedToken.equals(CombinedTokens[ResultIndex])) {
          ReturnValue Return = new ReturnValue();
          Return.StringValue = PossibleCombinedToken;
          Return.IntegerValue = i;
          return Return;
        }
        ResultIndex ++;
        if (ResultIndex == CombinedTokensLength) return null;
      }
      
    }
    
    return null;
    
  }
  
  
  
  
  
  
  
  
  
  
  void LexCodeData (LooFFileCodeData CodeData) {
    ArrayList <ArrayList <String>> CodeTokens = CodeData.CodeTokens;
    LooFTokenBranch[][] Statements = new LooFTokenBranch [CodeTokens.size()] [];
    for (int i = 0; i < Statements.length; i ++) {
      LooFTokenBranch[] Statement = GetLexedTokensForLine (CodeTokens.get(i), CodeData, i);
      EnsureStatementIsValid (Statement, CodeData, i);
      SimplifyStatement (Statement, CodeData, i);
      Statements[i] = Statement;
    }
    CodeData.Statements = Statements;
  }
  
  
  
  
  
  LooFTokenBranch[] GetLexedTokensForLine (ArrayList <String> CurrentLineTokens, LooFFileCodeData CodeData, int LineNumber) {
    
    // get basic data
    ReturnValue BlocksData = GetAllBlockLevelsAndEnds (CurrentLineTokens, CodeData, LineNumber);
    ArrayList <Integer> BlockLevels = BlocksData.IntegerArrayListValue;
    ArrayList <Integer> BlockEnds = BlocksData.SecondIntegerArrayListValue;
    
    // assignment statements
    int AssignmentTokenIndex = FindTokenIndex ("=", CurrentLineTokens, 0);
    if (AssignmentTokenIndex != -1) {
      return GetLexedTokensForLine_Assignment (CurrentLineTokens, BlockLevels, BlockEnds, AssignmentTokenIndex, CodeData, LineNumber);
    }
    
    // other statements
    return GetLexedTokensForLine_InterpreterCall (CurrentLineTokens, BlockLevels, BlockEnds, CodeData, LineNumber);
    
  }
  
  
  
  
  
  LooFTokenBranch[] GetLexedTokensForLine_Assignment (ArrayList <String> CurrentLineTokens, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, int AssignmentTokenIndex, LooFFileCodeData CodeData, int LineNumber) {
    
    // error if there are multiple "="-s
    if (FindTokenIndex ("=", CurrentLineTokens, AssignmentTokenIndex + 1) != -1) throw (new LooFCompileException (CodeData, LineNumber, "found two \"=\" tokens but only one can used per statement."));
    
    // handle "default " statements
    if (CurrentLineTokens.get(0).equals("default")) {
      CurrentLineTokens.set(AssignmentTokenIndex, ",");
      return GetLexedTokensForLine_InterpreterCall (CurrentLineTokens, BlockLevels, BlockEnds, CodeData, LineNumber);
    }
    
    // error if var name is invalid
    if (StringIsInterpreterCall (CurrentLineTokens.get(0))) throw (new LooFCompileException (CodeData, LineNumber, "unexpected token \"=\" / variables cannot be named \"" + CurrentLineTokens.get(0) +"\"."));
    
    
    // var name
    LooFTokenBranch TargetVarName = new LooFTokenBranch (TokenBranchType_OutputVar, CurrentLineTokens.get(0));
    
    
    // indexes
    int PossibleIndexIndex = 1;
    ArrayList <LooFTokenBranch> TargetVarIndexes = new ArrayList <LooFTokenBranch> ();
    while (PossibleIndexIndex < AssignmentTokenIndex) {
      if (!CurrentLineTokens.get(PossibleIndexIndex).equals("[")) throw (new LooFCompileException (CodeData, LineNumber, "unexpected token (\"" + CurrentLineTokens.get(PossibleIndexIndex) + "\"): must be an index (starting with \"[\") or an assignment (\"=\")."));
      int IndexEndIndex = BlockEnds.get(PossibleIndexIndex) - 1;
      LooFTokenBranch IndexFormula = GetLexedFormula (CurrentLineTokens, PossibleIndexIndex + 1, IndexEndIndex, BlockLevels, BlockEnds);
      IndexFormula.Type = TokenBranchType_Index;
      TargetVarIndexes.add(IndexFormula);
      PossibleIndexIndex = IndexEndIndex + 2;
    }
    if (PossibleIndexIndex != AssignmentTokenIndex) throw (new LooFCompileException (CodeData, LineNumber, "unexpected token (\"" + CurrentLineTokens.get(PossibleIndexIndex) + "\"): must be an index (starting with \"[\") or an assignment (\"=\")."));
    
    
    // formula for new value
    LooFTokenBranch NewValueFormula = GetLexedFormula (CurrentLineTokens, AssignmentTokenIndex + 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds);
    
    
    // assemble final statement
    LooFTokenBranch[] Output = new LooFTokenBranch [TargetVarIndexes.size() + 2];
    Output[0] = TargetVarName;
    int TargetVarIndexesSize = TargetVarIndexes.size();
    for (int i = 0; i < TargetVarIndexesSize; i ++) {
      Output[i + 1] = TargetVarIndexes.get(i);
    }
    Output[Output.length - 1] = NewValueFormula;
    
    
    return Output;
  }
  
  
  
  
  
  LooFTokenBranch[] GetLexedTokensForLine_InterpreterCall (ArrayList <String> CurrentLineTokens, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds, LooFFileCodeData CodeData, int LineNumber) {
    if (!StringIsInterpreterCall (CurrentLineTokens.get(0))) throw (new LooFCompileException (CodeData, LineNumber, "statement type " + CurrentLineTokens.get(0) + " is unknown."));
    
    
    // statement name
    LooFTokenBranch StatementName = new LooFTokenBranch (TokenBranchType_Name, CurrentLineTokens.get(0));
    
    
    // get args
    LooFTokenBranch StatementArgs = GetStatementArgs (CurrentLineTokens, BlockLevels, BlockEnds);
    
    
    // assemble final statement
    LooFTokenBranch[] Output = new LooFTokenBranch[] {
      StatementName,
      StatementArgs
    };
    
    
    return Output;
  }
  
  
  
  LooFTokenBranch GetStatementArgs (ArrayList <String> CurrentLineTokens, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds) {
    
    if (CurrentLineTokens.size() == 1) {
      return new LooFTokenBranch (TokenBranchType_Table, new LooFTokenBranch [0]);
    }
    
    return GetLexedTable (CurrentLineTokens, 1, CurrentLineTokens.size() - 1, BlockLevels, BlockEnds);
    
  }
  
  
  
  
  
  LooFTokenBranch GetLexedFormula (ArrayList <String> CurrentLineTokens, int FormulaBlockStart, int FormulaBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds) {
    ArrayList <LooFTokenBranch> FormulaChildren = new ArrayList <LooFTokenBranch> ();
    for (int i = FormulaBlockStart; i < FormulaBlockEnd + 1; i ++) {
      String CurrentToken = CurrentLineTokens.get(i);
      LooFTokenBranch NewChild = GetTokenBranchFromToken (CurrentToken, CurrentLineTokens, i, BlockLevels, BlockEnds);
      FormulaChildren.add(NewChild);
      int BlockEnd = BlockEnds.get(i);
      if (BlockEnd != -1) i = BlockEnd;
    }
    LooFTokenBranch[] FormulaChildrenArray = ArrayListToArray (FormulaChildren, new LooFTokenBranch (0));
    return new LooFTokenBranch (TokenBranchType_Formula, FormulaChildrenArray);
  }
  
  
  
  LooFTokenBranch GetTokenBranchFromToken (String CurrentToken, ArrayList <String> CurrentLineTokens, int TokenNumber, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds) {
    
    switch (CurrentToken.charAt(0)) {
      
      // Type_Formula
      case ('('):
        return GetLexedFormula (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds);
      
      // Type_Index
      case ('['):
        LooFTokenBranch IndexFormula = GetLexedFormula (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds);
        IndexFormula.Type = TokenBranchType_Index;
        return IndexFormula;
      
      // Type_Table
      case ('{'):
        return GetLexedTable (CurrentLineTokens, TokenNumber + 1, BlockEnds.get(TokenNumber) - 1, BlockLevels, BlockEnds);
      
    }
    
    // Type_String
    if (CurrentToken.charAt(0) == '"') {
      String StringValue = CurrentToken.substring(1, CurrentToken.length() - 1);
      return new LooFTokenBranch (TokenBranchType_String, StringValue);
    }
    
    // Type_Number
    if (TokenIsNumber (CurrentToken)) {
      return new LooFTokenBranch (Double.parseDouble(CurrentToken));
    }
    
    // Type_Name
    return new LooFTokenBranch (TokenBranchType_Name, CurrentToken);
    
  }
  
  
  
  
  
  LooFTokenBranch GetLexedTable (ArrayList <String> CurrentLineTokens, int TableBlockStart, int TableBlockEnd, ArrayList <Integer> BlockLevels, ArrayList <Integer> BlockEnds) {
    if (TableBlockStart == TableBlockEnd + 1) return new LooFTokenBranch (TokenBranchType_Table, new LooFTokenBranch [0]);
    int TableBlockLevel = BlockLevels.get(TableBlockStart);
    ArrayList <LooFTokenBranch> Items = new ArrayList <LooFTokenBranch> ();
    
    int ItemStartIndex = TableBlockStart;
    int PrevNextCommaIndex = ItemStartIndex - 1;
    int NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, TableBlockStart, TableBlockEnd, TableBlockLevel, BlockLevels);
    while (NextCommaIndex != -1) {
      Items.add (GetLexedFormula (CurrentLineTokens, ItemStartIndex, NextCommaIndex - 1, BlockLevels, BlockEnds));
      ItemStartIndex = NextCommaIndex + 1;
      PrevNextCommaIndex = NextCommaIndex;
      NextCommaIndex = GetNextCommaIndex (CurrentLineTokens, NextCommaIndex + 1, TableBlockEnd, TableBlockLevel, BlockLevels);
    }
    Items.add (GetLexedFormula (CurrentLineTokens, PrevNextCommaIndex + 1, TableBlockEnd, BlockLevels, BlockEnds));
    
    return new LooFTokenBranch (TokenBranchType_Table, ArrayListToArray (Items, new LooFTokenBranch (0)));
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
  
  
  
  boolean StringIsInterpreterCall (String StringIn) {
    switch (StringIn) {
      
      case ("default"):
      case ("push"):
      case ("pop"):
      case ("call"):
      case ("return"):
      case ("returnIf"):
      case ("if"):
      case ("skip"):
      case ("end"):
      case ("loop"):
      case ("forEach"):
      case ("while"):
      case ("repeat"):
      case ("repeatIf"):
      case ("continue"):
      case ("continueIf"):
      case ("break"):
      case ("breakIf"):
      case ("error"):
      case ("errorIf"):
      case ("callOutside"):
        return true;
      
      default:
        return false;
      
    }
  }
  
  
  
  
  
  ReturnValue GetAllBlockLevelsAndEnds (ArrayList <String> CurrentLineTokens, LooFFileCodeData CodeData, int LineNumber) {
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
  
  
  
  
  
  void EnsureStatementIsValid (LooFTokenBranch[] Statement, LooFFileCodeData CodeData, int LineNumber) {
    switch (Statement[0].StringValue) {
      
      case ("default"): // assignments
        return;
      
      case ("push"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("pop"):
        EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("call"):
        EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("return"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 1, CodeData, LineNumber);
        return;
      
      case ("returnIf"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, LineNumber);
        return;
      
      case ("if"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("skip"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("end"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("loop"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 3, CodeData, LineNumber);
        return;
      
      case ("forEach"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, LineNumber);
        return;
      
      case ("while"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("repeat"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("repeatIf"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("continue"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("continueIf"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("break"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("breakIf"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
        return;
      
      case ("error"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 2, CodeData, LineNumber);
        return;
      
      case ("errorIf"):
        EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 3, CodeData, LineNumber);
        return;
      
      case ("callOutside"):
        EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
        return;
      
    }
  }
  
  
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFTokenBranch[] Statement, int CorrectNumberOfArgs, LooFFileCodeData CodeData, int LineNumber) {
    LooFTokenBranch StatementArgs = Statement[1];
    int NumberOfArgs = StatementArgs.Children.length;
    if (NumberOfArgs != CorrectNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + CorrectNumberOfArgs + " arguments, but " + (NumberOfArgs < CorrectNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Bounded (LooFTokenBranch[] Statement, int MinNumberOfArgs, int MaxNumberOfArgs, LooFFileCodeData CodeData, int LineNumber) {
    LooFTokenBranch StatementArgs = Statement[1];
    int NumberOfArgs = StatementArgs.Children.length;
    if (NumberOfArgs < MinNumberOfArgs || NumberOfArgs > MaxNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "either " : "between ") + MinNumberOfArgs + (MinNumberOfArgs + 1 == MaxNumberOfArgs ? "or " : "and ") + MaxNumberOfArgs + " arguments, but " + (NumberOfArgs < MinNumberOfArgs ? "only " : "") + NumberOfArgs + " were found."));
  }
  
  
  
  void EnsureStatementHasCorrectNumberOfArgs_Unbounded (LooFTokenBranch[] Statement, int CorrectNumberOfArgs, LooFFileCodeData CodeData, int LineNumber) {
    LooFTokenBranch StatementArgs = Statement[1];
    int NumberOfArgs = StatementArgs.Children.length;
    if (NumberOfArgs < CorrectNumberOfArgs) throw (new LooFCompileException (CodeData, LineNumber, "this statement needs to have " + CorrectNumberOfArgs + " arguments, but only " + NumberOfArgs + " were found."));
  }
  
  
  
  
  
  
  
  
  
  void SimplifyStatement (LooFTokenBranch[] Statement, LooFFileCodeData CodeData, int LineNumber) {
    SimplifyNestedFormulasForStatement (Statement);
    SimplifyOutputVarsForStatement (Statement, CodeData, LineNumber);
  }
  
  
  
  
  
  void SimplifyOutputVarsForStatement (LooFTokenBranch[] Statement, LooFFileCodeData CodeData, int LineNumber) {
    if (Statement[0].Type != TokenBranchType_Name) return;
    switch (Statement[0].StringValue) {
      
      default:
        throw (new RuntimeException ("INTERNAL ERROR: could not recognize statement type \"" + Statement[0].StringValue));
      
      case ("default"):
        SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
        return;
      
      case ("push"):
        return;
      
      case ("pop"):
        SimplifyAllOutputVars (Statement, CodeData, LineNumber);
        return;
      
      case ("call"):
        return;
      
      case ("return"):
        return;
      
      case ("returnIf"):
        return;
      
      case ("if"):
        return;
      
      case ("skip"):
        return;
      
      case ("end"):
        return;
      
      case ("loop"):
        if (Statement[1].Children.length >= 1) {
          SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
        }
        return;
      
      case ("forEach"):
        SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
        if (Statement[1].Children.length == 3) {
          SimplifySingleOutputVar (Statement, 2, CodeData, LineNumber);
        }
        return;
      
      case ("while"):
        return;
      
      case ("repeat"):
        return;
      
      case ("repeatIf"):
        return;
      
      case ("continue"):
        return;
      
      case ("continueIf"):
        return;
      
      case ("break"):
        return;
      
      case ("breakIf"):
        return;
      
      case ("error"):
        return;
      
      case ("errorIf"):
        return;
      
      case ("callOutside"):
        return;
      
    }
  }
  
  
  
  void SimplifyAllOutputVars (LooFTokenBranch[] Statement, LooFFileCodeData CodeData, int LineNumber) {
    int NumberOfArgs = Statement[1].Children.length;
    for (int i = 0; i < NumberOfArgs; i ++) {
      SimplifySingleOutputVar (Statement, i, CodeData, LineNumber);
    }
  }
  
  
  
  
  
  void SimplifySingleOutputVar (LooFTokenBranch[] Statement, int OutputVarIndex, LooFFileCodeData CodeData, int LineNumber) {
    LooFTokenBranch OutputArg = Statement[1].Children[OutputVarIndex];
    LooFTokenBranch[] OutputArgChildren = OutputArg.Children;
    if (OutputArgChildren.length != 1) throw (new LooFCompileException (CodeData, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to."));
    LooFTokenBranch OutputVarToken = OutputArgChildren[0];
    if (OutputVarToken.Type != TokenBranchType_Name) throw (new LooFCompileException (CodeData, LineNumber, "argument " + OutputVarIndex + " needs to be the name of a variable to output to, not a " + TokenBranchTypeNames[OutputVarToken.Type] + "."));
    OutputVarToken.Type = TokenBranchType_OutputVar;
    Statement[1].Children[OutputVarIndex] = OutputVarToken;
  }
  
  
  
  
  
  void SimplifyNestedFormulasForStatement (LooFTokenBranch[] Statement) {
    if (Statement.length == 1) return;
    
    // assignments
    if (Statement[0].Type == TokenBranchType_OutputVar) {
      Statement[Statement.length - 1] = GetSimplifyNestedFormulas (Statement[Statement.length - 1]);
      return;
    }
    
    // interpreter calls
    LooFTokenBranch[] Args = Statement[1].Children;
    for (int i = 0; i < Args.length; i ++) {
      Args[i] = GetSimplifyNestedFormulas (Args[i]);
    }
    
  }
  
  
  
  LooFTokenBranch GetSimplifyNestedFormulas (LooFTokenBranch TokenBranch) {
    LooFTokenBranch[] Children = TokenBranch.Children;
    if (Children.length != 1) return TokenBranch;
    if (Children[0].Type != TokenBranchType_Formula) return TokenBranch;
    return Children[0];
  }
  
  
  
  
  
  
  
  
  
  
  void PrintPreProcessorOutput (HashMap <String, LooFFileCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullName;
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
  
  
  
  
  
  
  
  
  
  
  void PrintLinkerOutput (HashMap <String, LooFFileCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullName;
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
  
  
  
  
  
  
  
  
  
  
  void PrintParserOutput (HashMap <String, LooFFileCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullName;
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
  
  
  
  
  
  
  
  
  
  
  void PrintLexerOutput (HashMap <String, LooFFileCodeData> AllCodeDatas, String OutputPath, String FileExtention) {
    Collection <LooFFileCodeData> AllCodeDatasCollection = AllCodeDatas.values();
    for (LooFFileCodeData CodeData : AllCodeDatasCollection) {
      String FileOutputName = OutputPath + "/" + CodeData.FullName;
      FileOutputName = ReplaceFileExtention (FileOutputName, FileExtention);
      PrintWriter FileOutput = createWriter (FileOutputName);
      
      LooFTokenBranch[][] Statements = CodeData.Statements;
      ArrayList <Integer> LineNumbers = CodeData.LineNumbers;
      ArrayList <String> LineFileOrigins = CodeData.LineFileOrigins;
      for (int i = 0; i < Statements.length; i ++) {
        LooFTokenBranch[] Line = Statements[i];
        int LineNumber = LineNumbers.get(i);
        String LineFileOrigin = LineFileOrigins.get(i);
        FileOutput.println (LineFileOrigin + " " + LineNumber + ": " + ConvertLooFStatementToString (Line));
      }
      
      FileOutput.flush();
      FileOutput.close();
    }
  }
  
  
  
  
  
  
  
  
  
  
}
