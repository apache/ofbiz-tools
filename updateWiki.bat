call asciidoctor README.adoc -o tools/wiki-files/README.html

pandoc applications/datamodel/DATAMODEL_CHANGES.md -s -o tools/wiki-files/data-model/DATAMODEL_CHANGES.md.html

pandoc themes/README.md -s -o tools/wiki-files/themes/README.md.html

call asciidoctor README.adoc -o tools/wiki-files/README.html
call asciidoctor "plugins/birt/documents/Creating reports.adoc" -o "tools/wiki-files/birt/Creating reports.html"
call asciidoctor "plugins/birt/documents/Using the Birt Report Designer.adoc" -o "tools/wiki-files/birt/Using the Birt Report Designer.html"
call asciidoctor "plugins/birt/documents/How to use flexible reports.adoc" -o "tools/wiki-files/birt/How to use flexible reports.html"
call asciidoctor "plugins/birt/documents/Report master creation.adoc" -o "tools/wiki-files/birt/Report master creation.html"

pandoc tools/demo-backup/README.md -s -o tools/wiki-files/demos/README.md.html
pandoc tools/documentation/BuildBot/BuildBot.md -s -o tools/wiki-files/BuildBot/BuildBot.md.html


cd tools
TortoiseProc /command:commit /path:"C:\projectsASF\ofbiz\tools*C:\projectsASF\ofbiz\"

cd..