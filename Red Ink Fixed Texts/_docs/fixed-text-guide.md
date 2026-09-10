# Fixed Text

Fixed Text adds a rich-text editor field to card and document pages, prefilled from a
template (configured on the Red Ink Setup page) and editable per record.

## Where it appears

- **Cards**: Customer, Vendor, Contact, Item
- **Sales documents**: Quote, Order, Invoice, Credit Memo, and their posted invoice /
  credit memo pages
- **Purchase documents**: Quote, Order, Invoice, Credit Memo, and their posted invoice /
  credit memo pages

The field only shows up if a text type is configured for that area on the Red Ink Setup
page; otherwise it stays hidden.

## Setup

On the **Red Ink Setup** page, under **Fixed Text**, choose the text type to use for
each area:

- Customer / Contact / Item Fixed Text Type
- Vendor Fixed Text Type
- Sales Fixed Text Type
- Purchase Fixed Text Type

**Sales Flow To Transaction** and **Purchase Flow To Transaction** control whether the
generated text carries forward as the document flows from quote → order → posted
invoice/credit memo. When enabled, the text created on the quote (or order, for vendor
documents copied straight to a purchase order) follows the document through to the
posted record instead of being regenerated at each step.

## Vendor and purchase documents

Vendor Card now has the same Fixed Text field as Customer Card. When **Purchase Flow To
Transaction** is enabled, the text on the vendor's purchase order carries forward to the
posted purchase invoice / credit memo, mirroring how sales documents flow from the
customer's fixed text.
