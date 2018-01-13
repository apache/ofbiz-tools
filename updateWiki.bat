pandoc README.md -s -o tools/wiki-files/README.md.html

pandoc applications/datamodel/DATAMODEL_CHANGES.md -s -o tools/wiki-files/data-model/DATAMODEL_CHANGES.md.html

pandoc themes/README.md -s -o tools/wiki-files/themes/README.md.html

pandoc "plugins/birt/documents/Creating reports.md" -s -o "tools/wiki-files/birt/Creating reports.md.html"
pandoc "plugins/birt/documents/Using the Birt Report Designer.md" -s -o "tools/wiki-files/birt/Using the Birt Report Designer.md.html"
pandoc "plugins/birt/documents/How to use flexible reports.md" -s -o "tools/wiki-files/birt/How to use flexible reports.md.html"
pandoc "plugins/birt/documents/Report master creation.md" -s -o "tools/wiki-files/birt/Report master creation.md.html"

pandoc tools/demo-backup/README.md -s -o tools/wiki-files/demos/README.md.html
pandoc tools/documentation/BuildBot/BuildBot.md -s -o tools/wiki-files/BuildBot/BuildBot.md.html


cd tools
TortoiseProc /command:commit /path:"C:\projectsASF\ofbiz\tools*C:\projectsASF\ofbiz\"

cd..