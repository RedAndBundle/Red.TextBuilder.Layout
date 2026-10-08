tableextension 84530 "PTE Ink Setup" extends "Red Ink Setup"
{
    fields
    {
        field(84530; "PTE Customer Fixed Text Type"; Code[20])
        {
            Caption = 'Customer Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84531; "PTE Vendor Fixed Text Type"; Code[20])
        {
            Caption = 'Vendor Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84532; "PTE Contact Fixed Text Type"; Code[20])
        {
            Caption = 'Contact Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84533; "PTE Item Fixed Text Type"; Code[20])
        {
            Caption = 'Item Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84534; "PTE Sales Fixed Text Type"; Code[20])
        {
            Caption = 'Sales Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84535; "PTE Sales Flow To Transaction"; Boolean)
        {
            Caption = 'Sales Flow To Transaction';
            DataClassification = OrganizationIdentifiableInformation;
            InitValue = true;
        }
        field(84536; "PTE Purchase Fixed Text Type"; Code[20])
        {
            Caption = 'Purchase Fixed Text Type';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = "Red Ink Text Type";
        }
        field(84537; "PTE Purch. Flow To Transaction"; Boolean)
        {
            Caption = 'Purchase Flow To Transaction';
            DataClassification = OrganizationIdentifiableInformation;
            InitValue = true;
        }
    }

    procedure PTEGetFixedTextType(TableNo: Integer; var TextType: Code[20]; var FlowToTransaction: Boolean): Boolean
    begin
        case TableNo of
            Database::Customer:
                begin
                    TextType := "PTE Customer Fixed Text Type";
                    FlowToTransaction := "PTE Sales Flow To Transaction";
                end;
            Database::Contact:
                TextType := "PTE Contact Fixed Text Type";
            Database::Item:
                TextType := "PTE Item Fixed Text Type";
            Database::"Sales Header",
            Database::"Sales Invoice Header",
            Database::"Sales Cr.Memo Header":
                begin
                    TextType := "PTE Sales Fixed Text Type";
                    FlowToTransaction := "PTE Sales Flow To Transaction";
                end;
#if PURCH
            Database::Vendor:
                begin
                    TextType := "PTE Vendor Fixed Text Type";
                    FlowToTransaction := "PTE Purch. Flow To Transaction";
                end;
            Database::"Purchase Header",
            Database::"Purch. Inv. Header",
            Database::"Purch. Cr. Memo Hdr.":
                begin
                    TextType := "PTE Purchase Fixed Text Type";
                    FlowToTransaction := "PTE Purch. Flow To Transaction";
                end;
#endif
        end;

        exit(TextType <> '');
    end;
}
