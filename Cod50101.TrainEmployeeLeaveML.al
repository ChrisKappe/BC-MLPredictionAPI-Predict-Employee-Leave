codeunit 50101 "Train EmployeeLeave ML"
{
    procedure Train();
    var
        MLPrediction: Codeunit "ML Prediction Management";
        MyModel: Text;
        MyModelQuality: Decimal;

        Setup: Record "Employee Leave ML Setup";
        EmployeeLeaveHistory: Record EmployeeExtendedData;
    begin

        //Setup connection
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);

        //Prepare data for the training
        MLPrediction.SetRecord(EmployeeLeaveHistory);

        //Set features
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(average_montly_hours));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(last_evaluation));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(number_project));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(promotion_last_5years));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(salary));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(sales));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(satisfaction_level));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(time_spend_company));
        MLPrediction.AddFeature(EmployeeLeaveHistory.FieldNo(Work_accident));

        //Set label
        MLPrediction.SetLabel(EmployeeLeaveHistory.FieldNo(left));

        //Train model
        MLPrediction.Train(MyModel, MyModelQuality);

        //Save model
        Setup.InsertIfNotExists();
        Setup.SetEmployeeLeaveModel(MyModel);
        Setup.Validate("My Model Quality", MyModelQuality);
        Setup.Validate("My Features", 'average_montly_hours,last_evaluation,number_project,promotion_last_5years,salary,sales,satisfaction_level,time_spend_company,Work_accident');
        Setup.Validate("My Label", 'left');
        Setup.Modify(true);

        //Inform about traininig status
        Message('Model is trained. Quality is %1%', Round(MyModelQuality * 100, 1));
    end;

    procedure DownloadPlotOfTheModel()
    var
        MLPrediction: Codeunit "ML Prediction Management";
        PlotBase64: Text;
        Setup: Record "Employee Leave ML Setup";
    begin
        Setup.Get();
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);
        PlotBase64 := MLPrediction.PlotModel(Setup.GetEmployeeLeaveModel(), Setup."My Features", Setup."My Label");
        MLPrediction.DownloadPlot(PlotBase64, 'EmployeeLeavePrediction');
    end;

    procedure GetPlotOfTheModel() PlotBase64: Text
    var
        Setup: Record "Employee Leave ML Setup";
        MLPrediction: Codeunit "ML Prediction Management";
    begin
        Setup.Get();
        MLPrediction.Initialize(Setup.getMLUri(), Setup.getMLKey(), 0);
        PlotBase64 := MLPrediction.PlotModel(Setup.GetEmployeeLeaveModel(), Setup."My Features", Setup."My Label");
    end;
}