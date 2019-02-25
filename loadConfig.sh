#!/bin/bash

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
    env | grep $envPrefix | while read -r line; do
        cKey=$(cut -d':' -f1 <<<${line//*=/""})
        cValue=$(cut -d':' -f2- <<<${line//*=/""})

        #Write File
        if grep -q "^\s*$cKey\s*$configBrace.*" $configFile; then
            sed -i "/^\s*$cKey\s*=/s/$configBrace.*/$configBrace $cValue/" $configFile
        else
            echo '' >> $configFile
            echo ${cKey}$configBrace $cValue >> $configFile
        fi
    done

    # Flush Environment 
    for i in $(compgen -v | grep $envPrefix); do
        unset $i
    done   
}

# Write PHP Config
loadConfig PHP_ /etc/php.d/php.ini

exec "$@"
