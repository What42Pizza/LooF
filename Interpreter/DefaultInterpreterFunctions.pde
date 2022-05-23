LooFInterpreterFunction InterpreterFunction_Push = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_Pop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (Statement, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_Call = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_Return = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 0, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_ReturnIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_If = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_Skip = new LooFInterpreterFunction() {
  int MatchingEndStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingEndStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"end"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
};





LooFInterpreterFunction InterpreterFunction_End = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
};





LooFInterpreterFunction InterpreterFunction_Loop = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 4, CodeData, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    if (Args.length > 0) LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
};





LooFInterpreterFunction InterpreterFunction_ForEach = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
    if (Args.length == 3) LooFCompiler.SimplifySingleOutputVar (Statement, 2, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
};





LooFInterpreterFunction InterpreterFunction_While = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
};





LooFInterpreterFunction InterpreterFunction_Repeat = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
};





LooFInterpreterFunction InterpreterFunction_RepeatIf = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
};





LooFInterpreterFunction InterpreterFunction_Continue = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
};





LooFInterpreterFunction InterpreterFunction_ContinueIf = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
};





LooFInterpreterFunction InterpreterFunction_Break = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
};





LooFInterpreterFunction InterpreterFunction_BreakIf = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
};





LooFInterpreterFunction InterpreterFunction_Error = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_ErrorIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_Try = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
};





LooFInterpreterFunction InterpreterFunction_CallOutside = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
};
