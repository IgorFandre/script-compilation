# Manual

The script compiles the files and archives them in .tar.gz extension.
The hierarchy of folders inside the archive remains the same as in the project.

### OPTIONS

    -s, --source [absolute path]
        path to project source

    -a, --archive [name]
        name of archive to be created

    -c, --compiler "[extension]=[compiler command]"
        extension of files to be compiled by given command (might be several times)

#### Example

    ./script.sh -s /home/project --archive archive_name --compiler "s=c=gcc" -c "hpp=cpp=g++"
