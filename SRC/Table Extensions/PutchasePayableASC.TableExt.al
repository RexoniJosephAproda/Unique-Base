/// <summary>
/// TableExtension "PutchasePayableASC" (ID 50000) extends Record Purchases & Payables Setup.
/// </summary>
tableextension 50000 PutchasePayableASC extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Standard Template ASC"; Code[20])
        {
            Caption = 'Standard Template ASC';
            DataClassification = CustomerContent;
            TableRelation = "Vendor Templ.".Code;
        }
    }
}
