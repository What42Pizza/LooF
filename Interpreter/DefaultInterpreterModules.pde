LooFInterpreterModule InterpreterModule_Console = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Console module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("print"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"print\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        
        LooFDataValue ValuesToPrintTable = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        if (ValuesToPrintTable.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the message \"print\" must take a table as its first arg, but the first arg was of type " + DataValueTypeNames[ValuesToPrintTable.ValueType] + ".", new String[] {"InvalidArgsLength"}));
        ArrayList <LooFDataValue> ValuesToPrintArray = ValuesToPrintTable.ArrayValue;
        
        if (ValuesToPrintArray.size() == 0) throw (new LooFInterpreterException (Environment, "the message \"print\" cannot take an empty table as its first arg.", new String[] {"InvalidArgsLength"}));
        
        String ToPrint = Function_ToString.HandleFunctionCall(ValuesToPrintArray.get(0), Environment, null, null).StringValue;
        for (int i = 1; i < ValuesToPrintArray.size(); i ++) {
          ToPrint += " " + Function_ToString.HandleFunctionCall(ValuesToPrintArray.get(i), Environment, null, null).StringValue;
        }
        print (ToPrint);
        
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};










LooFInterpreterModule InterpreterModule_Interpreter = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFInterpreterModuleData ModuleData = (LooFInterpreterModuleData) ModuleDataIn;
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Interpreter module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("stop"): {
        if (Args.length > 1) throw (new LooFInterpreterException (Environment, "the message \"stop\" cannot take any extra arguments.", new String[] {"InvalidArgsLength"}));
        Environment.IsStopped = true;
      return;}
      
      
      
      case ("pause"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"pause\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue PauseTimeValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        PauseTimeValue.IntValue *= 1000; PauseTimeValue.FloatValue *= 1000;
        Result <Long> PauseTimeLongResult = GetDataValueInt (PauseTimeValue);
        if (PauseTimeLongResult.Err) throw (new LooFInterpreterException (Environment, "the message \"pause\" must take an int or float as its first arg, but the first arg was of type " + DataValueTypeNames[PauseTimeValue.ValueType] + ".", new String[] {"InvalidArgType"}));
        long PauseTimeLong = PauseTimeLongResult.Some;
        Environment.IsPaused = true;
        Environment.PauseEndMillis = System.currentTimeMillis() + PauseTimeLong;
      return;}
      
      
      
      case ("pause until"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"pause\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue PauseEndTimeValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        PauseEndTimeValue.IntValue *= 1000; PauseEndTimeValue.FloatValue *= 1000;
        Result <Long> PauseEndTimeLongResult = GetDataValueInt (PauseEndTimeValue);
        if (PauseEndTimeLongResult.Err) throw (new LooFInterpreterException (Environment, "the message \"pause\" must take an int or float as its first arg, but the first arg was of type " + DataValueTypeNames[PauseEndTimeValue.ValueType] + ".", new String[] {"InvalidArgType"}));
        long PauseEndTimeLong = PauseEndTimeLongResult.Some;
        Environment.IsPaused = true;
        Environment.PauseEndMillis = ModuleData.StartMillis + PauseEndTimeLong;
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
  @Override
  public LooFModuleData CreateModuleData() {
    long StartTime = System.currentTimeMillis();
    return new LooFInterpreterModuleData (StartTime);
  }
  
};



class LooFInterpreterModuleData extends LooFModuleData {
  
  long StartMillis;
  
  public LooFInterpreterModuleData (long StartMillis) {
    this.StartMillis = StartMillis;
  }
  
}










LooFInterpreterModule InterpreterModule_Files = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Files module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      
      
      case ("get program path"): {
        String ProgramFilePath = Environment.ProgramFilePath;
        String[] ProgramFilePathArray = ProgramFilePath.split("\\\\");
        ArrayList <LooFDataValue> ProgramFilePathValues = new ArrayList <LooFDataValue> ();
        for (String CurrentString : ProgramFilePathArray) {
          ProgramFilePathValues.add(new LooFDataValue (CurrentString));
        }
        LooFDataValue TableToPush = new LooFDataValue (ProgramFilePathValues, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
      return;}
      
      
      
      
      
      case ("get file properties"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"get file properties\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some.Value1;
        
        HashMap <String, LooFDataValue> TableToPushItems = new HashMap <String, LooFDataValue> ();
        try {
          
          boolean Exists = FileToRead.exists();
          if (!Exists) {
            TableToPushItems.put("Exists", new LooFDataValue (false));
            LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
            LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
            return;
          }
          
          long Size = FileToRead.length(); // this seems like a janky way to do this, but I'm pretty sure it's the intended way
          boolean IsFolder = FileToRead.isDirectory();
          long LastModified = FileToRead.lastModified();
          boolean CanRead = FileToRead.canRead();
          boolean CanWrite = FileToRead.canWrite();
          
          TableToPushItems.put("Size"        , new LooFDataValue (Size        ));
          TableToPushItems.put("IsFolder"    , new LooFDataValue (IsFolder    ));
          TableToPushItems.put("IsFile"      , new LooFDataValue (!IsFolder   ));
          TableToPushItems.put("LastModified", new LooFDataValue (LastModified));
          TableToPushItems.put("CanRead"     , new LooFDataValue (CanRead     ));
          TableToPushItems.put("CanWrite"    , new LooFDataValue (CanWrite    ));
          LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
          LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
          
        } catch (SecurityException e) {
          throw (new LooFInterpreterException (Environment, "SecurityException while reading file data: " + e.toString(), new String[] {"FileReadError"}));
        }
        
      return;}
      
      
      
      
      
      case ("check file exists"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"check file exists\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"check file exists\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"check file exists\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"check file exists\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some.Value1;
        
        boolean FileExists = FileToRead.exists();
        
        ArrayList <LooFDataValue> TableToPushItems = new ArrayList <LooFDataValue> ();
        TableToPushItems.add(new LooFDataValue (FileExists));
        LooFDataValue TableToPush = new LooFDataValue (TableToPushItems, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      
      
      case ("get files in dir"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"get files in dir\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FolderToListResult = GetFileFromDataValue (FileToReadValue);
        if (FolderToListResult.Err) {
          switch (FolderToListResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"get files in dir\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"get files in dir\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"get files in dir\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FolderToListResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FolderToList = FolderToListResult.Some.Value1;
        
        boolean FolderExists = FolderToList.exists();
        if (!FolderExists) throw (new LooFInterpreterException (Environment, "could not find the file at " + FolderToListResult.Some.Value2 + ".", new String[] {"FileNotFound", "FileReadError"}));
        if (!FolderToList.isDirectory()) throw (new LooFInterpreterException (Environment, "the path at " + FolderToListResult.Some.Value2 + " is not a folder.", new String[] {"FileNotFound", "FileReadError"}));
        
        String[] FolderContents = FolderToList.list();
        ArrayList <LooFDataValue> FolderContentsValues = new ArrayList <LooFDataValue> ();
        for (String CurrentString : FolderContents) {
          FolderContentsValues.add(new LooFDataValue (CurrentString));
        }
        LooFDataValue TableToPush = new LooFDataValue (FolderContentsValues, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      
      
      case ("read file as strings"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"read file as strings\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"read file as strings\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"read file as strings\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"read file as strings\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some.Value1;
        
        boolean FileExists = FileToRead.exists();
        if (!FileExists) throw (new LooFInterpreterException (Environment, "could not find the file at " + FileToReadResult.Some.Value2 + ".", new String[] {"FileNotFound", "FileReadError"}));
        if (!FileToRead.isFile()) throw (new LooFInterpreterException (Environment, "the path at " + FileToReadResult.Some.Value2 + " is not a file.", new String[] {"FileNotFound", "FileReadError"}));
        
        String[] FileContents;
        try {
          FileContents = ReadFileAsStrings (FileToRead);
        } catch (IOException e) {
          throw (new LooFInterpreterException (Environment, "IOException while reading file data: " + e.toString(), new String[] {"FileReadError"}));
        }
        
        ArrayList <LooFDataValue> FileContentsValues = new ArrayList <LooFDataValue> ();
        for (String CurrentString : FileContents) {
          FileContentsValues.add(new LooFDataValue (CurrentString));
        }
        LooFDataValue TableToPush = new LooFDataValue (FileContentsValues, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      
      
      case ("read file as byteArray"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"read file as byteArray\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"read file as byteArray\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"read file as byteArray\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"read file as byteArray\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some.Value1;
        
        boolean FileExists = FileToRead.exists();
        if (!FileExists) throw (new LooFInterpreterException (Environment, "could not find the file at " + FileToReadResult.Some.Value2 + ".", new String[] {"FileNotFound", "FileReadError"}));
        if (!FileToRead.isFile()) throw (new LooFInterpreterException (Environment, "the path at " + FileToReadResult.Some.Value2 + " is not a file.", new String[] {"FileNotFound", "FileReadError"}));
        
        byte[] FileContents;
        try {
          FileContents = Files.readAllBytes(FileToRead.toPath());
        } catch (IOException e) {
          throw (new LooFInterpreterException (Environment, "IOException while reading file data: " + e.toString(), new String[] {"FileReadError"}));
        }
        
        LooFDataValue ByteArrayToPush = new LooFDataValue (FileContents);
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {ByteArrayToPush}, Environment);
        
      return;}
      
      
      
      
      
      case ("load image"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"load image\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"load image\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"load image\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"load image\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some.Value1;
        
        boolean FileExists = FileToRead.exists();
        if (!FileExists) throw (new LooFInterpreterException (Environment, "could not find the file at " + FileToReadResult.Some.Value2 + ".", new String[] {"FileNotFound", "FileReadError"}));
        if (!FileToRead.isFile()) throw (new LooFInterpreterException (Environment, "the path at " + FileToReadResult.Some.Value2 + " is not a file.", new String[] {"FileNotFound", "FileReadError"}));
        
        String FileExtention = GetFileExtention (FileToRead.getName());
        switch (FileExtention) {
          case ("png"):
          case ("jpeg"):
          case ("bmp"):
          case ("wbmp"):
          case ("gif"):
            break;
          default:
            throw (new LooFInterpreterException (Environment, "cannot load image of type \"" + FileExtention + "\".", new String[] {"InvalidFileType", "FileReadError"}));
        }
        
        BufferedImage ImageIn;
        try {
          ImageIn = ImageIO.read(FileToRead);
        } catch (IOException e) {
          throw (new LooFInterpreterException (Environment, "error while reading file data: " + e.toString(), new String[] {"FileReadError"}));
        }
        
        byte[] ImageInPixels = ((DataBufferByte) ImageIn.getRaster().getDataBuffer()).getData(); // from StackOverflow: https://stackoverflow.com/a/29280741/13325385
        byte[] ImageInData = new byte [ImageInPixels.length + 4];
        int ImageInWidth = ImageIn.getWidth();
        int ImageInHeight = ImageIn.getHeight();
        ImageInData[0] = (byte) ( ImageInWidth  & 0xFF  );
        ImageInData[1] = (byte) ((ImageInWidth  & 0xFF00) >> 8);
        ImageInData[2] = (byte) ( ImageInHeight & 0xFF  );
        ImageInData[3] = (byte) ((ImageInHeight & 0xFF00) >> 8);
        System.arraycopy(ImageInPixels, 0, ImageInData, 4, ImageInPixels.length);
        
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {new LooFDataValue (ImageInData)}, Environment);
        
      return;}
      
      
      
      
      
      case ("write to file"): {
        if (Args.length != 3) throw (new LooFInterpreterException (Environment, "the message \"write to file\" can only take 2 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <String> FileNameResult = GetFileNameFromDataValue (FileToReadValue);
        if (FileNameResult.Err) {
          switch (FileNameResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"write to file\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"write to file\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"write to file\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not write file: " + FileNameResult.ErrCause, new String[] {"FileWriteError"}));
          }
        }
        String FileName = FileNameResult.Some;
        
        // convert value to bytes
        byte[] BytesToWrite = null;
        LooFDataValue ValueToWrite = LooFInterpreter.EvaluateFormula (Args[2], Environment, null, null);
        switch (ValueToWrite.ValueType) {
          
          case (DataValueType_Table):
            
            // get strings
            Result <String[]> TableStringsResult = GetStringArrayFromDataValue (ValueToWrite);
            if (TableStringsResult.Err) throw (new LooFInterpreterException (Environment, "the message \"write to file\" cannot take a table with non-string items as its second arg.", new String[] {"InvalidArgType"}));
            String[] TableStrings = TableStringsResult.Some;
            
            // get string bytes
            byte[][] TableStringBytes = new byte [TableStrings.length] [];
            int TotalBytesSize = 0;
            for (int i = 0; i < TableStrings.length; i ++) {
              byte[] CurrentStringBytes = (TableStrings[i] + '\n').getBytes();
              TableStringBytes[i] = CurrentStringBytes;
              TotalBytesSize += CurrentStringBytes.length;
            }
            
            // put bytes in BytesToWrite
            BytesToWrite = new byte [TotalBytesSize];
            int Index = 0;
            for (int i = 0; i < TableStringBytes.length; i ++) {
              byte[] CurrentBytes = TableStringBytes[i];
              for (int j = 0; j < CurrentBytes.length; j ++) {
                BytesToWrite[Index + j] = CurrentBytes[j];
              }
              Index += CurrentBytes.length;
            }
            
            break;
          
          case (DataValueType_ByteArray):
            BytesToWrite = ValueToWrite.ByteArrayValue;
            break;
          
          default:
            throw (new LooFInterpreterException (Environment, "the message \"write to file\" must take a table of strings or a byte array as its second arg, but the arg was of type " + DataValueTypeNames[ValueToWrite.ValueType] + ".", new String[] {"InvalidArgType"}));
          
        }
        
        try {
          EnsureFoldersExist (FileName);
          Files.write(Paths.get(FileName), BytesToWrite);
        } catch (IOException e) {
          throw (new LooFInterpreterException (Environment, "error while writing file data: " + e.toString(), new String[] {"FileWriteError"}));
        }
        
      return;}
      
      
      
      
      
      case ("save image"): {
        if (Args.length != 3) throw (new LooFInterpreterException (Environment, "the message \"save image\" can only take 2 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <String> FileNameResult = GetFileNameFromDataValue (FileToReadValue);
        if (FileNameResult.Err) {
          switch (FileNameResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"save image\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"save image\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"save image\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not write file: " + FileNameResult.ErrCause, new String[] {"FileWriteError"}));
          }
        }
        String FileName = FileNameResult.Some;
        
        String FileExtention = GetFileExtention (FileName);
        switch (FileExtention) {
          case ("png"):
          case ("jpeg"):
          case ("bmp"):
          case ("wbmp"):
          case ("gif"):
            break;
          default:
            throw (new LooFInterpreterException (Environment, "cannot load image of type \"" + FileExtention + "\".", new String[] {"InvalidFileType", "FileWriteError"}));
        }
        
        LooFDataValue ImageOutValue = LooFInterpreter.EvaluateFormula (Args[2], Environment, null, null);
        if (ImageOutValue.ValueType != DataValueType_ByteArray) throw (new LooFInterpreterException (Environment, "", new String[] {"InvalidArgType"}));
        byte[] ImageOutData = ImageOutValue.ByteArrayValue;
        
        byte[] ImageOutPixels = new byte [ImageOutData.length - 4];
        System.arraycopy(ImageOutData, 4, ImageOutPixels, 0, ImageOutPixels.length);
        int ImageOutWidth = ByteToInt (ImageOutData[0]) + (ByteToInt (ImageOutData[1]) << 8);
        int ImageOutHeight = ByteToInt (ImageOutData[2]) + (ByteToInt (ImageOutData[3]) << 8);
        if (ImageOutData.length != ImageOutWidth * ImageOutHeight * 4 + 4) throw (new LooFInterpreterException (Environment, "incorrect byteArray length for image to save. Detected width: " + ImageOutWidth + ", detected height: " + ImageOutHeight + ", expected byteArray size: " + (ImageOutWidth * ImageOutHeight * 4 + 4) + ", given byteArray size: " + ImageOutData.length + ".", new String[] {"InvalidImageData"}));
        
        BufferedImage ImageOut = new BufferedImage(ImageOutWidth, ImageOutHeight, BufferedImage.TYPE_4BYTE_ABGR); // from StackOverflow: https://stackoverflow.com/a/29428561/13325385
        ImageOut.setData(Raster.createRaster(ImageOut.getSampleModel(), new DataBufferByte(ImageOutPixels, ImageOutPixels.length), new Point()));
        try {
          EnsureFoldersExist (FileName);
          ImageIO.write(ImageOut, FileExtention, new File (FileName));
        } catch (IOException e) {
          throw (new LooFInterpreterException (Environment, "error while reading file data: " + e.toString(), new String[] {"FileReadError"}));
        }
        
      return;}
      
      
      
      
      
      case ("delete file"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"delete file\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <Tuple2 <File, String>> FileToDeleteResult = GetFileFromDataValue (FileToReadValue);
        if (FileToDeleteResult.Err) {
          switch (FileToDeleteResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"delete file\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"delete file\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"delete file\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToDeleteResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToDelete = FileToDeleteResult.Some.Value1;
        
        if (!FileToDelete.exists()) throw (new LooFInterpreterException (Environment, "could not find the file at " + FileToDeleteResult.Some.Value2 + ".", new String[] {"FileNotFound", "FileReadError"}));
        FileToDelete.delete();
        
      return;}
      
      
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};





Result <String> GetFileNameFromDataValue (LooFDataValue DataValueIn) {
  switch (DataValueIn.ValueType) {
    
    case (DataValueType_String): {
      String FileName = DataValueIn.StringValue;
      return new Result (FileName);
    }
    
    case (DataValueType_Table): {
      if (DataValueIn.ArrayValue.size() == 0) return (new Result()).SetErrCause("EmptyTable");
      Result <String[]> PathArrayResult = GetStringArrayFromDataValue (DataValueIn);
      if (PathArrayResult.Err) return (new Result()).SetErrCause("NonStringItem");
      String[] PathArray = PathArrayResult.Some;
      String FileName = CombineStringsWithSeperator (PathArray, "/");
      return new Result (FileName);
    }
    
    default: {
      return (new Result()).SetErrCause("InvalidArgType");
    }
    
  }
}



Result <Tuple2 <File, String>> GetFileFromDataValue (LooFDataValue DataValueIn) {
  Result <String> FileNameResult = GetFileNameFromDataValue (DataValueIn);
  if (FileNameResult.Err) return (new Result()).SetErrCause(FileNameResult.ErrCause);
  String FileName = FileNameResult.Some;
  Tuple2 Output = new Tuple2 (new File (FileName), FileName);
  return new Result (Output);
}



void EnsureFoldersExist (String FileName) {
  FileName = FileName.substring(0, FileName.lastIndexOf('/'));
  File TempFile = new File (FileName);
  TempFile.mkdirs();
}










LooFInterpreterModule InterpreterModule_Graphics = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Graphics module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("set frame"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"set frame\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        
        LooFDataValue ValuesToPrintTable = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        if (ValuesToPrintTable.ValueType != DataValueType_ByteArray) throw (new LooFInterpreterException (Environment, "the message \"set frame\" must take a byteArray as its first arg, but the first arg was of type " + DataValueTypeNames[ValuesToPrintTable.ValueType] + ".", new String[] {"InvalidArgsLength"}));
        byte[] NewFrameData = ValuesToPrintTable.ByteArrayValue;
        
        int NewFrameWidth = ByteToInt (NewFrameData[0]) + (ByteToInt (NewFrameData[1]) << 8);
        int NewFrameHeight = ByteToInt (NewFrameData[2]) + (ByteToInt (NewFrameData[3]) << 8);
        if (NewFrameData.length != NewFrameWidth * NewFrameHeight * 4 + 4) throw (new LooFInterpreterException (Environment, "incorrect byteArray length for new frame. Detected width: " + NewFrameWidth + ", detected height: " + NewFrameHeight + ", expected byteArray size: " + (NewFrameWidth * NewFrameHeight * 4 + 4) + ", given byteArray size: " + NewFrameData.length + ".", new String[] {"InvalidImageData"}));
        if (NewFrameWidth != width) throw (new LooFInterpreterException (Environment, "incorrect image width for new frame. Image width: " + NewFrameWidth + ", required width: " + width + ".", new String[] {"InvalidFrame"}));
        if (NewFrameHeight != height) throw (new LooFInterpreterException (Environment, "incorrect image height for new frame. Image height: " + NewFrameHeight + ", required height: " + height + ".", new String[] {"InvalidFrame"}));
        
        pixels = new color [width * height];
        int NewFrameIndex = 4;
        for (int i = 0; i < pixels.length; i ++) {
          byte Blue  = NewFrameData[NewFrameIndex + 1];
          byte Green = NewFrameData[NewFrameIndex + 2];
          byte Red   = NewFrameData[NewFrameIndex + 3];
          int CurrentPixel = Red + (Green << 8) + (Blue << 16) + (0xFF000000);
          pixels[i] = CurrentPixel;
          NewFrameIndex += 4;
        }
        
        g.pixels = pixels;
        updatePixels();
        
      return;}
      
      
      
      
      
      case ("get properties"): {
        if (Args.length != 1) throw (new LooFInterpreterException (Environment, "the message \"get properties\" does not take any arguments.", new String[] {"InvalidArgsLength"}));
        
        HashMap <String, LooFDataValue> TableToPushItems = new HashMap <String, LooFDataValue> ();
        TableToPushItems.put("Width"         , new LooFDataValue (width          ));
        TableToPushItems.put("Height"        , new LooFDataValue (height         ));
        TableToPushItems.put("IsWindow"      , new LooFDataValue (Windowed       ));
        TableToPushItems.put("TargetFramrate", new LooFDataValue (TargetFramerate));
        
        LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};










LooFInterpreterModule InterpreterModule_Input = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    LooFInputModuleData ModuleData = (LooFInputModuleData) ModuleDataIn;
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Input module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("get mouse data"): {
        if (Args.length != 1) throw (new LooFInterpreterException (Environment, "the message \"get mouse data\" does not take any arguments.", new String[] {"InvalidArgsLength"}));
        
        Point MousePosition = MouseInfo.getPointerInfo().getLocation();
        int AbsoluteMouseX = (int) MousePosition.getX();
        int AbsoluteMouseY = (int) MousePosition.getY();
        
        HashMap <String, LooFDataValue> TableToPushItems = new HashMap <String, LooFDataValue> ();
        TableToPushItems.put("XPos"        , new LooFDataValue (mouseX        ));
        TableToPushItems.put("YPos"        , new LooFDataValue (mouseY        ));
        TableToPushItems.put("AbsoluteXPos", new LooFDataValue (AbsoluteMouseX));
        TableToPushItems.put("AbsoluteYPos", new LooFDataValue (AbsoluteMouseY));
        
        LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      case ("get mouse events"): {
        if (Args.length != 1) throw (new LooFInterpreterException (Environment, "the message \"get mouse events\" does not take any arguments.", new String[] {"InvalidArgsLength"}));
        LooFInterpreterModuleData InterpreterModuleData = (LooFInterpreterModuleData) Environment.ModuleDatas.get(InterpreterModule_Interpreter);
        long StartMillis = InterpreterModuleData.StartMillis;
        LooFInputHandler InputHandler = ModuleData.InputHandler;
        
        ArrayList <LooFDataValue> ClickEvents = new ArrayList <LooFDataValue> ();
        ArrayList <LooFDataValue> DownEvents  = new ArrayList <LooFDataValue> ();
        ArrayList <LooFDataValue> UpEvents    = new ArrayList <LooFDataValue> ();
        ArrayList <LooFDataValue> EnterEvents = new ArrayList <LooFDataValue> ();
        ArrayList <LooFDataValue> ExitEvents  = new ArrayList <LooFDataValue> ();
        
        for (MouseEvent CurrentEvent : InputHandler.ClickEvents) ClickEvents.add (CreateLooFMouseEvent (CurrentEvent, StartMillis));
        for (MouseEvent CurrentEvent : InputHandler.DownEvents ) DownEvents .add (CreateLooFMouseEvent (CurrentEvent, StartMillis));
        for (MouseEvent CurrentEvent : InputHandler.UpEvents   ) UpEvents   .add (CreateLooFMouseEvent (CurrentEvent, StartMillis));
        for (MouseEvent CurrentEvent : InputHandler.EnterEvents) EnterEvents.add (CreateLooFMouseEvent (CurrentEvent, StartMillis));
        for (MouseEvent CurrentEvent : InputHandler.ExitEvents ) ExitEvents .add (CreateLooFMouseEvent (CurrentEvent, StartMillis));
        
        InputHandler.ClickEvents.clear();
        InputHandler.DownEvents.clear();
        InputHandler.UpEvents.clear();
        InputHandler.EnterEvents.clear();
        InputHandler.ExitEvents.clear();
        
        HashMap <String, LooFDataValue> TableToPushItems = new HashMap <String, LooFDataValue> ();
        TableToPushItems.put("ClickEvents", new LooFDataValue (ClickEvents, new HashMap <String, LooFDataValue> ()));
        TableToPushItems.put("DownEvents" , new LooFDataValue (DownEvents , new HashMap <String, LooFDataValue> ()));
        TableToPushItems.put("UpEvents"   , new LooFDataValue (UpEvents   , new HashMap <String, LooFDataValue> ()));
        TableToPushItems.put("EnterEvents", new LooFDataValue (EnterEvents, new HashMap <String, LooFDataValue> ()));
        TableToPushItems.put("ExitEvents" , new LooFDataValue (ExitEvents , new HashMap <String, LooFDataValue> ()));
        
        LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
  @Override
  public LooFModuleData CreateModuleData() {
    return new LooFInputModuleData (new LooFInputHandler());
  }
  
};



class LooFInputModuleData extends LooFModuleData {
  
  LooFInputHandler InputHandler;
  
  public LooFInputModuleData (LooFInputHandler InputHandler) {
    this.InputHandler = InputHandler;
  }
  
}





class LooFInputHandler implements MouseListener {
  
  
  
  ArrayList <MouseEvent> ClickEvents = new ArrayList <MouseEvent> ();
  ArrayList <MouseEvent> DownEvents = new ArrayList <MouseEvent> ();
  ArrayList <MouseEvent> UpEvents = new ArrayList <MouseEvent> ();
  ArrayList <MouseEvent> EnterEvents = new ArrayList <MouseEvent> ();
  ArrayList <MouseEvent> ExitEvents = new ArrayList <MouseEvent> ();
  
  
  
  public LooFInputHandler() {
    Component ProcessingComponent = (Component) surface.getNative();
    ProcessingComponent.addMouseListener(this);
  }
  
  
  
  public void mouseClicked (MouseEvent e) {
    ClickEvents.add(e);
  }
  
  public void mousePressed (MouseEvent e) {
    DownEvents.add(e);
  }
  
  public void mouseReleased (MouseEvent e) {
    UpEvents.add(e);
  }
  
  public void mouseEntered (MouseEvent e) {
    EnterEvents.add(e);
  }
  
  public void mouseExited (MouseEvent e) {
    ExitEvents.add(e);
  }
  
  
  
}





LooFDataValue CreateLooFMouseEvent (MouseEvent Event, long StartMillis) {
  HashMap <String, LooFDataValue> EventData = new HashMap <String, LooFDataValue> ();
  
  EventData.put("ButtonNum"   , new LooFDataValue (Event.getButton()));
  EventData.put("Count"       , new LooFDataValue (Event.getClickCount()));
  EventData.put("XPos"        , new LooFDataValue (Event.getX()));
  EventData.put("YPos"        , new LooFDataValue (Event.getY()));
  EventData.put("AbsoluteXPos", new LooFDataValue (Event.getXOnScreen()));
  EventData.put("AbsoluteYPos", new LooFDataValue (Event.getYOnScreen()));
  EventData.put("Millis"      , new LooFDataValue (Event.getWhen() - StartMillis));
  EventData.put("ShiftDown"   , new LooFDataValue (Event.isShiftDown()));
  EventData.put("ControlDown" , new LooFDataValue (Event.isControlDown()));
  EventData.put("AltDown"     , new LooFDataValue (Event.isAltDown()));
  
  return new LooFDataValue (new ArrayList <LooFDataValue> (), EventData);
}
