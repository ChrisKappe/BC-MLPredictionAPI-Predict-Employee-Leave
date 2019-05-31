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
    }
}