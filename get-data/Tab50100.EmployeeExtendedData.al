table 50100 "EmployeeExtendedData"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }

        field(2; "satisfaction_level"; Decimal)
        {
            CaptionML = ENU = 'satisfaction_level';
        }
        field(3; "last_evaluation"; Decimal)
        {
            CaptionML = ENU = 'last_evaluation';
        }
        field(4; "number_project"; Integer)
        {
            CaptionML = ENU = 'number_project';
        }
        field(5; "average_montly_hours"; Integer)
        {
            CaptionML = ENU = 'average_montly_hours';
        }
        field(6; "time_spend_company"; Integer)
        {
            CaptionML = ENU = 'time_spend_company';
        }
        field(7; "Work_accident"; Integer)
        {
            CaptionML = ENU = 'Work_accident';
        }
        field(8; "left"; Boolean)
        {
            CaptionML = ENU = 'left';
        }
        field(9; "promotion_last_5years"; Integer)
        {
            CaptionML = ENU = 'promotion_last_5years';
        }
        field(10; "sales"; Text[250])
        {
            CaptionML = ENU = 'sales';
        }
        field(11; "salary"; Text[250])
        {
            CaptionML = ENU = 'salary';
        }
        field(12; confidence; Decimal)
        {

        }


    }

    keys
    {
        key("PK"; "Line No.")
        { }
    }

    procedure RefreshEmployeeExtendedData();
    var
        RefreshEmployeeExtendedData: Codeunit RefreshEmployeeExtendedData;
    begin
        RefreshEmployeeExtendedData.Refresh();
    end;

}
