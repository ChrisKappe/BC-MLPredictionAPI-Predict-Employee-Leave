codeunit 50102 "Predict EmployeeLeave"
{
    procedure Predict(Employee: Record Employee)
    var
        MLPrediction: Codeunit "ML Prediction Management";

        Setup: Record "Employee Leave ML Setup";
        EmployeeExtendedData: Record EmployeeExtendedData temporary;
    begin

        Setup.Get();
        Setup.TestField("My Model");

        //Setup connection
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);

        //Prepare data for the forecast
        PrepareData(Employee, EmployeeExtendedData);
        MLPrediction.SetRecord(EmployeeExtendedData);

        //Set features
        //Set features
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(average_montly_hours));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(last_evaluation));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(number_project));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(promotion_last_5years));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(salary));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(sales));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(satisfaction_level));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(time_spend_company));
        MLPrediction.AddFeature(EmployeeExtendedData.FieldNo(Work_accident));

        //Set label
        MLPrediction.SetLabel(EmployeeExtendedData.FieldNo(left));

        //Set confidence field (only for classification models)
        MLPrediction.SetConfidence(EmployeeExtendedData.FieldNo(confidence));

        //Predict
        MLPrediction.Predict(Setup.GetEmployeeLeaveModel());

        //Save forecast
        SavePredictionResult(EmployeeExtendedData, Employee);
    end;

    local procedure PrepareData(Employee: Record Employee; var EmployeeExtendedData: Record EmployeeExtendedData temporary)
    var
        EmployeeLeaveHistory: Record EmployeeExtendedData;

    begin
        CASE Employee."Job Title" of
            'Secretary':
                EmployeeLeaveHistory.setrange(sales, 'accounting');
            'Designer':
                EmployeeLeaveHistory.setrange(sales, 'marketing');
            'Sales Manager':
                EmployeeLeaveHistory.setrange(sales, 'sales');
            'Production Assistant':
                EmployeeLeaveHistory.setrange(sales, 'product_mng');
            'Managing Director':
                EmployeeLeaveHistory.setrange(sales, 'management');
        end;

        EmployeeLeaveHistory.FindLast();
        with EmployeeExtendedData do begin
            Init();
            TransferFields(EmployeeLeaveHistory);
            time_spend_company := Date2DMY(Today, 3) - Date2DMY(Employee."Employment Date", 3);
            Insert()
        end;
    end;

    local procedure SavePredictionResult(var EmployeeExtendedData: Record EmployeeExtendedData temporary; var Employee: Record Employee)
    begin
        Employee."Predicted to Leave" := EmployeeExtendedData.left;
        Employee.confidence := EmployeeExtendedData.confidence;
        Employee.Modify();
    end;
}