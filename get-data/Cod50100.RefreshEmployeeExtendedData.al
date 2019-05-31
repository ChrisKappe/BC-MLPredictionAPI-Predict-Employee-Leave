codeunit 50100 "RefreshEmployeeExtendedData"
{
    procedure Refresh();
    var
        EmployeeExtendedData: Record EmployeeExtendedData;
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
    begin
        EmployeeExtendedData.DeleteAll;

        // Simple web service call
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('https://dkatsonpublicdatasource.blob.core.windows.net/machinelearning/BC-ML-Prediction-API-Blog-Employee leave data.json',
                              ResponseMessage)
        then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\' +
                  'Status code: %1' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
        if not JsonArray.ReadFrom(JsonText) then begin
            // probably single object
            JsonToken.ReadFrom(JsonText);
            InsertEmployeeExtendedData(JsonToken);
        end else begin
            // array
            for i := 0 to JsonArray.Count - 1 do begin
                JsonArray.Get(i, JsonToken);
                InsertEmployeeExtendedData(JsonToken);
            end;
        end;
    end;

    procedure InsertEmployeeExtendedData(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        EmployeeExtendedData: Record EmployeeExtendedData;
    begin
        JsonObject := JsonToken.AsObject;

        EmployeeExtendedData.init;

        EmployeeExtendedData."satisfaction_level" := GetJsonToken(JsonObject, 'satisfaction_level').AsValue.AsDecimal;
        EmployeeExtendedData."last_evaluation" := GetJsonToken(JsonObject, 'last_evaluation').AsValue.AsDecimal;
        EmployeeExtendedData."number_project" := GetJsonToken(JsonObject, 'number_project').AsValue.AsInteger;
        EmployeeExtendedData."average_montly_hours" := GetJsonToken(JsonObject, 'average_montly_hours').AsValue.AsInteger;
        EmployeeExtendedData."time_spend_company" := GetJsonToken(JsonObject, 'time_spend_company').AsValue.AsInteger;
        EmployeeExtendedData."Work_accident" := GetJsonToken(JsonObject, 'Work_accident').AsValue.AsInteger;
        EmployeeExtendedData."left" := GetJsonToken(JsonObject, 'left').AsValue.AsInteger;
        EmployeeExtendedData."promotion_last_5years" := GetJsonToken(JsonObject, 'promotion_last_5years').AsValue.AsInteger;
        EmployeeExtendedData."sales" := COPYSTR(GetJsonToken(JsonObject, 'sales').AsValue.AsText, 1, 250);
        EmployeeExtendedData."salary" := COPYSTR(GetJsonToken(JsonObject, 'salary').AsValue.AsText, 1, 250);

        EmployeeExtendedData.Insert;
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

}
