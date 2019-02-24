#!/bin/sh

function loadConfig()
{
    # Default Parameters
    envPrefix=${1:-PHP_}
    configFile=${2:-"/etc/php.d/php.ini"}
    configBrace=${3:-"="}

    # Create config file does not exist
    if [ ! -f "$configFile" ]; then
        subDirs=$(rev <<<$(cut -d'/' -f2- <<<$(rev <<<$configFile)))

        if [ ! -z "$subDirs" ]; then
            if [ ! -d "$subDirs" ]; then
                mkdir -p $subDirs
            fi
        fi

        touch ${configFile}
    fi

    # Extract environment and save to file
    for data in $(env | grep $envPrefix); do
        cKey=$(cut -d'=' -f1 <<<${data/$envPrefix/""})
        cValue=$(cut -d'=' -f2 <<<$data)
        
        # Write File
        if grep -q "^\s*$cKey\s*$configBrace.*" $configFile; then
            sed -i "/^\s*$cKey/s/\s*$configBrace.*/$configBrace $cValue/" $configFile
        else
            echo ${cKey}$configBrace $cValue >> $configFile
        fi
    done
}

loadConfig 
