codeunit 50102 "Predict EmployeeLeave"
{
    procedure PredictBatch()
    var
        Employee: Record Employee;
    begin
        if Employee.FindFirst() then
            repeat
                Predict(Employee);
            until Employee.Next() = 0;
    end;

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
            //TransferFields(EmployeeLeaveHistory);
            "Line No." := 0;
            satisfaction_level := Random(100) / 100;
            last_evaluation := Random(100) / 100;
            number_project := Random(10);
            average_montly_hours := 100 + Random(150);
            promotion_last_5years := Random(1);
            Work_accident := Random(1);
            sales := EmployeeLeaveHistory.sales;
            salary := EmployeeLeaveHistory.salary;
            time_spend_company := Date2DMY(Today, 3) - Date2DMY(Employee."Employment Date", 3);
            Insert()
        end;
    end;

    local procedure SavePredictionResult(var EmployeeExtendedData: Record EmployeeExtendedData temporary; var Employee: Record Employee)
    begin
        EmployeeExtendedData.Find();

        Employee."Leave Prediction" := Employee."Leave Prediction"::" ";//Stay;
        Employee."Prediction Confidence %" := 0;
        Employee."Prediction Confidence" := 0;

        IF EmployeeExtendedData.left Then begin
            Employee."Leave Prediction" := Employee."Leave Prediction"::Leave;
            Employee."Prediction Confidence %" := Round(EmployeeExtendedData.confidence * 100, 1);
            Employee."Prediction Confidence" := GetConfidenceOptionFromConfidencePercent(EmployeeExtendedData.confidence);
        end;

        Employee.Modify();
    end;

    local procedure GetConfidenceOptionFromConfidencePercent(ConfidencePrc: decimal) Confidence: Option " ",Low,Medium,High
    begin
        if (ConfidencePrc >= 0.9) then
            exit(Confidence::High);

        if (ConfidencePrc >= 0.8) then
            exit(Confidence::Medium);

        exit(Confidence::Low);
    end;

}