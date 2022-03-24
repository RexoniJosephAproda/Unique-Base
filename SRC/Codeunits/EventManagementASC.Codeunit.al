/// <summary>
/// Codeunit "EventManagementASC" (ID 50000).
/// </summary>
codeunit 50000 EventManagementASC
{

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"SwS Employee", 'OnAfterInsertEvent', '', true, true)]
    local procedure CheckWhetherEmployeeExist(Rec: Record "SwS Employee")
    var
    // Employee: Record Employee;
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee", 'OnAfterModifyEvent', '', true, true)]
    local procedure CheckWhetherVendorExist(Rec: Record "Employee")
    var
        Vendor: Record Vendor;
        SwSEmployeeBank: Record "SwS Employee Bank";
        VendorBankAccount: Record "Vendor Bank Account";
        SalespersonPurchaser: Record "Salesperson/purchaser";
    begin
        IF NOT (Vendor.get(Rec."No.")) AND (Rec."First Name" <> '') then begin

            Vendor.Init();
            Vendor."No." := Rec."No.";
            if Vendor.Insert(true) then
                ApplyVendorTemplate(Vendor);
            IF (Vendor.get(Rec."No.")) then;
            Vendor.VALIDATE(Name, Rec."First Name" + ' ' + Rec."Last Name");
            Vendor.VALIDATE(Address, Rec.Address);
            Vendor.VALIDATE(City, Rec.City);
            Vendor.VALIDATE("Post Code", Rec."Post Code");
            Vendor.VALIDATE("Country/Region Code", Rec."Country/Region Code");
            Vendor.VALIDATE("E-Mail", Rec."Company E-Mail");
            IF (Vendor.Modify(True)) then;

            clear(SwSEmployeeBank);
            SwSEmployeeBank.SetRange("Employee No.", Rec."No.");

            IF (SwSEmployeeBank.FindFirst()) then
                IF NOT VendorBankAccount.Get(Rec."No.", SwSEmployeeBank."Pos.") then begin
                    VendorBankAccount.Init();
                    VendorBankAccount."Vendor No." := Rec."No.";
                    VendorBankAccount.Code := Format(SwSEmployeeBank."Pos.");
                    IF (VendorBankAccount.Insert(true)) then;
                    IF (VendorBankAccount.get(Rec."No.", SwSEmployeeBank."Pos.")) then;
                    VendorBankAccount.VALIDATE("Clearing No.", SwSEmployeeBank."Clearing No.");
                    VendorBankAccount.VALIDATE("SWIFT Code", SwSEmployeeBank."BIC (SWIFT)");
                    VendorBankAccount.VALIDATE(IBAN, SwSEmployeeBank.IBAN);
                    VendorBankAccount.VALIDATE("Payment Form", SwSEmployeeBank."Payment Form");
                    UpdatePaymentForm(VendorBankAccount, SwSEmployeeBank);
                    IF VendorBankAccount.Modify(true) then;

                end;
            SalespersonPurchaser.Init();
            SalespersonPurchaser.Code := Rec."No.";
            IF (SalespersonPurchaser.Insert(True)) then;
            IF (SalespersonPurchaser.get(Rec."No.")) then;
            SalespersonPurchaser.Validate(Name, Rec."First Name" + ' ' + Rec."Last Name");
            SalespersonPurchaser.Validate("E-Mail", Rec."E-Mail");
            SalespersonPurchaser.VALIDate("Yokoy Employee ID ASER", Rec."No.");
            IF (SalespersonPurchaser.Modify(true)) then;


        end;
    end;

    local Procedure ApplyVendorTemplate(var vVendor: Record Vendor)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        vendorTemplate: Record "Vendor Templ.";
        cuVendorTemplMgt: Codeunit "Vendor Templ. Mgt.";
    begin
        if PurchasesPayablesSetup.Get() then
            if PurchasesPayablesSetup."Standard Template ASC" <> '' then
                if vendorTemplate.Get(PurchasesPayablesSetup."Standard Template ASC") then
                    cuVendorTemplMgt.ApplyVendorTemplate(vVendor, vendorTemplate);
    end;

    local procedure UpdatePaymentForm(var VendorBankAccount: Record "Vendor Bank Account"; SwSEmployeeBank: Record "SwS Employee Bank")
    begin
        case SwSEmployeeBank."Payment Form" of
            SwSEmployeeBank."Payment Form"::Bank:
                begin
                    VendorBankAccount.Validate("Payment Form", VendorBankAccount."Payment Form"::"Bank Payment Domestic");
                    VendorBankAccount.ValiDate("Clearing No.", SwSEmployeeBank."Clearing No.");
                    VendorBankAccount.Validate(IBAN, SwSEmployeeBank.IBAN);
                end;
            SwSEmployeeBank."Payment Form"::Postcheck:
                begin
                    VendorBankAccount.Validate("Payment Form", VendorBankAccount."Payment Form"::"Post Payment Domestic");
                    VendorBankAccount.Validate("SWIFT Code", SwSEmployeeBank."BIC (SWIFT)");
                    VendorBankAccount.Validate("Giro Account No.", SwSEmployeeBank."Giro Account No.");
                end;

        end;
    end;



}
