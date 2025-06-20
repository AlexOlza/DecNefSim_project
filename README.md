# What's this repo?

Just a log of the dependencies of my other repo [DecNefSim](https://github.com/AlexOlza/DecNefSim)

## Expected directory structure

`install.sh` will handle everything in theory, but it should end up like this:

```
DecNefSim_project __
                    |̣̣̣__ install.sh
                    |̣̣̣__ try_package.sh
                    |̣̣̣__ activate_env.sh # Not in this repo for privacy reasons, is created by install.sh
                    |̣̣̣__ any other stuff related to installation
                    |̣̣̣__ requirements.txt
                    |̣̣̣__ manual_adds.txt
                    |̣̣̣__ DecNefSim # The main repo
                    |__ external
                                  |__ MindEyeV2
                                  |__ MindSimulator
                                  |__ any other external repos
```

If the repos included in `install.sh` are cloned prior to installation, please respect this directory structure!
