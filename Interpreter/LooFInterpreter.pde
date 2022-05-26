LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  
  
  
  
  
  
  
  void ExecuteNextEnvironmentStatements (LooFEnvironment Environment, int NumOfStatements) {
    for (int i = 0; i < NumOfStatements; i ++) {
      LooFStatement CurrentStatement = Environment.CurrentCodeData.Statements[Environment.CurrentLineNumber];
      ExecuteStatement (CurrentStatement, Environment);
    }
  }
  
  
  
  
  
  void ExecuteStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) {
    
    // execute statement
    if (CurrentStatement.StatementType == StatementType_Assignment)
      ExecuteAssignmentStatement (CurrentStatement, Environment);
    else
      ExecuteFunctionStatement (CurrentStatement, Environment);
    
    // inc line number
    Environment.CurrentLineNumber ++;
    int StatementsLength = Environment.CurrentCodeData.Statements.length;
    if (Environment.CurrentLineNumber >= StatementsLength) {
      Environment.CurrentLineNumber = StatementsLength - 1;
      throw (new LooFInterpreterException (Environment, "execution cannot reach the end of the file."));
    }
    
  }
  
  
  
  
  
  void ExecuteAssignmentStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) {
    String OutputVarName = CurrentStatement.VarName;
    LooFInterpreterAssignment StatementAssignment = CurrentStatement.Assignment;
    LooFTokenBranch[] IndexQueries = CurrentStatement.IndexQueries;
    LooFTokenBranch NewValueFormula = CurrentStatement.NewValueFormula;
    
    if (IndexQueries.length == 0) {
      LooFDataValue OldVarValue = GetVariableValue (OutputVarName, Environment, false);
      LooFDataValue NewVarValue = StatementAssignment.GetNewVarValue (OldVarValue, NewValueFormula, Environment);
      SetVariableValue (OutputVarName, NewVarValue, Environment);
      return;
    }
    
    LooFDataValue TargetTable = GetTargetTableForStatement (CurrentStatement, Environment);
    LooFDataValue IndexValue = EvaluateFormula (GetLastItemOf (IndexQueries), Environment);
    LooFDataValue OldVarValue = GetDataValueIndex (TargetTable, IndexValue, Environment);
    LooFDataValue NewVarValue = StatementAssignment.GetNewVarValue (OldVarValue, NewValueFormula, Environment);
    SetDataValueIndex (TargetTable, IndexValue, NewVarValue, Environment);
    
  }
  
  
  
  
  
  LooFDataValue GetTargetTableForStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) {
    LooFDataValue TargetTable = GetVariableValue (CurrentStatement.VarName, Environment, true);
    LooFTokenBranch[] IndexQueries = CurrentStatement.IndexQueries;
    for (int i = 0; i < IndexQueries.length - 1; i ++) {
      LooFDataValue ValueToIndexWith = EvaluateFormula (IndexQueries[i], Environment);
      TargetTable = GetDataValueIndex (TargetTable, ValueToIndexWith, Environment);
    }
    return TargetTable;
  }
  
  
  
  
  
  void ExecuteFunctionStatement (LooFStatement Statement, LooFEnvironment Environment) {
    LooFInterpreterFunction StatementFunction = Statement.Function;
    LooFTokenBranch[] StatementArgs = Statement.Args;
    StatementFunction.HandleFunctionCall(StatementArgs, Environment);
  }
  
  
  
  
  
  
  
  
  
  
  void SetVariableValue (String VariableName, LooFDataValue NewValue, LooFEnvironment Environment) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    if (NewValue.ValueType == DataValueType_Null) {
      CurrentVariableList.remove(VariableName);
      return;
    }
    CurrentVariableList.put(VariableName, NewValue);
  }
  
  
  
  
  
  LooFDataValue GetVariableValue (String VariableName, LooFEnvironment Environment, boolean CreateNullVar) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    LooFDataValue FoundVariableValue = CurrentVariableList.get(VariableName);
    if (FoundVariableValue != null) return CurrentVariableList.get(VariableName);
    if (!CreateNullVar) throw (new LooFInterpreterException (Environment, "could not find any variable named \"" + VariableName + "\"."));
    LooFDataValue NewVariableValue = new LooFDataValue ();
    CurrentVariableList.put(VariableName, NewVariableValue);
    return NewVariableValue;
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue EvaluateFormula (LooFTokenBranch Formula, LooFEnvironment Environment) {
    ArrayList <LooFTokenBranch> FormulaTokens = ArrayToArrayList (Formula.Children);
    if (FormulaTokens.size() == 0) return new LooFDataValue();
    ArrayList <LooFDataValue> FormulaValues = GetFormulaValuesFromTokens (FormulaTokens, Environment);
    
    int[] IndexQueryIndexes = Formula.IndexQueryIndexes;
    int[] FunctionIndexes = Formula.FunctionIndexes;
    FloatIntPair[] OperationIndexes = Formula.OperationIndexes;
    
    // evaluate indexes
    for (int CurrentTokenIndex : IndexQueryIndexes) {
      LooFDataValue IndexValue = EvaluateFormula (FormulaTokens.get(CurrentTokenIndex), Environment);
      LooFDataValue NewValue = GetDataValueIndex (FormulaValues.get(CurrentTokenIndex - 1), IndexValue, Environment);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.set(CurrentTokenIndex - 1, NewValue);
    }
    
    // evaluate functions
    for (int CurrentTokenIndex : FunctionIndexes) {
      LooFTokenBranch FunctionToken = FormulaTokens.get(CurrentTokenIndex);
      LooFEvaluatorFunction FunctionToCall = FunctionToken.Function;
      LooFDataValue FunctionInput = FormulaValues.get(CurrentTokenIndex + 1);
      LooFDataValue FunctionOutput = FunctionToCall.HandleFunctionCall (FunctionInput, Environment);
      FormulaTokens.remove(CurrentTokenIndex + 1);
      FormulaValues.remove(CurrentTokenIndex + 1);
      FormulaValues.set(CurrentTokenIndex, FunctionOutput);
    }
    
    // evaluator operations
    for (FloatIntPair CurrentTokenIndexPair : OperationIndexes) {
      int CurrentTokenIndex = CurrentTokenIndexPair.IntValue;
      LooFTokenBranch OperationToken = FormulaTokens.get(CurrentTokenIndex);
      LooFEvaluatorOperation OperationToCall = OperationToken.Operation;
      LooFDataValue LeftValue = FormulaValues.get(CurrentTokenIndex - 1);
      LooFDataValue RightValue = FormulaValues.get(CurrentTokenIndex + 1);
      LooFDataValue OperationOutput = OperationToCall.HandleOperation (LeftValue, RightValue, Environment);
      FormulaValues.set(CurrentTokenIndex - 1, OperationOutput);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
    }
    
    if (FormulaValues.size() > 1) throw new AssertionError();
    
    return FormulaValues.get(0);
  }
  
  
  
  
  
  LooFDataValue EvaluateTable (LooFTokenBranch Formula, LooFEnvironment Environment) {
    ArrayList <LooFDataValue> TableChildren = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : Formula.Children) {
      TableChildren.add(EvaluateFormula (CurrentToken, Environment));
    }
    return new LooFDataValue (TableChildren, new HashMap <String, LooFDataValue> ());
  }
  
  
  
  
  
  ArrayList <LooFDataValue> GetFormulaValuesFromTokens (ArrayList <LooFTokenBranch> FormulaTokens, LooFEnvironment Environment) {
    ArrayList <LooFDataValue> FormulaValues = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : FormulaTokens) {
      FormulaValues.add (GetDataValueFromToken (CurrentToken, Environment));
    }
    return FormulaValues;
  }
  
  
  
  LooFDataValue GetDataValueFromToken (LooFTokenBranch CurrentToken, LooFEnvironment Environment) {
    switch (CurrentToken.TokenType) {
      
      default:
        throw new AssertionError();
      
      case (TokenBranchType_Null):
        return new LooFDataValue();
      
      case (TokenBranchType_Int):
        return new LooFDataValue (CurrentToken.IntValue);
      
      case (TokenBranchType_Float):
        return new LooFDataValue (CurrentToken.FloatValue);
      
      case (TokenBranchType_String):
        return new LooFDataValue (CurrentToken.StringValue);
      
      case (TokenBranchType_Bool):
        return new LooFDataValue (CurrentToken.BoolValue);
      
      case (TokenBranchType_Table):
        return EvaluateTable (CurrentToken, Environment);
      
      case (TokenBranchType_Formula):
        return EvaluateFormula (CurrentToken, Environment);
      
      case (TokenBranchType_Index):
        return null;
      
      case (TokenBranchType_VarName):
        return GetVariableValue (CurrentToken.StringValue, Environment, false);
      
      case (TokenBranchType_OutputVar):
        throw new AssertionError();
      
      case (TokenBranchType_EvaluatorOperation):
        return null;
      
      case (TokenBranchType_EvaluatorFunction):
        return null;
      
    }
  }
  
  
  
  
  
  LooFDataValue GetDataValueIndex (LooFDataValue SourceTable, LooFDataValue IndexValue, LooFEnvironment Environment) {
    
    int CaseToUse = 0;
    
    // error if index is not a string or int
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
      default:
        throw (new LooFInterpreterException (Environment, DataValueTypeNames[SourceTable.ValueType] + "s cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + "."));
    }
    
    // error if data value is not indexable
    switch (SourceTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
      default:
        throw (new LooFInterpreterException (Environment, "cannot index " + DataValueTypeNames_PlusA[SourceTable.ValueType] + "."));
    }
    
    // get index
    switch (CaseToUse) {
      
      case (0): // table[int]
        long IndexIntValue_table = IndexValue.IntValue;
        ArrayList <LooFDataValue> ArrayValue = SourceTable.ArrayValue;
        if (IndexIntValue_table < 0) throw (new LooFInterpreterException (Environment, "index is out of bounds (negative)."));
        if (IndexIntValue_table >= ArrayValue.size()) throw (new LooFInterpreterException (Environment, "index is out of bounds (too large)."));
        return ArrayValue.get((int)IndexIntValue_table);
      
      case (1): // table[string]
        String StringValue = IndexValue.StringValue;
        HashMap <String, LooFDataValue> HashMapValue = SourceTable.HashMapValue;
        return HashMapValue.getOrDefault (StringValue, new LooFDataValue());
      
      case (2): // byteArray[int]
        long IndexIntValue_byteArray = IndexValue.IntValue;
        byte[] ByteArrayValue = SourceTable.ByteArrayValue;
        if (IndexIntValue_byteArray < 0) throw (new LooFInterpreterException (Environment, "index is out of bounds (negative)."));
        if (IndexIntValue_byteArray >= ByteArrayValue.length) throw (new LooFInterpreterException (Environment, "index is out of bounds (too large)."));
        return new LooFDataValue ((long) ByteArrayValue[(int)IndexIntValue_byteArray]);
      
      case (3): // byteArray[string]
        throw (new LooFInterpreterException (Environment, "cannot index byteArray with a string."));
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  void SetDataValueIndex (LooFDataValue TargetTable, LooFDataValue IndexValue, LooFDataValue NewVarValue, LooFEnvironment Environment) {
    int CaseToUse = 0;
    
    if (GetLastItemOf (TargetTable.LockLevels) > 0) throw (new LooFInterpreterException (Environment, "cannot set the index of a locked data value."));
    
    switch (TargetTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 1;
        break;
      default:
        throw (new LooFInterpreterException (Environment, "cannot set the index of " + DataValueTypeNames_PlusA[TargetTable.ValueType] + "."));
    }
    
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 2;
        break;
      default:
        throw (new LooFInterpreterException (Environment, DataValueTypeNames[TargetTable.ValueType] + "s cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + "."));
    }
    
    int IndexIntValue = (int) IndexValue.IntValue;
    String IndexStringValue = IndexValue.StringValue;
    
    switch (CaseToUse) {
      
      case (0): // table[int]
        if (IndexIntValue < 0) throw (new LooFInterpreterException (Environment, "index is out of bounds (negative)."));
        ArrayList <LooFDataValue> ArrayValue = TargetTable.ArrayValue;
        int TargetTableSize = ArrayValue.size();
        if (IndexIntValue > TargetTableSize) throw (new LooFInterpreterException (Environment, "index is out of bounds (too large)."));
        if (IndexIntValue == TargetTableSize) {
          ArrayValue.add(NewVarValue);
          return;
        }
        ArrayValue.set(IndexIntValue, NewVarValue);
        return;
      
      case (1): // byteArray[int]
        if (NewVarValue.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "cannot set an index of a byteArray to " + DataValueTypeNames_PlusA[NewVarValue.ValueType] + " (index must be an int)."));
        if (IndexIntValue < 0) throw (new LooFInterpreterException (Environment, "index is out of bounds (negative)."));
        byte[] ByteArrayValue = TargetTable.ByteArrayValue;
        if (IndexIntValue >= ByteArrayValue.length) throw (new LooFInterpreterException (Environment, "index is out of bounds (too large)."));
        ByteArrayValue[IndexIntValue] = (byte) NewVarValue.IntValue;
        return;
      
      case (2): // table[string]
        HashMap <String, LooFDataValue> HashMapValue = TargetTable.HashMapValue;
        if (NewVarValue.ValueType == DataValueType_Null) {
          HashMapValue.remove(IndexStringValue);
          return;
        }
        HashMapValue.put(IndexStringValue, NewVarValue);
        return;
      
      case (3):
        throw (new LooFInterpreterException (Environment, "byteArrays cannot be indexes with strings."));
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
}
