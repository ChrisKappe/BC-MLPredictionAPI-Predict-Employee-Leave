tableextension 50100 "ExtEmployee" extends Employee //MyTargetTableId
{
    fields
    {
        field(50000; "Leave Prediction"; Option)
        {
            OptionMembers = " ",Leave,"Stay";
            OptionCaption = ' ,Will Leave,Will Stay';
        }
        field(50001; "Prediction Confidence"; Option)
        {
            OptionMembers = " ",Low,Medium,High;
            OptionCaption = ' ,Low,Medium,High';
            Caption = 'Prediction Confidence';
        }
        field(50002; "Prediction Confidence %"; Decimal)
        {
        }

    }

    fieldgroups
    {
        addlast(Brick; "Leave Prediction", "Prediction Confidence")
        {

        }
    }

}