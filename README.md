# Artifact for pythoneda-shared-pythoneda/domain-artifact

(Meta)Artifact space of [pythoneda-shared-pythoneda](https://github.com/pythoneda-shared-pythoneda "pythoneda-shared-pythoneda")/[domain-artifact](https://github.com/pythoneda-shared-pythoneda/domain-artifact "domain-artifact").

## How to run it

``` sh
nix run 'https://github.com/pythoneda-shared-pythoneda/domain-artifact-artifact/[version]?dir=domain-artifact'
```

### Usage

``` sh
nix run https://github.com/pythoneda-shared-pythoneda/domain-artifact-artifact/[version] [-h|--help] [-r|--repository-folder folder] [-e|--event event] [-t|--tag tag]
```
- `-h|--help`: Prints the usage.
- `-r|--repository-folder`: The folder where <https://github.com/pythoneda-shared-pythoneda/domain-artifact> is cloned.
- `-e|--event`: The event to send. See <https://github.com/pythoneda-shared-artifact/events>.
- `-t|--tag`: If the event is `TagPushed`, specify the tag.
