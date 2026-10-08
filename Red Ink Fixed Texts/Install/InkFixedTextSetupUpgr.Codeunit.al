codeunit 84534 "PTE Ink Fixed Text Setup Upgr."
{
    Access = Internal;

    /// <summary>
    /// Copies the fixed text setup from the (obsolete) Red Ink Setup fields to the PTE fields of this extension on the same record.
    /// Runs once per company, guarded by an upgrade tag.
    /// </summary>
    procedure MoveSetupFromRedInk()
    var
        InkSetup: Record "Red Ink Setup";
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if UpgradeTag.HasUpgradeTag(GetMoveSetupUpgradeTag()) then
            exit;

        if InkSetup.Get() then begin
#pragma warning disable AL0432
            InkSetup."PTE Customer Fixed Text Type" := InkSetup."Customer Fixed Text Type";
            InkSetup."PTE Vendor Fixed Text Type" := InkSetup."Vendor Fixed Text Type";
            InkSetup."PTE Contact Fixed Text Type" := InkSetup."Contact Fixed Text Type";
            InkSetup."PTE Item Fixed Text Type" := InkSetup."Item Fixed Text Type";
            InkSetup."PTE Sales Fixed Text Type" := InkSetup."Sales Fixed Text Type";
            InkSetup."PTE Sales Flow To Transaction" := InkSetup."Sales Flow To Transaction";
            InkSetup."PTE Purchase Fixed Text Type" := InkSetup."Purchase Fixed Text Type";
            InkSetup."PTE Purch. Flow To Transaction" := InkSetup."Purchase Flow To Transaction";
#pragma warning restore AL0432
            InkSetup.Modify();
        end;

        UpgradeTag.SetUpgradeTag(GetMoveSetupUpgradeTag());
    end;

    local procedure GetMoveSetupUpgradeTag(): Code[250]
    begin
        exit('PTE-INK-FIXEDTEXT-MOVESETUP-20261005');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetMoveSetupUpgradeTag());
    end;
}
