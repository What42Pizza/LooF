LooFEvaluatorOperation Operation_Add = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue + RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) + GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"+\" can only add ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Subtract = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue - RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) - GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"-\" can only subtract ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Multiply = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue * RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) * GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"+\" can only multiply ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Divide = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      if (RightValue.IntValue == 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot divide by 0."));
      long NewIntValue = LeftValue.IntValue / RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      double RightFloatValue = GetDataValueNumber (RightValue);
      if (RightFloatValue == 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot divide by 0."));
      return new LooFDataValue (GetDataValueNumber (LeftValue) / RightFloatValue);
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"+\" can only divide ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Power = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = (long) Math.pow (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (Math.pow (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"^\" can only take an int or float to the power of an int or float, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " to the power of " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Modulo = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = CorrectModulo (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (CorrectModulo (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"%\" can only modulo ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Concat = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
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
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"..\" can only concatenate two strings or two tables, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_Equals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    switch (LeftValue.ValueType) {
      
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "INTERNAL ERROR: unkown LooFDataValue ValueType " + LeftValue.ValueType + "."));
      
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
      
    }
  }
};





LooFEvaluatorOperation Operation_StrictEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    return new LooFDataValue (LeftValue.equals(RightValue));
  };
};





LooFEvaluatorOperation Operation_GreaterThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) > GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \">\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_LessThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) < GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"<\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_NotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    switch (LeftValue.ValueType) {
      
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "INTERNAL ERROR: unkown LooFDataValue ValueType " + LeftValue.ValueType + "."));
      
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
      
    }
  }
};





LooFEvaluatorOperation Operation_StrictNotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    return new LooFDataValue (!LeftValue.equals(RightValue));
  };
};





LooFEvaluatorOperation Operation_GreaterThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) >= GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \">=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_LessThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if ((LeftValue.ValueType == DataValueType_Float || LeftValue.ValueType == DataValueType_Int) && (RightValue.ValueType == DataValueType_Float || RightValue.ValueType == DataValueType_Int)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) <= GetDataValueNumber (RightValue));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the operation \"<=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[LeftValue.ValueType] + "."));
    
  }
};





LooFEvaluatorOperation Operation_And = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    LooFDataValue LeftValueAsBool = Function_toBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment, FileName, LineNumber);
    return (LeftValueAsBool.BoolValue) ? RightValue : new LooFDataValue (false);
  }
};





LooFEvaluatorOperation Operation_Or = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    LooFDataValue LeftValueAsBool = Function_toBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment, FileName, LineNumber);
    return (LeftValueAsBool.BoolValue) ? LeftValue : RightValue;
  }
};





LooFEvaluatorOperation Operation_Xor = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, String FileName, int LineNumber) {
    LooFDataValue LeftValueAsBool = Function_toBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {LeftValue}), Environment, FileName, LineNumber);
    LooFDataValue RightValueAsBool = Function_toBool.HandleFunctionCall (new LooFDataValue (new LooFDataValue[] {RightValue}), Environment, FileName, LineNumber);
    return new LooFDataValue (LeftValueAsBool.BoolValue ^ RightValueAsBool.BoolValue);
  }
};










LooFEvaluatorFunction Function_round = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.round(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function round can only round an int or a floats not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_floor = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.floor(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function floor can only round an int or a floats not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_ceil = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.ceil(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function ceil can only round an int or a floats not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_sqrt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.sqrt(GetDataValueNumber (Input)));
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function sqrt can only take an int or a floats not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_not = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    LooFDataValue InputAsBool = Function_toBool.HandleFunctionCall (Input, Environment, FileName, LineNumber);
    InputAsBool.BoolValue = !InputAsBool.BoolValue;
    
    return InputAsBool;
    
  }
};





LooFEvaluatorFunction Function_min = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function min can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> InputItems = GetAllDataValueTableItems (Input);
    if (InputItems.size() == 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function min cannot be called with an empty table."));
    int InputItemsSize = InputItems.size();
    
    LooFDataValue FirstItem = InputItems.get(0);
    if (!(FirstItem.ValueType == DataValueType_Int || FirstItem.ValueType != DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function min cannot be called with a table containing a non-number value."));
    double MinValue = GetDataValueNumber (FirstItem);
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      if (!(CurrentItem.ValueType == DataValueType_Int || CurrentItem.ValueType != DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function min cannot be called with a table containing a non-number value."));
      MinValue = Math.min (MinValue, GetDataValueNumber (CurrentItem));
    }
    
    return new LooFDataValue (MinValue);
    
  }
};





LooFEvaluatorFunction Function_max = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function max can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    ArrayList <LooFDataValue> InputItems = GetAllDataValueTableItems (Input);
    if (InputItems.size() == 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function max cannot be called with an empty table."));
    int InputItemsSize = InputItems.size();
    
    LooFDataValue FirstItem = InputItems.get(0);
    if (!(FirstItem.ValueType == DataValueType_Int || FirstItem.ValueType != DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function max cannot be called with a table containing a non-number value."));
    double MinValue = GetDataValueNumber (FirstItem);
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      if (!(CurrentItem.ValueType == DataValueType_Int || CurrentItem.ValueType != DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function max cannot be called with a table containing a non-number value."));
      MinValue = Math.max (MinValue, GetDataValueNumber (CurrentItem));
    }
    
    return new LooFDataValue (MinValue);
    
  }
};





LooFEvaluatorFunction Function_random = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (!(Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function random can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    double MaxValue = GetDataValueNumber (Input);
    
    return new LooFDataValue (Math.random() * MaxValue);
    
  }
};





LooFEvaluatorFunction Function_randomInt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Int) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function randomInt can only take an int, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    long MaxInt = Input.IntValue;
    
    return new LooFDataValue ((int) (Math.random() * (MaxInt + 1)));
    
  }
};





LooFEvaluatorFunction Function_chance = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (!(Input.ValueType == DataValueType_Int || Input.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function chance can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    double ChanceLimit = GetDataValueNumber (Input);
    if (ChanceLimit < 0 || ChanceLimit > 100) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function chance can only take a number from 0 to 100 (inclusive)."));
    
    return new LooFDataValue (Math.random() < ChanceLimit / 100);
    
  }
};





LooFEvaluatorFunction Function_typeOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    return new LooFDataValue (DataValueTypeNames[Input.ValueType]);
  }
};





LooFEvaluatorFunction Function_lengthOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType == DataValueType_String) {
      return new LooFDataValue (Input.StringValue.length());
    }
    
    if (Input.ValueType == DataValueType_Table) {
      return new LooFDataValue (Input.ArrayValue.size());
    }
    
    throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function lengthOf can only take a string or table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
  }
};





LooFEvaluatorFunction Function_totalItemsIn = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function totalItemsIn can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    return new LooFDataValue (Input.ArrayValue.size() + Input.HashMapValue.size());
    
  }
};





LooFEvaluatorFunction Function_endOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function endOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    return new LooFDataValue (Input.ArrayValue.size() - 1);
    
  }
};





LooFEvaluatorFunction Function_keysOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function keysOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <String> InputKeys = Input.HashMapValue.keySet();
    ArrayList <LooFDataValue> KeysList = new ArrayList <LooFDataValue> ();
    KeysList.ensureCapacity (InputKeys.size());
    for (String CurrentKey : InputKeys) {
      KeysList.add(new LooFDataValue (CurrentKey));
    }
    
    return new LooFDataValue (KeysList, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_valuesOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function valuesOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <LooFDataValue> InputValues = Input.HashMapValue.values();
    ArrayList <LooFDataValue> ValuesList = new ArrayList <LooFDataValue> ();
    ValuesList.ensureCapacity (InputValues.size());
    for (LooFDataValue CurrentValue : InputValues) {
      ValuesList.add(CurrentValue);
    }
    
    return new LooFDataValue (ValuesList, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_randomItem = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function randomItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    ArrayList <LooFDataValue> ArrayValue = Input.ArrayValue;
    
    if (ArrayValue.size() == 0) return new LooFDataValue();
    
    return ArrayValue.get((int) (Math.random() * ArrayValue.size()));
    
  }
};





LooFEvaluatorFunction Function_randomValue = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    if (Input.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "the function randomValue can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + "."));
    
    Collection <LooFDataValue> HashMapValues = Input.HashMapValue.values();
    
    return GetRandomItemFromCollection (HashMapValues);
    
  }
};





LooFEvaluatorFunction Function_toBool = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, String FileName, int LineNumber) {
    switch (Input.ValueType) {
      
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "INTERNAL ERROR: unkown LooFDataValue ValueType " + Input.ValueType + "."));
      
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
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot cast byteArray to bool."));
      
    }
  }
};
