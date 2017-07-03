#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Download packages Slackware (txz or tgz) from a pkgs.org website
#
# Last update: 02/07/2017
#
programName=$1

if [ "$programName" == '' ]; then
    echo -en "\nProgram name: "
    read -r programName
fi

if [ "$programName" == '' ]; then
    echo -e "\nThe name of the program/package can't be blank\n"
else
    echo -en "\nSlackware version (enter to insert 14.2): "
    read -r slackwareVersion

    if [ "$slackwareVersion" == '' ]; then
        slackwareVersion="14.2"
    fi

    echo
    wget "https://pkgs.org/download/$programName" -O "$programName"

    packagesLink=$(grep -E "txz|tgz" < "$programName" | grep "$slackwareVersion" | cut -d '=' -f2- | cut -d '>' -f1 | cut -d '"' -f2)
    rm "$programName"

    if [ "$packagesLink" != '' ]; then
        echo -e "\nPackages found: "
        countPackage=1

        for package in $packagesLink; do
            if [ "$countPackage" -lt "10" ]; then
                echo -n " "
            fi

            echo -n "$countPackage - "
            echo "$package" | cut -d '/' -f4-

            ((countPackage++))
        done
        ((countPackage--))

        echo -e "\nWhich package you whant download?"
        echo "# Pay attention in the correct arch #"
        echo -n "Valid number 1 - $countPackage: "
        read -r packageNumber

        ((countPackage++))
        if [ "$packageNumber" -lt "$countPackage" ]; then
            countTmp='1'

            for package in $packagesLink; do
                if [ "$countTmp" == "$packageNumber" ]; then
                    packagePageLink=$package
                    echo "packagePageLink: $packagePageLink"
                fi

                ((countTmp++))
            done

            echo
            wget "$packagePageLink" -O "$programName"

            linkDl=$(grep "Binary package" < "$programName" | cut -d '=' -f4 | cut -d '"' -f2)
            rm "$programName"

            wget "$linkDl"
        else
            echo -e "\nPackage number selected is big than the total of packages found\n"
        fi
    else
        echo -e "\nNone package found\n"
    fi
fi