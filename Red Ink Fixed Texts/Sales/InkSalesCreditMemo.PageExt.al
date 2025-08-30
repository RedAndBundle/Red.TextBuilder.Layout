pageextension 84512 "PTE Ink Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        addafter(General)
        {
            group(PTEInkFixedText)
            {
                Caption = 'Fixed Text';
                Visible = PTEInkFixedTextVisible;
                field(PTEInkFixedTextEditor; PTEInkFixedText)
                {
                    ToolTip = 'Specifies the rich text content of the text.';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    StyleExpr = false;
                    ApplicationArea = All;
                    Editable = PTEInkFixedTextEditable;

                    trigger OnValidate()
                    begin
                        PTEInkValidateFixedText();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PTEInkFixedTextVisible := PTEInkText.GetFixedTextIface(Rec, PTEInkFixedText, PTEInkFixedTextEditable);
    end;

    local procedure PTEInkValidateFixedText()
    begin
        if PTEInkFixedTextVisible then
            PTEInkText.SaveTextIface(PTEInkFixedText);
    end;

    var
        PTEInkText: Record "Red Ink Text";
        PTEInkFixedTextEditable, PTEInkFixedTextVisible : Boolean;
        PTEInkFixedText: Text;
}