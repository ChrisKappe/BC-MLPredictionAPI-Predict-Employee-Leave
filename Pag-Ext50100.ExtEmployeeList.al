pageextension 50100 "ExtEmployeeList" extends "Employee List" //MyTargetPageId
{
    layout
    {
        addafter(FullName)
        {
            field("Leave Prediction"; "Leave Prediction")
            {
                Caption = 'Leave Prediction';
                ToolTip = 'Specifies that the employee is predicted to leave.';
                ApplicationArea = Basic, Suite;
                StyleExpr = StyleTxt;
            }
            field("Prediction Confidence"; "Prediction Confidence")
            {
                Caption = 'Prediction Confidence';
                ToolTip = 'Specifies the reliability of the leave prediction. High is above 90%, Medium is between 80% and 90%, and Low is less than 80%.';
                ApplicationArea = Basic, Suite;
                StyleExpr = StyleTxt;
            }
            field("Prediction Confidence %"; "Prediction Confidence %")
            {
                Caption = 'Prediction Confidence %';
                ToolTip = 'Specifies the percentage that the prediction confidence value is based on.';
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                StyleExpr = StyleTxt;
            }

        }
    }

    actions
    {
        addafter("E&mployee")
        {
            action("Predict Will Leave")
            {
                Caption = 'Predict Leave';
                Image = Forecast;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PredictEmployeeLeave: Codeunit "Predict EmployeeLeave";
                begin
                    PredictEmployeeLeave.PredictBatch();
                    CurrPage.Update();
                end;
            }

            action("Why Leave")
            {
                Caption = 'Why Leave';
                Image = Questionaire;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TrainEmployeeLeaveML: Codeunit "Train EmployeeLeave ML";
                begin
                    TrainEmployeeLeaveML.DownloadPlotOfTheModel();
                end;
            }

            action("History Data")
            {
                Caption = 'Leave History';
                Image = History;
                RunObject = page EmployeeExtendedDataList;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
        }
    }

    var
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    procedure SetStyle(): Text
    var
    begin
        If "Leave Prediction" = "Leave Prediction"::Leave then
            exit('Attention');
        exit('')
    end;
}