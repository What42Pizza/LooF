LooFInterpreterAssignment Assignment_Equals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    return LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
  }
};





LooFInterpreterAssignment Assignment_PlusEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '+=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '+=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue + InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) + GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_MinusEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '-=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '-=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue - InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) - GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_TimesEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '*=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '*=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue * InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) * GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_DivideEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '/=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '/=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      if (InputFormulaResult.IntValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0.", new String[] {"DivideByZero"}));
      return new LooFDataValue (OldVarValue.IntValue / InputFormulaResult.IntValue);
    }
    double InputFormulaResultNumberValue = GetDataValueNumber (InputFormulaResult);
    if (InputFormulaResultNumberValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0.", new String[] {"DivideByZero"}));
    return new LooFDataValue (GetDataValueNumber (OldVarValue) / InputFormulaResultNumberValue);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_PowerEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '^=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '^=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.pow(OldVarValue.IntValue, InputFormulaResult.IntValue));
    }
    return new LooFDataValue (Math.pow(GetDataValueNumber (OldVarValue), GetDataValueNumber (InputFormulaResult)));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_ModuloEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '%=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '%=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (CorrectModulo (OldVarValue.IntValue, InputFormulaResult.IntValue));
    }
    return new LooFDataValue (CorrectModulo (GetDataValueNumber (OldVarValue), GetDataValueNumber (InputFormulaResult)));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_ConcatEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the assignment '..=' only works on a var with a string value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    LooFDataValue InputAsString = Function_ToString.HandleFunctionCall (InputFormulaResult, Environment, null, null);
    return new LooFDataValue (OldVarValue.StringValue + InputAsString.StringValue);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_SetDefaultsTo = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    return (OldVarValue.ValueType == DataValueType_Null)   ?   LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null)   :   OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_SetAdd = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<add' only works on a var with a table value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    OldVarValue.ArrayValue.add(InputFormulaResult);
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_SetAddAtIndex = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<addAtIndex' only works on a var with a table value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (InputFormulaResult.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<addAtIndex' only works with a value of type table, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (InputFormulaResult.ArrayValue.size() != 2) throw (new LooFInterpreterException (Environment, "the assignment '<addAtIndex' takes 2 args, but " + InputFormulaResult.ArrayValue.size() + " were found.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"}));
    
    LooFDataValue IndexArg = InputFormulaResult.ArrayValue.get(0);
    LooFDataValue ItemArg  = InputFormulaResult.ArrayValue.get(1);
    if (IndexArg.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "the assignment '<addAtIndex' takes an int as its first arg, but the first arg was of type " + DataValueTypeNames[IndexArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (IndexArg.IntValue < 0) throw (new LooFInterpreterException (Environment, "index (" + IndexArg.IntValue + ") is out of bounds (negative).", new String[] {"IndexOutOfBounds", "NegativeIndex", "IndexError"}));
    ArrayList <LooFDataValue> InputArray = OldVarValue.ArrayValue;
    
    if (IndexArg.IntValue >= InputArray.size()) {
      for (int i = InputArray.size(); i < IndexArg.IntValue; i ++) InputArray.add(new LooFDataValue());
      InputArray.add (ItemArg);
      return OldVarValue;
    }
    
    InputArray.add((int) IndexArg.IntValue, ItemArg);
    return OldVarValue;
    
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_SetAddAll = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<addAll' only works on a var with a table value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (InputFormulaResult.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<addAll' only works with a value of type table, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    OldVarValue.ArrayValue.addAll(InputFormulaResult.ArrayValue);
    Set <String> InputKeySet = InputFormulaResult.HashMapValue.keySet();
    for (String CurrentKey : InputKeySet) OldVarValue.HashMapValue.put(CurrentKey, InputFormulaResult.HashMapValue.get(CurrentKey));
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_SetRemoveIndex = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the assignment '<removeIndex' only works on a var with a table value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment, null, null);
    if (InputFormulaResult.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "the assignment '<removeIndex' only works with a value of type int, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + ".", new String[] {"InvalidArgType"}));
    
    LooFDataValue IndexArg = InputFormulaResult;
    if (IndexArg.IntValue < 0) throw (new LooFInterpreterException (Environment, "index (" + IndexArg.IntValue + ") is out of bounds (negative).", new String[] {"IndexOutOfBounds", "NegativeIndex", "IndexError"}));
    ArrayList <LooFDataValue> InputArray = OldVarValue.ArrayValue;
    
    if (IndexArg.IntValue >= InputArray.size()) return OldVarValue;
    
    InputArray.remove(IndexArg.IntValue);
    return OldVarValue;
    
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};










LooFInterpreterAssignment Assignment_PlusPlus = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '++' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int)
      return new LooFDataValue (OldVarValue.IntValue + 1);
    return new LooFDataValue (OldVarValue.FloatValue + 1);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
  @Override public boolean TakesArgs() {return false;}
};





LooFInterpreterAssignment Assignment_MinusMinus = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!ValueIsNumber (OldVarValue)) throw (new LooFInterpreterException (Environment, "the assignment '--' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    if (OldVarValue.ValueType == DataValueType_Int)
      return new LooFDataValue (OldVarValue.IntValue - 1);
    return new LooFDataValue (OldVarValue.FloatValue - 1);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
  @Override public boolean TakesArgs() {return false;}
};





LooFInterpreterAssignment Assignment_NotNot = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Bool) throw (new LooFInterpreterException (Environment, "the assignment '!!' only works on a var with a bool value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + ".", new String[] {"InvalidArgType"}));
    return new LooFDataValue (!OldVarValue.BoolValue);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
  @Override public boolean TakesArgs() {return false;}
};





LooFInterpreterAssignment Assignment_GetClone = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    return OldVarValue.clone();
  }
  @Override public boolean AddToCombinedTokens() {return true;}
  @Override public boolean TakesArgs() {return false;}
};
