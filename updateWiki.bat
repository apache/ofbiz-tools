cd tools

call asciidoctor ..\README.adoc -o wiki-files/README.html

pandoc demo-backup/README.md -s -o wiki-files/demos/README.md.html
pandoc documentation/BuildBot/BuildBot.md -s -o wiki-files/BuildBot/BuildBot.md.html

TortoiseGitProc /command:commit

cd..