LooFInterpreterFunction InterpreterFunction_Push = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    LooFDataValue ValueToAdd = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    Environment.GeneralStack.add(ValueToAdd);
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'push'";}
};





LooFInterpreterFunction InterpreterFunction_Pop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (CurrentStatement, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'pop'";}
};





LooFInterpreterFunction InterpreterFunction_Call = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (CurrentStatement.Args, false, CodeData, AllCodeDatas, LineNumber, "call");
    CurrentStatement.AdditionalData = new LooFAdditionalCallStatementData (ReturnValue.Value1, ReturnValue.Value2);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalCallStatementData AdditionalData = (LooFAdditionalCallStatementData) CurrentStatement.AdditionalData;
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
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'return'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRaw = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnRaw'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnIf'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRawIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnRawIf'";}
};





LooFInterpreterFunction InterpreterFunction_If = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, 2, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'if'";}
};





LooFInterpreterFunction InterpreterFunction_Skip = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingEndStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"end"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    if (Args.length == 0) {
      CurrentStatement.AdditionalData = new LooFAdditionalSkipStatementData (MatchingEndStatementIndex, false);
      return;
    }
    Boolean StartsFunction = LooFCompiler.GetBoolFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    if (StartsFunction == null) ThrowLooFException (null, CodeData, AllCodeDatas, "'skip' statements can only take a final bool arg or no args.", new String[] {"InvalidArgType"});
    CurrentStatement.AdditionalData = new LooFAdditionalSkipStatementData (MatchingEndStatementIndex, StartsFunction);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalSkipStatementData AdditionalData = (LooFAdditionalSkipStatementData) CurrentStatement.AdditionalData;
    return "'skip' ('end' at: " + AdditionalData.MatchingEndStatementIndex + "; starts function: " + AdditionalData.StartsFunction + ")";
  }
};



class LooFAdditionalSkipStatementData extends LooFAdditionalStatementData {
  
  int MatchingEndStatementIndex;
  boolean StartsFunction;
  
  public LooFAdditionalSkipStatementData (int MatchingEndStatementIndex, boolean StartsFunction) {
    this.MatchingEndStatementIndex = MatchingEndStatementIndex;
    this.StartsFunction = StartsFunction;
  }
  
}





LooFInterpreterFunction InterpreterFunction_End = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingSkipStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"skip"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    LooFStatement MatchingSkipStatement = CodeData.Statements[MatchingSkipStatementIndex];
    LooFAdditionalSkipStatementData SkipStatementData = (LooFAdditionalSkipStatementData) MatchingSkipStatement.AdditionalData;
    if (SkipStatementData == null) throw new LooFCompilerException ("");
    CurrentStatement.AdditionalData = new LooFAdditionalEndStatementData (SkipStatementData.StartsFunction);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'end'";}
};



class LooFAdditionalEndStatementData extends LooFAdditionalStatementData {
  
  boolean EndsFunction;
  
  public LooFAdditionalEndStatementData (boolean EndsFunction) {
    this.EndsFunction = EndsFunction;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Loop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, 4, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    if (Args.length > 0) LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
    return "'loop' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ForEach = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    if (Args.length == 3) LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 2, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
    return "'forEach' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_While = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
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
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'repeat' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_RepeatIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'repeatIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_Continue = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'continue' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ContinueIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'continueIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};



class LooFAdditionalRepeatingStatementData extends LooFAdditionalStatementData {
  
  
  int MatchingLoopingStatementIndex;
  
  public LooFAdditionalRepeatingStatementData (int MatchingLoopingStatementIndex) {
    this.MatchingLoopingStatementIndex = MatchingLoopingStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Break = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) CurrentStatement.AdditionalData;
    return "'break' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_BreakIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) CurrentStatement.AdditionalData;
    return "'breakIf' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};



class LooFAdditionalBreakStatementData extends LooFAdditionalStatementData {
  
  int MatchingRepeatStatementIndex;
  
  public LooFAdditionalBreakStatementData (int MatchingRepeatStatementIndex) {
    this.MatchingRepeatStatementIndex = MatchingRepeatStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Error = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, 2, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber) : null;
    CurrentStatement.AdditionalData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) CurrentStatement.AdditionalData;
    return "'error' (Message: " + AdditionalData.ErrorMessage + "; error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypeTags, ", ") + "})";
  }
};





LooFInterpreterFunction InterpreterFunction_ErrorIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[2], 3, CodeData, AllCodeDatas, LineNumber) : null;
    CurrentStatement.AdditionalData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) CurrentStatement.AdditionalData;
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
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypesToPass = LooFCompiler.GetStringArrayFromStatementArg (CurrentStatement.Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    CurrentStatement.AdditionalData = new LooFAdditionalSetPassedErrorsStatementData (ErrorTypesToPass);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalSetPassedErrorsStatementData AdditionalData = (LooFAdditionalSetPassedErrorsStatementData) CurrentStatement.AdditionalData;
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
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 2, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (CurrentStatement.Args, true, CodeData, AllCodeDatas, LineNumber, "try");
    CurrentStatement.AdditionalData = new LooFAdditionalTryStatementData (ReturnValue.Value1, ReturnValue.Value2, ReturnValue.Value3);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalTryStatementData AdditionalData = (LooFAdditionalTryStatementData) CurrentStatement.AdditionalData;
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
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ModuleName = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    LooFInterpreterModule ModuleToCall = AddonsData.InterpreterModules.getOrDefault (ModuleName, null);
    if (ModuleToCall == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find any module named \"" + ModuleName + "\"."));
    CurrentStatement.AdditionalData = new LooFAdditionalCallOutsideStatementData (ModuleName, ModuleToCall);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalCallOutsideStatementData AdditionalData = (LooFAdditionalCallOutsideStatementData) CurrentStatement.AdditionalData;
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
