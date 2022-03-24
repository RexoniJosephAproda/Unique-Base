/// <summary>
/// PageExtension "PurchasePayablesSetupASC" (ID 50001) extends Record Purchases & Payables Setup.
/// </summary>
pageextension 50001 PurchasePayablesSetupASC extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Standard Template ASC"; Rec."Standard Template ASC")
            {
                ApplicationArea = All;
                ToolTip = 'Standard Template';
            }
        }
    }
}
