Import-Module 'C:\Program Files\Reports ForNAV\ForNav.Cmdlet.dll'

# Set-Location -Path $PSScriptRoot

Invoke-ExportTranslationFromXlfToExcel `
    -FromXlf '.\Translations\'`
    -ToExcel '.\Scripts\Translations-Generated.xlsx'

Invoke-ImportTranslationFromExcelToXlf `
    -FromXlf '.\Translations\Red Ink Fixed Texts.g.xlf'`
    -FromExcel '.\Scripts\Translations.xlsx'`
    -ToXlf '.\Translations'