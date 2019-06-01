page 50100 "EmployeeExtendedDataList"
{
    PageType = List;
    SourceTable = EmployeeExtendedData;
    CaptionML = ENU = 'Employee Leave History';
    Editable = false;
    SourceTableView = order(descending);
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("satisfaction_level"; "satisfaction_level")
                {
                    ApplicationArea = All;
                }
                field("last_evaluation"; "last_evaluation")
                {
                    ApplicationArea = All;
                }
                field("number_project"; "number_project")
                {
                    ApplicationArea = All;
                }
                field("average_montly_hours"; "average_montly_hours")
                {
                    ApplicationArea = All;
                }
                field("time_spend_company"; "time_spend_company")
                {
                    ApplicationArea = All;
                }
                field("Work_accident"; "Work_accident")
                {
                    ApplicationArea = All;
                }
                field("left"; "left")
                {
                    ApplicationArea = All;
                }
                field("promotion_last_5years"; "promotion_last_5years")
                {
                    ApplicationArea = All;
                }
                field("sales"; "sales")
                {
                    ApplicationArea = All;
                }
                field("salary"; "salary")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("RefreshEmployeeExtendedData")
            {
                CaptionML = ENU = 'Refresh Data';
                Promoted = true;
                PromotedCategory = Process;
                Image = RefreshLines;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    RefreshEmployeeExtendedData();
                    CurrPage.Update;
                    if FindFirst then;
                end;
            }

            action("Train ML Model")
            {
                Caption = 'Train';
                ToolTip = 'Send your data to our predictive experiment and we will prepare a predictive model for you.';
                Image = Task;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    RestForecastTrain: Codeunit "Train EmployeeLeave ML";
                begin
                    RestForecastTrain.Train();
                    //RestForecastTrain.DownloadPlotOfTheModel();
                end;
            }
        }
    }


}
