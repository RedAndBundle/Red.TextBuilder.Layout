codeunit 84531 "PTE Ink Fixed Text Mgt."
{
    /// <summary>
    /// Finds (or creates) the fixed Red Ink Text for the source record and returns its HTML.
    /// Returns false when no fixed text type is configured for the source table.
    /// </summary>
    procedure GetFixedText(SourceRec: Variant; var InkText: Record "Red Ink Text"; var FixedText: Text; var Editable: Boolean): Boolean
    var
        InkSetup: Record "Red Ink Setup";
        InkTextInterface: Codeunit "Red Ink Text Interface";
        RecRef: RecordRef;
        TextType: Code[20];
        FlowToTransaction: Boolean;
        EntryNo: Integer;
    begin
        Clear(FixedText);
        RecRef.GetTable(SourceRec);
        case true of
            IsNullGuid(RecRef.Field(RecRef.SystemIdNo).Value),
            not InkSetup.Get(),
            not InkSetup.PTEGetFixedTextType(RecRef.Number, TextType, FlowToTransaction):
                exit(false);
        end;

        InkText.Reset();
        InkText.SetCurrentKey("Source Table No.", "Source System Id", Type, "Text Order");
        InkText.SetRange("Source Table No.", RecRef.Number);
        InkText.SetRange("Source System Id", RecRef.Field(RecRef.SystemIdNo).Value);
        InkText.SetRange(Type, TextType);
        if not InkText.FindFirst() then begin
            EntryNo := InkTextInterface.InsertTextInterface(SourceRec, TextType, '', FlowToTransaction, 0, 0D);
            if not InkText.Get(EntryNo) then
                exit(false);
        end;

        FixedText := GetText(InkText);
        Editable := IsTableEditable(RecRef.Number);
        exit(true);
    end;

    /// <summary>
    /// Saves the HTML of a fixed Red Ink Text and refreshes its preview text.
    /// </summary>
    procedure SaveFixedText(var InkText: Record "Red Ink Text"; NewText: Text)
    var
        EntityText: Record "Entity Text";
        os: OutStream;
    begin
        if not InkText.Get(InkText."Entry No.") then
            exit;

        if not EntityText.Get(CompanyName(), Database::"Red Ink Text", InkText.SystemId, Enum::"Entity Text Scenario"::"Red Ink Sales Text") then begin
            EntityText.Init();
            EntityText.Company := CopyStr(CompanyName(), 1, MaxStrLen(EntityText.Company));
            EntityText."Source Table Id" := Database::"Red Ink Text";
            EntityText."Source System Id" := InkText.SystemId;
            EntityText.Scenario := Enum::"Entity Text Scenario"::"Red Ink Sales Text";
            EntityText.Insert();
        end;

        Clear(EntityText.Text);
        EntityText.Text.CreateOutStream(os, TextEncoding::UTF8);
        os.WriteText(NewText);
        EntityText."Preview Text" := GetPreviewText(NewText);
        EntityText.Modify();

        InkText."Preview Text" := EntityText."Preview Text";
        InkText.Modify();
    end;

    local procedure GetText(InkText: Record "Red Ink Text") Result: Text
    var
        EntityText: Record "Entity Text";
        TypeHelper: Codeunit "Type Helper";
        is: InStream;
    begin
        if not EntityText.Get(CompanyName(), Database::"Red Ink Text", InkText.SystemId, Enum::"Entity Text Scenario"::"Red Ink Sales Text") then
            exit(GetStandardFont());

        EntityText.CalcFields(Text);
        EntityText.Text.CreateInStream(is, TextEncoding::UTF8);
        TypeHelper.TryReadAsTextWithSeparator(is, TypeHelper.LFSeparator(), Result);
    end;

    local procedure GetStandardFont(): Text
    var
        InkSetup: Record "Red Ink Setup";
        BaseHTMLLbl: Label '<div><span style="font-family: &quot;%1&quot;, monospace; font-size: %2pt">%3</span></div>', Comment = '%1 = font %2 = size %3 = text', Locked = true;
        TypeYourTextLbl: Label 'Type your text here...';
    begin
        if not InkSetup.Get() then
            exit;

        if InkSetup."Default Style Font" = InkSetup."Default Style Font"::" " then
            exit;

        exit(StrSubstNo(BaseHTMLLbl, InkSetup."Default Style Font", InkSetup."Default Style Size", TypeYourTextLbl));
    end;

    local procedure IsTableEditable(TableNo: Integer): Boolean
    var
        InkSetup: Record "Red Ink Setup";
    begin
        if InkSetup.Get() then
            if InkSetup."Posted Documents Editable" then
                exit(true);

        exit(not (TableNo in [
            Database::"Sales Invoice Header",
            Database::"Sales Cr.Memo Header",
            Database::"Purch. Inv. Header",
            Database::"Purch. Cr. Memo Hdr."]));
    end;

    local procedure GetPreviewText(RawHTML: Text): Text[100]
    var
        TypeHelper: Codeunit "Type Helper";
        PlainText: TextBuilder;
        Result: Text;
        InTag: Boolean;
        i: Integer;
    begin
        for i := 1 to StrLen(RawHTML) do
            case RawHTML[i] of
                '<':
                    InTag := true;
                '>':
                    begin
                        InTag := false;
                        PlainText.Append(' ');
                    end;
                10, 13:
                    ;
                else
                    if not InTag then
                        PlainText.Append(RawHTML[i]);
            end;

        Result := PlainText.ToText().Replace('  ', ' ');
        exit(CopyStr(DelChr(TypeHelper.HtmlDecode(Result), '<>', ' '), 1, 100));
    end;
}
