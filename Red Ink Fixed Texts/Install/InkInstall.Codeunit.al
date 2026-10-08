codeunit 84532 "PTE Ink Install"
{
    Subtype = Install;
    Access = Internal;

    trigger OnInstallAppPerCompany()
    var
        FixedTextSetupUpgr: Codeunit "PTE Ink Fixed Text Setup Upgr.";
    begin
        // Also on install: tenants that used the fixed text built into Red Ink get their setup carried over.
        FixedTextSetupUpgr.MoveSetupFromRedInk();
    end;
}
