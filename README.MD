This repository is used internally by the OFBiz team to share, document and store specific tools used by the project.

For instance the rat-excludes.txt file allows to exclude files that don't need a licence. It's used during our Continuous Integration flow (CI) by BuildBot calling [Apache RAT](https://creadur.apache.org/rat/) to check files licences. This in order to avoid missing licence when releasing. There are other tools in the main dir.

As its name explains the documentation dir contains documents, notably one about our BuildBot usage inside our CI flow.

Same for demo-backup that contains elements to help maintain our demos, wiki and web site. Some are now history but kept for now before we push them in a new attic dir
