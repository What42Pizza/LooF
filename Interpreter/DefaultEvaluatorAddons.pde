LooFEvaluatorOperation Operation_Add = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue + RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) + GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"+\" can only add ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 4.0;}
};





LooFEvaluatorOperation Operation_Subtract = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue - RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) - GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"-\" can only subtract ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 4.0;}
};





LooFEvaluatorOperation Operation_Multiply = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue * RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) * GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"+\" can only multiply ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 5.0;}
};





LooFEvaluatorOperation Operation_Divide = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      if (RightValue.IntValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0."));
      long NewIntValue = LeftValue.IntValue / RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      double RightFloatValue = GetDataValueNumber (RightValue);
      if (RightFloatValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0."));
      return new LooFDataValue (GetDataValueNumber (LeftValue) / RightFloatValue);
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"+\" can only divide ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 5.0;}
};





LooFEvaluatorOperation Operation_Power = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = (long) Math.pow (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (Math.pow (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"^\" can only take an int or float to the power of an int or float, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " to the power of " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 8.0;}
};





LooFEvaluatorOperation Operation_Modulo = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = CorrectModulo (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (CorrectModulo (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"%\" can only modulo ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 6.0;}
};





LooFEvaluatorOperation Operation_Concat = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (LeftValue.ValueType == DataValueType_String && RightValue.ValueType == DataValueType_String) {
      String NewStringValue = LeftValue.StringValue + RightValue.StringValue;
      return new LooFDataValue (NewStringValue);
    }
    
    if (LeftValue.ValueType == DataValueType_Table && RightValue.ValueType == DataValueType_Table) {
      ArrayList <LooFDataValue> NewArrayValue = new ArrayList <LooFDataValue> ();
      NewArrayValue.addAll(LeftValue.ArrayValue);
      NewArrayValue.addAll(RightValue.ArrayValue);
      HashMap <String, LooFDataValue> NewHashMapValue = new HashMap <String, LooFDataValue> ();
      NewHashMapValue.putAll(LeftValue.HashMapValue);
      NewHashMapValue.putAll(RightValue.HashMapValue);
      return new LooFDataValue (NewArrayValue, NewHashMapValue);
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"..\" can only concatenate two strings or two tables, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 3.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_Equals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    switch (LeftValue.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue (RightValue.ValueType == DataValueType_Null);
      
      case (DataValueType_Int):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.IntValue == RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.IntValue == RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_Float):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.FloatValue == RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.FloatValue == RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_String):
        return new LooFDataValue (RightValue.ValueType == DataValueType_String && LeftValue.StringValue.equals(RightValue.IntValue));
      
      case (DataValueType_Bool):
        return new LooFDataValue (RightValue.ValueType == DataValueType_Bool && LeftValue.BoolValue == RightValue.BoolValue);
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (RightValue.ValueType == DataValueType_ByteArray && Arrays.equals(LeftValue.ByteArrayValue, RightValue.ByteArrayValue));
      
      case (DataValueType_Table):
         return new LooFDataValue (RightValue.ValueType == DataValueType_Table && LeftValue.ArrayValue.equals(RightValue.ArrayValue) && LeftValue.HashMapValue.equals(RightValue.HashMapValue));
      
      default:
        throw new AssertionError();
      
    }
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_StrictEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    return new LooFDataValue (LeftValue.equals(RightValue));
  };
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_GreaterThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) > GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \">\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 2.0;}
};





LooFEvaluatorOperation Operation_LessThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) < GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"<\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 2.0;}
};





LooFEvaluatorOperation Operation_NotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    switch (LeftValue.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue (RightValue.ValueType != DataValueType_Null);
      
      case (DataValueType_Int):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.IntValue != RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.IntValue != RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_Float):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.FloatValue != RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.FloatValue != RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_String):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_String && LeftValue.StringValue.equals(RightValue.IntValue)));
      
      case (DataValueType_Bool):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_Bool && LeftValue.BoolValue == RightValue.BoolValue));
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_ByteArray && Arrays.equals(LeftValue.ByteArrayValue, RightValue.ByteArrayValue)));
      
      case (DataValueType_Table):
         return new LooFDataValue (!(RightValue.ValueType == DataValueType_Table && LeftValue.ArrayValue.equals(RightValue.ArrayValue) && LeftValue.HashMapValue.equals(RightValue.HashMapValue)));
      
      default:
        throw new AssertionError();
      
    }
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_StrictNotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    return new LooFDataValue (!LeftValue.equals(RightValue));
  };
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_GreaterThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) >= GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \">=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_LessThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) <= GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, "the operation \"<=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_And = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment);
    return (LeftValueAsBool.BoolValue) ? RightValue : new LooFDataValue (false);
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_Or = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment);
    return (LeftValueAsBool.BoolValue) ? LeftValue : RightValue;
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_Xor = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment);
    LooFDataValue RightValueAsBool = Function_ToBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {RightValue}), Environment);
    return new LooFDataValue (LeftValueAsBool.BoolValue ^ RightValueAsBool.BoolValue);
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_BitwiseAnd = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      throw (new LooFInterpreterException (Environment, "the operation \"&&\" can only 'and' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
    return new LooFDataValue (LeftValue.IntValue & RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_BitwiseOr = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      throw (new LooFInterpreterException (Environment, "the operation \"||\" can only 'or' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
    return new LooFDataValue (LeftValue.IntValue | RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_BitwiseXor = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      throw (new LooFInterpreterException (Environment, "the operation \"^^\" can only 'xor' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
    return new LooFDataValue (LeftValue.IntValue ^ RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_ShiftRight = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      throw (new LooFInterpreterException (Environment, "the operation \"<<\" can only shift an int with an int, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " with " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
    return new LooFDataValue (LeftValue.IntValue << RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_ShiftLeft = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      throw (new LooFInterpreterException (Environment, "the operation \">>\" can only shift an int with an, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " with " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
    return new LooFDataValue (LeftValue.IntValue >> RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};




















LooFEvaluatorFunction Function_Round = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.round(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, "the evaluator function round can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_Floor = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue ((long) Math.floor(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, "the evaluator function floor can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_Ceil = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue ((long) Math.ceil(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, "the evaluator function ceil can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_Sqrt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.sqrt(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, "the evaluator function sqrt can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_Sign = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    if (!(Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the evaluator function sign can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    double InputNumberValue = GetDataValueNumber (Input);
    return new LooFDataValue (InputNumberValue >= 0 ? 1 : -1);
    
  }
};





LooFEvaluatorFunction Function_Not = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    LooFDataValue InputAsBool = Function_ToBool.HandleFunctionCall (Input, Environment);
    InputAsBool.BoolValue = !InputAsBool.BoolValue;
    
    return InputAsBool;
    
  }
};





LooFEvaluatorFunction Function_Min = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function min can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize == 0) throw (new LooFInterpreterException (Environment, "the evaluator function min cannot be called with an empty table."));
    
    // ensure table contains only ints and floats
    boolean[] DataValueTypesInInput = GetDataValueTypesFoundInList (InputItems);
    boolean[] AllowedDataValueTypes = new boolean [NumOfDataValueTypes];
    AllowedDataValueTypes[DataValueType_Int] = true;
    AllowedDataValueTypes[DataValueType_Float] = true;
    for (int i = 0; i < AllowedDataValueTypes.length; i ++) {
      if (DataValueTypesInInput[i] && !AllowedDataValueTypes[i]) throw (new LooFInterpreterException (Environment, "the evaluator function min can only take a table with ints and floats, but the table given contained a value of type " + DataValueTypeNames[i] + "."));
    }
    
    // if there's a float
    if (DataValueTypesInInput[DataValueType_Float]) {
      LooFDataValue FirstItem = InputItems.get(0);
      double MinValue = GetDataValueNumber_Unsafe (FirstItem, Environment, "min");
      for (int i = 1; i < InputItemsSize; i ++) {
        LooFDataValue CurrentItem = InputItems.get(i);
        MinValue = Math.min (MinValue, GetDataValueNumber_Unsafe (CurrentItem, Environment, "min"));
      }
      return new LooFDataValue (MinValue);
    }
    
    // if it's all ints
    LooFDataValue FirstItem = InputItems.get(0);
    long MinValue = FirstItem.IntValue;
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      MinValue = Math.min (MinValue, CurrentItem.IntValue);
    }
    return new LooFDataValue (MinValue);
    
  }
};





LooFEvaluatorFunction Function_Max = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function max can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize == 0) throw (new LooFInterpreterException (Environment, "the evaluator function max cannot be called with an empty table."));
    
    // ensure table contains only ints and floats
    boolean[] DataValueTypesInInput = GetDataValueTypesFoundInList (InputItems);
    boolean[] AllowedDataValueTypes = new boolean [NumOfDataValueTypes];
    AllowedDataValueTypes[DataValueType_Int] = true;
    AllowedDataValueTypes[DataValueType_Float] = true;
    for (int i = 0; i < AllowedDataValueTypes.length; i ++) {
      if (DataValueTypesInInput[i] && !AllowedDataValueTypes[i]) throw (new LooFInterpreterException (Environment, "the evaluator function max can only take a table with ints and floats, but the table given contained a value of type " + DataValueTypeNames[i] + "."));
    }
    
    // if there's a float
    if (DataValueTypesInInput[DataValueType_Float]) {
      LooFDataValue FirstItem = InputItems.get(0);
      double MaxValue = GetDataValueNumber_Unsafe (FirstItem, Environment, "max");
      for (int i = 1; i < InputItemsSize; i ++) {
        LooFDataValue CurrentItem = InputItems.get(i);
        MaxValue = Math.max (MaxValue, GetDataValueNumber_Unsafe (CurrentItem, Environment, "max"));
      }
      return new LooFDataValue (MaxValue);
    }
    
    // if it's all ints
    LooFDataValue FirstItem = InputItems.get(0);
    long MaxValue = FirstItem.IntValue;
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      MaxValue = Math.max (MaxValue, CurrentItem.IntValue);
    }
    return new LooFDataValue (MaxValue);
    
  }
};





LooFEvaluatorFunction Function_Random = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (!(Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the evaluator function random can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    double MaxValue = GetDataValueNumber (Input);
    return new LooFDataValue (Math.random() * MaxValue);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_RandomInt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Int):
        long MaxInt = Input.IntValue;
        return new LooFDataValue ((int) (Math.random() * (MaxInt + 1)));
      
      case (DataValueType_Table):
        if (Input.ArrayValue.size() != 2) throw (new LooFInterpreterException (Environment, "the evaluator function randomInt can only take an int or a table of two ints, but a table with " + Input.ArrayValue.size() + " items was given."));
        long MinInt = Input.ArrayValue.get(0).IntValue;
        MaxInt = Input.ArrayValue.get(1).IntValue;
        return new LooFDataValue (MinInt + (int) (Math.random() * ((MaxInt - MinInt) + 1)));
      
      default:
        throw (new LooFInterpreterException (Environment, "the evaluator function randomInt can only take an int or a table of two ints, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
      
    }
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_Chance = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (!(Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the evaluator function chance can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    double ChanceLimit = GetDataValueNumber (Input);
    if (ChanceLimit < 0 || ChanceLimit > 100) throw (new LooFInterpreterException (Environment, "the evaluator function chance can only take a number from 0 to 100 (inclusive)."));
    
    return new LooFDataValue (Math.random() < ChanceLimit / 100);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_LengthOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Table):
        return new LooFDataValue (Input.ArrayValue.size());
      
      case (DataValueType_String):
        return new LooFDataValue (Input.StringValue.length());
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (Input.ByteArrayValue.length);
      
      default:
        throw (new LooFInterpreterException (Environment, "the evaluator function lengthOf can only take a table, string, or byteArray, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
      
    }
  }
};





LooFEvaluatorFunction Function_TotalItemsIn = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function totalItemsIn can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    return new LooFDataValue (Input.ArrayValue.size() + Input.HashMapValue.size());
    
  }
};





LooFEvaluatorFunction Function_EndOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Table):
        return new LooFDataValue (Input.ArrayValue.size() - 1);
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (Input.ByteArrayValue.length - 1);
      
      default:
        throw (new LooFInterpreterException (Environment, "the evaluator function endOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
      
    }
  }
};





LooFEvaluatorFunction Function_KeysOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function keysOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <String> InputKeys = Input.HashMapValue.keySet();
    ArrayList <LooFDataValue> KeysList = new ArrayList <LooFDataValue> ();
    KeysList.ensureCapacity (InputKeys.size());
    for (String CurrentKey : InputKeys) {
      KeysList.add(new LooFDataValue (CurrentKey));
    }
    
    return new LooFDataValue (KeysList, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_ValuesOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function valuesOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <LooFDataValue> InputValues = Input.HashMapValue.values();
    ArrayList <LooFDataValue> ValuesList = new ArrayList <LooFDataValue> ();
    ValuesList.ensureCapacity (InputValues.size());
    for (LooFDataValue CurrentValue : InputValues) {
      ValuesList.add(CurrentValue);
    }
    
    return new LooFDataValue (ValuesList, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_RandomItem = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function randomItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    ArrayList <LooFDataValue> ArrayValue = Input.ArrayValue;
    if (ArrayValue.size() == 0) return new LooFDataValue();
    return ArrayValue.get((int) (Math.random() * ArrayValue.size()));
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_RandomValue = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function randomValue can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <LooFDataValue> HashMapValues = Input.HashMapValue.values();
    return GetRandomItemFromCollection (HashMapValues);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_GetChar = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function getChar can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> Args = Input.ArrayValue;
    if (Args.size() != 2) throw (new LooFInterpreterException (Environment, "the evaluator function getChar can only take two arguments."));
    LooFDataValue StringDataValue = Args.get(0);
    LooFDataValue IndexDataValue = Args.get(1);
    if (StringDataValue.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the evaluator function getChar takes a string as its first argument, not " + DataValueTypeNames_PlusA[StringDataValue.ValueType] + "."));
    if (IndexDataValue.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "the evaluator function getChar takes an int as its second argument, not " + DataValueTypeNames_PlusA[IndexDataValue.ValueType] + "."));
    
    String StringIn = StringDataValue.StringValue;
    long Index = IndexDataValue.IntValue;
    char CharOut = StringIn.charAt((int) CorrectModulo (Index, StringIn.length()));
    return new LooFDataValue ((long) CharOut);
    
  }
};





LooFEvaluatorFunction Function_GetCharInts = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    if (Input.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the evaluator function getChars can only take a string, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    String StringIn = Input.StringValue;
    char[] InputChars = new char [StringIn.length()];
    
    StringIn.getChars (0, InputChars.length - 1, InputChars, 0);
    
    ArrayList <LooFDataValue> InputCharValues = new ArrayList <LooFDataValue> ();
    for (char CurrChar : InputChars) {
      InputCharValues.add (new LooFDataValue ((long) CurrChar));
    }
    
    return new LooFDataValue (InputCharValues, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_GetCharBytes = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    if (Input.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the evaluator function getCharBytes can only take a string, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    String StringIn = Input.StringValue;
    char[] InputChars = new char [StringIn.length()];
    
    StringIn.getChars (0, InputChars.length - 1, InputChars, 0);
    
    ArrayList <LooFDataValue> InputCharValues = new ArrayList <LooFDataValue> ();
    for (char CurrChar : InputChars) {
      InputCharValues.add (new LooFDataValue ((long) CurrChar));
    }
    
    return new LooFDataValue (InputCharValues, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_GetSubString = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the evaluator function getSubString can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> Args = Input.ArrayValue;
    if (Args.size() != 3) throw (new LooFInterpreterException (Environment, "the evaluator function getSubString can only take three arguments."));
    LooFDataValue StringDataValue = Args.get(0);
    LooFDataValue StartIndexDataValue = Args.get(1);
    LooFDataValue EndIndexDataValue = Args.get(2);
    if (StringDataValue.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the evaluator function getSubString takes a string as its first argument, not " + DataValueTypeNames_PlusA[StringDataValue.ValueType] + "."));
    if (StartIndexDataValue.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "the evaluator function getSubString takes an int as its second argument, not " + DataValueTypeNames_PlusA[StartIndexDataValue.ValueType] + "."));
    if (EndIndexDataValue.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, "the evaluator function getSubString takes an int as its third argument, not " + DataValueTypeNames_PlusA[EndIndexDataValue.ValueType] + "."));
    
    String StringIn = StringDataValue.StringValue;
    long StartIndex = StartIndexDataValue.IntValue;
    long EndIndex = EndIndexDataValue.IntValue;
    int StringInLength = StringIn.length();
    
    StartIndex = CorrectModulo (StartIndex, StringInLength);
    EndIndex = CorrectModulo (EndIndex, StringInLength);
    
    return new LooFDataValue (StringIn.substring((int) StartIndex, (int) EndIndex));
    
  }
};





LooFEvaluatorFunction Function_ToInt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        throw (new LooFInterpreterException (Environment, "cannot cast null to int."));
      
      case (DataValueType_Int):
        return new LooFDataValue (Input.IntValue);
      
      case (DataValueType_Float):
        return new LooFDataValue ((long) Math.floor (Input.FloatValue));
      
      case (DataValueType_String):
        try {
          return new LooFDataValue (Long.parseLong(Input.StringValue));
        } catch (NumberFormatException e) {
          throw (new LooFInterpreterException (Environment, "cannot cast string \"" + Input.StringValue + "\" to a number."));
        }
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? (long) 1 : (long) 0);
      
      case (DataValueType_Table):
        throw (new LooFInterpreterException (Environment, "cannot cast table to int."));
      
      case (DataValueType_ByteArray):
        throw (new LooFInterpreterException (Environment, "cannot cast byteArray to int."));
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToFloat = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        throw (new LooFInterpreterException (Environment, "cannot cast null to float."));
      
      case (DataValueType_Int):
        return new LooFDataValue ((double) Input.IntValue);
      
      case (DataValueType_Float):
        return new LooFDataValue (Input.FloatValue);
      
      case (DataValueType_String):
        try {
          return new LooFDataValue (Double.parseDouble(Input.StringValue));
        } catch (NumberFormatException e) {
          throw (new LooFInterpreterException (Environment, "cannot cast string \"" + Input.StringValue + "\" to a float."));
        }
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? (double) 1.0 :  (double) 0.0);
      
      case (DataValueType_Table):
        throw (new LooFInterpreterException (Environment, "cannot cast table to float."));
      
      case (DataValueType_ByteArray):
        throw (new LooFInterpreterException (Environment, "cannot cast byteArray to float."));
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToString = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue ("null");
      
      case (DataValueType_Int):
        return new LooFDataValue (Input.IntValue + "");
      
      case (DataValueType_Float):
        return new LooFDataValue (Input.FloatValue + "");
      
      case (DataValueType_String):
        return new LooFDataValue (Input.StringValue);
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? "true" : "false");
      
      case (DataValueType_Table):
        return new LooFDataValue (ConvertLooFDataValueToString (Input));
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (new String (Input.ByteArrayValue));
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToBool = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue (false);
      
      case (DataValueType_Int):
        return new LooFDataValue (Input.IntValue > 0);
      
      case (DataValueType_Float):
        return new LooFDataValue (Input.FloatValue > 0);
      
      case (DataValueType_String):
        return new LooFDataValue (Input.StringValue.length() > 0);
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue);
      
      case (DataValueType_Table):
        return new LooFDataValue (Input.ArrayValue.size() > 0);
      
      case (DataValueType_ByteArray):
        throw (new LooFInterpreterException (Environment, "cannot cast byteArray to bool."));
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_TypeOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment) {
    return new LooFDataValue (DataValueTypeNames[Input.ValueType]);
  }
};
