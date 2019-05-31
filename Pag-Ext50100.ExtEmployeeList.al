pageextension 50100 "ExtEmployeeList" extends "Employee List" //MyTargetPageId
{
    layout
    {
        addafter(FullName)
        {
            field("Predicted to Leave"; "Predicted to Leave")
            {
                ApplicationArea = All;
            }
            field(confidence; confidence)
            {
                ApplicationArea = All;
                BlankZero = true;
            }
        }
    }

    actions
    {
        addafter("E&mployee")
        {
            action("Predict Will Leave")
            {
                Caption = 'Predict Will Leave';
                Image = Forecast;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PredictEmployeeLeave: Codeunit "Predict EmployeeLeave";
                    Employee: Record Employee;
                begin
                    if Employee.FindFirst() then
                        repeat
                            PredictEmployeeLeave.Predict(Employee);
                        until Employee.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
    }
}