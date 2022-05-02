LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  ArrayList <LooFEnvironment> AllEnvironments = new ArrayList <LooFEnvironment> ();
  
  HashMap <String, LooFModule> AllModules = new HashMap <String, LooFModule> ();
  
  
  
  
  
  
  
  
  
  
  void AddNewEnvironment (File CodeFolder) {
    AddNewEnvironment (CodeFolder, new LooFCompileSettings());
  }
  
  void AddNewEnvironment (File CodeFolder, LooFCompileSettings CompileSettings) {
    if (CodeFolder == null) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File argument is null)."));
    if (!CodeFolder.exists()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument (File does not exist)."));
    if (!CodeFolder.isDirectory()) throw (new LooFCompileException ("AddNewEnvironment must take a folder as its argument. (File is not a folder)."));
    if (CompileSettings == null) throw (new LooFCompileException ("AddNewEnvironment cannot take a null LoofCompileSettings object. Either pass a new LooFCompileSettings object or call AddNewEvironment with no LooFCompileSettings argument."));
    
    LooFEnvironment NewEnvironment = LooFCompiler.CompileEnvironmentFromFolder (CodeFolder, CompileSettings);
    AllEnvironments.add(NewEnvironment);
    
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue GetVariableValue (LooFEnvironment Environment, String VariableName, boolean CreateNullVar, String FileName, int LineNumber) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    LooFDataValue FoundVariableValue = CurrentVariableList.get(VariableName);
    if (FoundVariableValue == null) {
      if (CreateNullVar) {
        LooFDataValue NewVariableValue = new LooFDataValue ();
        CurrentVariableList.put(VariableName, NewVariableValue);
        return NewVariableValue;
      }
      throw (new LooFInterpreterException (Environment, FileName, LineNumber, "could not find any variables named \"" + VariableName + "\"."));
    }
    return CurrentVariableList.get(VariableName);
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue EvaluateFormula (LooFTokenBranch Formula, LooFEnvironment Environment, String FileName, int LineNumber) {
    ArrayList <LooFTokenBranch> FormulaTokens = ArrayToArrayList (Formula.Children);
    if (FormulaTokens.size() == 0) return new LooFDataValue();
    ArrayList <LooFDataValue> FormulaValues = GetFormulaValuesFromTokens (FormulaTokens, Environment, FileName, LineNumber);
    
    // evaluate indexes
    for (int i = 1; i < FormulaTokens.size(); i ++) {
      LooFTokenBranch CurrentToken = FormulaTokens.get(i);
      if (CurrentToken.Type == TokenBranchType_Index) {
        LooFDataValue EvaluatedIndex = EvaluateFormula (CurrentToken, Environment, FileName, LineNumber);
        LooFDataValue NewValue = GetDataValueIndex (FormulaValues.get(i - 1), EvaluatedIndex, FormulaTokens.get(i - 1), Environment, FileName, LineNumber);
        FormulaTokens.remove(i);
        FormulaValues.remove(i);
        FormulaValues.set(i - 1, NewValue);
        i --;
      }
    }
    
    return null;
  }
  
  
  
  
  
  ArrayList <LooFDataValue> GetFormulaValuesFromTokens (ArrayList <LooFTokenBranch> FormulaTokens, LooFEnvironment Environment, String FileName, int LineNumber) {
    ArrayList <LooFDataValue> FormulaValues = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : FormulaTokens) {
      FormulaValues.add (GetDataValueFromToken (CurrentToken, Environment, FileName, LineNumber));
    }
    return FormulaValues;
  }
  
  
  
  LooFDataValue GetDataValueFromToken (LooFTokenBranch CurrentToken, LooFEnvironment Environment, String FileName, int LineNumber) {
    switch (CurrentToken.Type) {
      
      default:
        throw (new RuntimeException ("INTERNAL ERROR: could not recognize token branch type " + CurrentToken.Type + "."));
      
      case (TokenBranchType_Number):
        return new LooFDataValue (CurrentToken.NumberValue);
      
      case (TokenBranchType_String):
        return new LooFDataValue (CurrentToken.StringValue);
      
      case (TokenBranchType_Bool):
        return new LooFDataValue (CurrentToken.BoolValue);
      
      case (TokenBranchType_Table):
        return null;
      
      case (TokenBranchType_Name):
        return GetVariableValue (Environment, CurrentToken.StringValue, false, FileName, LineNumber);
      
      case (TokenBranchType_Formula):
        return null;
      
      case (TokenBranchType_Index):
        return null;
      
      case (TokenBranchType_OutputVar):
        throw (new RuntimeException ("INTERNAL ERROR: tried to convert an OutputVar token branch to a data value."));
      
    }
  }
  
  
  
  
  
  LooFDataValue GetDataValueIndex (LooFDataValue TableDataValue, LooFDataValue IndexDataValue, LooFTokenBranch TableDataValueSource, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    // error if source is not indexable
    switch (TableDataValueSource.Type) {
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot index " + TokenBranchTypeNames_PlusA[TableDataValueSource.Type] + "."));
      case (TokenBranchType_Table):
      case (TokenBranchType_Name):
        break;
    }
    
    // error if data value is not indexable
    switch (TableDataValue.Type) {
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot index " + DataValueTypeNames_PlusA[TableDataValue.Type] + "."));
      case (DataValueType_Table):
        break;
    }
    
    // get index
    switch (IndexDataValue.Type) {
      
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "tables cannot be indexed with " + DataValueTypeNames_PlusA[IndexDataValue.Type] + "."));
      
      case (DataValueType_Number):
        double NumberValue = IndexDataValue.NumberValue;
        if (NumberValue % 1 != 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "tables cannot be indexed with a non-integer number."));
        int NumberValueInt = (int) NumberValue;
        ArrayList <LooFDataValue> TableValue = TableDataValue.TableValue;
        if (NumberValueInt < 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (negative)."));
        if (NumberValueInt >= TableValue.size()) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (too large)."));
        return TableValue.get(NumberValueInt);
      
      case (DataValueType_String):
        String StringValue = IndexDataValue.StringValue;
        HashMap <String, LooFDataValue> HashMapValue = TableDataValue.HashMapValue;
        return HashMapValue.getOrDefault (StringValue, new LooFDataValue());
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
}
