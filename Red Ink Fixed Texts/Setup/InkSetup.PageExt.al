pageextension 84500 "PTE Ink Setup" extends "Red Ink Setup"
{
    layout
    {
        addlast(Content)
        {
            group(PTEFixedText)
            {
                Caption = 'Fixed Text';
                field("PTE Customer Fixed Text Type"; Rec."Customer Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for customers. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Contact Fixed Text Type"; Rec."Contact Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for contacts. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Item Fixed Text Type"; Rec."Item Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for items. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Sales Fixed Text Type"; Rec."Sales Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for sales documents. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Sales Flow To Transaction"; Rec."Sales Flow To Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the if the sales fixed text should flow to transaction. If set to true the generated text will follow the transaction from quote, to order, to quote.';
                }
#if PURCH
                field("PTE Vendor Fixed Text Type"; Rec."Vendor Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for vendors. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Purchase Fixed Text Type"; Rec."Purchase Fixed Text Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the text type that will be used to create fixed texts for purchase documents. Fixed text is a text editor that is embedded in the card page. If a template exists for the text type, the template will be used to create the fixed text.';
                }
                field("PTE Purchase Flow To Transaction"; Rec."Purchase Flow To Transaction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the if the purchase fixed text should flow to transaction. If set to true the generated text will follow the transaction from quote, to order, to quote.';
                }
#endif
            }
        }
    }
}