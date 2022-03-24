/// <summary>
/// PageExtension "PurchaseJournalASC" (ID 50000) extends Record Purchase Journal.
/// </summary>
pageextension 50000 PurchaseJournalASC extends "Purchase Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Deferral Code ASC"; Rec."Deferral Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
