cd tools

call asciidoctor ..\README.adoc -o wiki-files/README.html

pandoc ..\applications/datamodel/DATAMODEL_CHANGES.md -s -o wiki-files/data-model/DATAMODEL_CHANGES.md.html

pandoc ..\themes/README.md -s -o wiki-files/themes/README.md.html

pandoc demo-backup/README.md -s -o wiki-files/demos/README.md.html
pandoc documentation/BuildBot/BuildBot.md -s -o wiki-files/BuildBot/BuildBot.md.html

TortoiseGitProc /command:commit

cd..