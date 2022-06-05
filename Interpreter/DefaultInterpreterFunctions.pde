LooFInterpreterFunction InterpreterFunction_Push = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    LooFDataValue ValueToAdd = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    Environment.GeneralStack.add(ValueToAdd);
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'push'";}
};





LooFInterpreterFunction InterpreterFunction_Pop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (Statement, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'pop'";}
};





LooFInterpreterFunction InterpreterFunction_ConditionalPop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (Statement, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'conditionalPop'";}
};





LooFInterpreterFunction InterpreterFunction_Call = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (Statement.Args, false, CodeData, AllCodeDatas, LineNumber, "call");
    Statement.AdditionalStatementData = new LooFAdditionalCallStatementData (ReturnValue.Value1, ReturnValue.Value2);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalCallStatementData AdditionalData = (LooFAdditionalCallStatementData) Statement.AdditionalStatementData;
    return "'call' (File: " + AdditionalData.NewIPFileName + ", line: " + AdditionalData.NewIPLineNumber + ")";
  }
};



class LooFAdditionalCallStatementData extends LooFAdditionalStatementData {
  
  Integer NewIPLineNumber;
  String NewIPFileName;
  
  public LooFAdditionalCallStatementData (Integer NewIPLineNumber, String NewIPFileName) {
    this.NewIPLineNumber = NewIPLineNumber;
    this.NewIPFileName = NewIPFileName;
  }
  
}





Tuple3 <Integer, String, String[]> GetFunctionCallData (LooFTokenBranch[] Args, boolean GetErrorTypesToCatch, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber, String FunctionName) {
  LooFTokenBranch FirstArg = Args[0];
  if (FirstArg.TokenType != TokenBranchType_PreEvaluatedFormula) return new Tuple3 <Integer, String, String[]> (null, null, null); // if we don't know the type of the first value, we can't figure out anything else
  LooFDataValue FirstArgValue = FirstArg.Result;
  if (FirstArgValue.ValueType != DataValueType_Function) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, FunctionName + " statements must take a function as its first arg, but the first arg was of type " + DataValueTypeNames[FirstArgValue.ValueType] + "."));
  Tuple3 <Integer, String, String[]> ReturnValue = new Tuple3 <Integer, String, String[]> (FirstArgValue.FunctionLineValue, FirstArgValue.FunctionPageValue, null);
  if (GetErrorTypesToCatch) ReturnValue.Value3 = LooFCompiler.GetStringArrayFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber);
  return ReturnValue;
}





LooFInterpreterFunction InterpreterFunction_Return = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'return'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRaw = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'returnRaw'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'returnIf'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRawIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'returnRawIf'";}
};





LooFInterpreterFunction InterpreterFunction_If = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement Statement) {return "'if'";}
};





LooFInterpreterFunction InterpreterFunction_Skip = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    Integer MatchingEndStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"end"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalSkipStatementData (MatchingEndStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalSkipStatementData AdditionalData = (LooFAdditionalSkipStatementData) Statement.AdditionalStatementData;
    return "'skip' ('end' at: " + AdditionalData.MatchingEndStatementIndex + ")";
  }
};



class LooFAdditionalSkipStatementData extends LooFAdditionalStatementData {
  
  Integer MatchingEndStatementIndex;
  
  public LooFAdditionalSkipStatementData (Integer MatchingEndStatementIndex) {
    this.MatchingEndStatementIndex = MatchingEndStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_End = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement Statement) {return "'end'";}
};





LooFInterpreterFunction InterpreterFunction_Loop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 4, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    if (Args.length > 0) LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) Statement.AdditionalStatementData;
    return "'loop' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ForEach = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    if (Args.length == 3) LooFCompiler.SimplifySingleOutputVar (Statement, 2, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) Statement.AdditionalStatementData;
    return "'forEach' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_While = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) Statement.AdditionalStatementData;
    return "'while' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};



class LooFAdditionalLoopingStatementData extends LooFAdditionalStatementData {
  
  int MatchingRepeatStatementIndex;
  
  public LooFAdditionalLoopingStatementData (int MatchingRepeatStatementIndex) {
    this.MatchingRepeatStatementIndex = MatchingRepeatStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Repeat = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) Statement.AdditionalStatementData;
    return "'repeat' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_RepeatIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) Statement.AdditionalStatementData;
    return "'repeatIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_Continue = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) Statement.AdditionalStatementData;
    return "'continue' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ContinueIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) Statement.AdditionalStatementData;
    return "'continueIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};



class LooFAdditionalRepeatingStatementData extends LooFAdditionalStatementData {
  
  Integer MatchingLoopingStatementIndex;
  
  public LooFAdditionalRepeatingStatementData (Integer MatchingLoopingStatementIndex) {
    this.MatchingLoopingStatementIndex = MatchingLoopingStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Break = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) Statement.AdditionalStatementData;
    return "'break' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_BreakIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    Statement.AdditionalStatementData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) Statement.AdditionalStatementData;
    return "'breakIf' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};



class LooFAdditionalBreakStatementData extends LooFAdditionalStatementData {
  
  Integer MatchingRepeatStatementIndex;
  
  public LooFAdditionalBreakStatementData (Integer MatchingRepeatStatementIndex) {
    this.MatchingRepeatStatementIndex = MatchingRepeatStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Error = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber) : null;
    Statement.AdditionalStatementData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) Statement.AdditionalStatementData;
    return "'error' (Message: " + AdditionalData.ErrorMessage + "; error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypeTags, ", ") + "})";
  }
};





LooFInterpreterFunction InterpreterFunction_ErrorIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[2], 3, CodeData, AllCodeDatas, LineNumber) : null;
    Statement.AdditionalStatementData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) Statement.AdditionalStatementData;
    return "'errorIf' (Message: " + AdditionalData.ErrorMessage + "; error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypeTags, ", ") + "})";
  }
};



class LooFAdditionalErrorStatementData extends LooFAdditionalStatementData {
  
  String ErrorMessage;
  String[] ErrorTypeTags;
  
  public LooFAdditionalErrorStatementData (String ErrorMessage, String[] ErrorTypeTags) {
    this.ErrorMessage = ErrorMessage;
    this.ErrorTypeTags = ErrorTypeTags;
  }
  
}





LooFInterpreterFunction InterpreterFunction_SetPassedErrors = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypesToPass = LooFCompiler.GetStringArrayFromStatementArg (Statement.Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    Statement.AdditionalStatementData = new LooFAdditionalSetPassedErrorsStatementData (ErrorTypesToPass);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalSetPassedErrorsStatementData AdditionalData = (LooFAdditionalSetPassedErrorsStatementData) Statement.AdditionalStatementData;
    return "'setPassedErrors' (Error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypesToPass, ", ") + "})";
  }
};



class LooFAdditionalSetPassedErrorsStatementData extends LooFAdditionalStatementData {
  
  String[] ErrorTypesToPass;
  
  public LooFAdditionalSetPassedErrorsStatementData (String[] ErrorTypesToPass) {
    this.ErrorTypesToPass = ErrorTypesToPass;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Try = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 2, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (Statement.Args, true, CodeData, AllCodeDatas, LineNumber, "try");
    Statement.AdditionalStatementData = new LooFAdditionalTryStatementData (ReturnValue.Value1, ReturnValue.Value2, ReturnValue.Value3);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalTryStatementData AdditionalData = (LooFAdditionalTryStatementData) Statement.AdditionalStatementData;
    return "'try' (File: " + AdditionalData.NewIPFileName + ", line: " + AdditionalData.NewIPLineNumber + "; error types to catch: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypesToCatch, ", ") + "})";
  }
};



class LooFAdditionalTryStatementData extends LooFAdditionalStatementData {
  
  Integer NewIPLineNumber;
  String NewIPFileName;
  String[] ErrorTypesToCatch;
  
  public LooFAdditionalTryStatementData (Integer NewIPLineNumber, String NewIPFileName, String[] ErrorTypesToCatch) {
    this.NewIPLineNumber = NewIPLineNumber;
    this.NewIPFileName = NewIPFileName;
    this.ErrorTypesToCatch = ErrorTypesToCatch;
  }
  
}





LooFInterpreterFunction InterpreterFunction_CallOutside = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    String ModuleName = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    LooFInterpreterModule ModuleToCall = AddonsData.InterpreterModules.getOrDefault (ModuleName, null);
    if (ModuleToCall == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find any module named \"" + ModuleName + "\"."));
    Statement.AdditionalStatementData = new LooFAdditionalCallOutsideStatementData (ModuleName, ModuleToCall);
  }
  @Override public String toString (LooFStatement Statement) {
    LooFAdditionalCallOutsideStatementData AdditionalData = (LooFAdditionalCallOutsideStatementData) Statement.AdditionalStatementData;
    return "'callOutside' (Module name: " + AdditionalData.ModuleName + ")";
  }
};



class LooFAdditionalCallOutsideStatementData extends LooFAdditionalStatementData {
  
  String ModuleName;
  LooFInterpreterModule ModuleToCall;
  
  public LooFAdditionalCallOutsideStatementData (String ModuleName, LooFInterpreterModule ModuleToCall) {
    this.ModuleName = ModuleName;
    this.ModuleToCall = ModuleToCall;
  }
  
}
