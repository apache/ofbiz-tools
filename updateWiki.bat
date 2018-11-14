call asciidoctor README.adoc -o tools/wiki-files/README.html

pandoc applications/datamodel/DATAMODEL_CHANGES.md -s -o tools/wiki-files/data-model/DATAMODEL_CHANGES.md.html

pandoc themes/README.md -s -o tools/wiki-files/themes/README.md.html

pandoc tools/demo-backup/README.md -s -o tools/wiki-files/demos/README.md.html
pandoc tools/documentation/BuildBot/BuildBot.md -s -o tools/wiki-files/BuildBot/BuildBot.md.html


cd tools
TortoiseProc /command:commit /path:"C:\projectsASF\ofbiz\tools*C:\projectsASF\ofbiz\"

cd..