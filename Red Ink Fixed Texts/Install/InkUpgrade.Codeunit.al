codeunit 84533 "PTE Ink Upgrade"
{
    Subtype = Upgrade;
    Access = Internal;

    trigger OnUpgradePerCompany()
    var
        FixedTextSetupUpgr: Codeunit "PTE Ink Fixed Text Setup Upgr.";
    begin
        FixedTextSetupUpgr.MoveSetupFromRedInk();
    end;
}
