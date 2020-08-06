#!/bin/bash
#//************************************************************************
#// Copyright (C) 2020 Massachusetts Institute of Technology
#//
#// File Name:      get_external_dependencies.sh
#// Program:        Common Evaluation Platform (CEP)
#// Description:    Shell script to pull copies of external repositories
#//                 that the CEP depends on, but have not been directly
#//                 for a variety of reasons (including licensing)
#// Notes:          The "curl" commands have been locked into the particular
#//                 version of the repository that was tested with the CEP.
#//
#//************************************************************************

# The following decleration defines all the external CEP Dependencies that have not been directly included in
# the CEP repo.
#
# CAUTION: Listing directories within this construct MAY result in them being overwritten by the script
# 
# The pixman submodule within riscv-qemu has explicitly not been included at this time due to it being sourced
# on a seperate server.
#
# The format is:
#   GITHUB  - repo location, specific commit, target (relative) directory
#   QEMU    - repo location, specific commit, target (relative) directory
#   HTTP    - file location, target (relative) directory
#
# The entries that have been commented out reflect dependencies that have been directly included within the CEP repo.  Uncommenting
# them and running this script will result in clobbering the current directory (and potentially loosing CEP-specific modifications)
#
declare -a repo_names=(       "#"
                              "# The following dependecies are related to the Freedom U500 Platform"
                              "#"
                              #"GITHUB https://github.com/sifive/freedom 5241f55 ./hdl_cores/freedom"
                              "GITHUB https://github.com/sifive/fpga-shells 14297af ./hdl_cores/freedom/fpga-shells"
                              "GITHUB https://github.com/sifive/nvidia-dla-blocks 1ec9ccf ./hdl_cores/freedom/nvidia-dla-blocks"
                              "GITHUB https://github.com/nvdla/hw 7cf6ad5 ./hdl_cores/freedom/nvidia-dla-blocks/hw"                              
                              "GITHUB https://github.com/sifive/sifive-blocks a0da03f ./hdl_cores/freedom/sifive-blocks"                             
                              "GITHUB https://github.com/chipsalliance/rocket-chip b21c787 ./hdl_cores/freedom/rocket-chip"
                              "GITHUB https://github.com/freechipsproject/chisel3 3d8064a ./hdl_cores/freedom/rocket-chip/chisel3"
                              "GITHUB https://github.com/freechipsproject/firrtl 860e684 ./hdl_cores/freedom/rocket-chip/firrtl"
                              "GITHUB https://github.com/ucb-bar/berkeley-hardfloat 45f5ae1 ./hdl_cores/freedom/rocket-chip/hardfloat"
                              "GITHUB https://github.com/ucb-bar/riscv-torture 77195ab ./hdl_cores/freedom/rocket-chip/torture"
                              "GITHUB https://github.com/riscv/riscv-tools 3a5bfb3 ./hdl_cores/freedom/rocket-chip/riscv-tools"
                              "GITHUB https://github.com/riscv/riscv-fesvr 68c12d0 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-fesvr"
                              "GITHUB https://github.com/riscv/riscv-isa-sim aff796d ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-isa-sim"
                              "GITHUB https://github.com/riscv/riscv-opcodes 7c3db43 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-opcodes"
                              "GITHUB https://github.com/riscv/riscv-openocd 35eed36 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-openocd"
                              "GITHUB https://github.com/msteveb/jimtcl 51f65c6 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-openocd/jimtcl"
                              "GITHUB https://github.com/riscv/riscv-pk 3d921d3 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-pk"
                              "GITHUB https://github.com/riscv/riscv-tests 7906408 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-tests"
                              "GITHUB https://github.com/riscv/riscv-test-env 68cad7b ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-tests/env"
                              "GITHUB https://github.com/riscv/riscv-gnu-toolchain 64879b2 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain"
                              "GITHUB https://github.com/riscv/riscv-binutils-gdb 635c14e ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-binutils-gdb"
                              "GITHUB https://github.com/riscv/riscv-dejagnu 2e99dc08 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-dejagnu"
                              "GITHUB https://github.com/riscv/riscv-gcc b731149 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-gcc"
                              "GITHUB https://github.com/riscv/riscv-glibc 2f626de ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-glibc"
                              "GITHUB https://github.com/riscv/riscv-newlib 0bb64b9 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-newlib"
                              "GITHUB https://github.com/riscv/riscv-qemu ff36f2f ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu"
                              "QEMU dtc 65cc4d27 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/dtc"
                              "QEMU SLOF e3d05727 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/SLOF"
                              "QEMU ipxe 04186319 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/ipxe"
                              "QEMU openbios c5542f22 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/openbios"
                              "QEMU openhackware c559da7c ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/openhackware"
                              "QEMU qemu-palcode c87a9263 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/qemu-palcode"
                              "QEMU seabios e2fc41e2 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/seabios"
                              "QEMU sgabios 23d47494 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/sgabios"
                              "QEMU u-boot 2072e726 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/u-boot"
                              "QEMU vgabios 19ea12c2 ./hdl_cores/freedom/rocket-chip/riscv-tools/riscv-gnu-toolchain/riscv-qemu/roms/vgabios"
                              "#"
                              "# The following dependencies are related to the Freedom-U-SDK"
                              "#"
                              "GITHUB https://github.com/mcd500/freedom-u-sdk 29fe529 ./software/freedom-u-sdk"
                              "GITHUB https://github.com/sifive/buildroot c4ddfe7 ./software/freedom-u-sdk/buildroot"
                              "GITHUB https://github.com/riscv/riscv-linux 2751b6aa ./software/freedom-u-sdk/linux"
                              "GITHUB https://github.com/riscv/riscv-fesvr f683e01 ./software/freedom-u-sdk/riscv-fesvr"
                              "GITHUB https://github.com/riscv/riscv-gnu-toolchain b4dae89 ./software/freedom-u-sdk/riscv-gnu-toolchain"
                              "GITHUB https://github.com/riscv/riscv-binutils-gdb d0176cb ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-binutils-gdb"
                              "GITHUB https://github.com/riscv/riscv-dejagnu 5f3adaf ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-dejagnu"
                              "GITHUB https://github.com/riscv/riscv-gcc b731149 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-gcc"
                              "GITHUB https://github.com/riscv/riscv-glibc 2f626de ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-glibc"
                              "GITHUB https://github.com/riscv/riscv-newlib ccd8a0a ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-newlib"
                              "GITHUB https://github.com/riscv/riscv-qemu ff36f2f ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu"
                              "QEMU dtc 65cc4d27 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/dtc"
                              "QEMU SLOF e3d05727 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/SLOF"
                              "QEMU ipxe 04186319 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/ipxe"
                              "QEMU openbios c5542f22 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/openbios"
                              "QEMU openhackware c559da7c ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/openhackware"
                              "QEMU qemu-palcode c87a9263 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/qemu-palcode"
                              "QEMU seabios e2fc41e2 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/seabios"
                              "QEMU sgabios 23d47494 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/sgabios"
                              "QEMU u-boot 2072e726 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/u-boot"
                              "QEMU vgabios 19ea12c2 ./software/freedom-u-sdk/riscv-gnu-toolchain/riscv-qemu/roms/vgabios"
                              "GITHUB https://github.com/riscv/riscv-isa-sim 092b464 ./software/freedom-u-sdk/riscv-isa-sim"
                              "GITHUB https://github.com/riscv/riscv-pk 5a0e3e5 ./software/freedom-u-sdk/riscv-pk"
                              "GITHUB https://github.com/riscv/riscv-qemu ad8989a ./software/freedom-u-sdk/riscv-qemu"
                              "QEMU capstone 22ead3e ./software/freedom-u-sdk/riscv-qemu/capstone"
                              "QEMU keycodemapdb 6b3d716 ./software/freedom-u-sdk/riscv-qemu/ui/keycodemapdb"
                              "QEMU QemuMacDrivers d4e7d7a ./software/freedom-u-sdk/riscv-qemu/roms/QemuMacDrivers"
                              "QEMU SLOF fa98132 ./software/freedom-u-sdk/riscv-qemu/roms/SLOF"
                              "QEMU ipxe 0600d3a ./software/freedom-u-sdk/riscv-qemu/roms/ipxe"
                              "QEMU openbios 54d959d ./software/freedom-u-sdk/riscv-qemu/roms/openbios"
                              "QEMU openhackware c559da7 ./software/freedom-u-sdk/riscv-qemu/roms/openhackware"
                              "QEMU qemu-palcode f3c7e44 ./software/freedom-u-sdk/riscv-qemu/roms/qemu-palcode"
                              "QEMU seabios 0551a4b ./software/freedom-u-sdk/riscv-qemu/roms/seabios"
                              "QEMU seabios-hppa 1ef99a0 ./software/freedom-u-sdk/riscv-qemu/roms/seabios-hppa"
                              "QEMU sgabios cbaee52 ./software/freedom-u-sdk/riscv-qemu/roms/sgabios"
                              "QEMU skiboot e0ee24c ./software/freedom-u-sdk/riscv-qemu/roms/skiboot"
                              "QEMU u-boot d85ca02 ./software/freedom-u-sdk/riscv-qemu/roms/u-boot"
                              "QEMU u-boot-sam460ex 8ee007c ./software/freedom-u-sdk/riscv-qemu/roms/u-boot-sam460ex"
                              "QEMU vgabios 19ea12c ./software/freedom-u-sdk/riscv-qemu/roms/vgabios"
                              "#"
                              "# The following files are related to the automatic generation of cores"
                              "#"
                              "HTTP_FILE http://www.spiral.net/hardware firgen.tgz ./hdl_cores/auto-fir"
                              "HTTP_FILE http://spiral.ece.cmu.edu/mcm/dl synth-jan-14-2009.tar.gz ./hdl_cores/auto-fir"
                              )

# Function to "clone" a directory based on the specified repo (in the repo_names format)
clone_directory() {

  repo_type=$(echo " "$1 | cut -d' ' -f 2)

  case "$repo_type" in
    "#") 
    ;;
    "GITHUB")
      current_repo=$(echo " "$1 | cut -d' ' -f 3)
      current_commit=$(echo " "$1 | cut -d' ' -f 4)
      current_directory=$(echo " "$1 | cut -d' ' -f 5)
      echo
      echo "GITHUB: Exporting repository "$current_repo", Commit" $current_commit" to directory" $current_directory
      echo
      rm -f tmp.tar   # Ensure that the tempary tar does not already exist
      rm -rf $current_directory
      mkdir -p $current_directory
      curl -L $current_repo/tarball/$current_commit > tmp.tar
      tar xf tmp.tar --strip-components=1 -C $current_directory
      rm -f tmp.tar
    ;;
    "QEMU")
      current_repo=$(echo " "$1 | cut -d' ' -f 3)
      current_commit=$(echo " "$1 | cut -d' ' -f 4)
      current_directory=$(echo " "$1 | cut -d' ' -f 5)
      echo
      echo "QEMU: Exporting repository "$current_repo", Commit" $current_commit" to directory" $current_directory
      echo
      rm -f tmp.tgz
      rm -rf $current_directory
      mkdir -p $current_directory
      wget -O tmp.tgz "https://git.qemu.org/?p=${current_repo}.git;a=snapshot;h=${current_commit};sf=tgz"
      tar zxf tmp.tgz --strip-components=1 -C $current_directory
      rm -f tmp.tgz              
    ;;
    "HTTP_FILE")
      current_url=$(echo " "$1 | cut -d' ' -f 3)
      current_file=$(echo " "$1 | cut -d' ' -f 4)
      current_directory=$(echo " "$1 | cut -d' ' -f 5)
      echo
      echo "HTTP: Downloading "$current_file" from "$current_url" to directory" $current_directory
      echo
      wget -O "${current_directory}/${current_file}" "${current_url}/${current_file}" 
    ;;
   esac
}

# "Main" function
number_of_repos=${#repo_names[@]}

echo ""
echo "------------------------------------------------------------------------------------------"
echo "---                       CEP Get External Dependencies Script                         ---"
echo "------------------------------------------------------------------------------------------"
echo " This script should be run from the root directory of your CEP clone."
echo ""

# Check for tools to be installed 
if ! [ -x "$(command -v curl)" ]; then
    echo "Error: curl is not installed on your system.  Install using \"sudo apt install curl\""
    exit 1
fi
if ! [ -x "$(command -v wget)" ]; then
    echo "Error: wget is not installed on your system.  Install using \"sudo apt install wget\""
    exit 1
fi
if ! [ -x "$(command -v tar)" ]; then
    echo "Error: tar is not installed on your system.  Install using \"sudo apt install tar\""
    exit 1
fi

# Update / Create ALL of the dependencies
if [ "$1" == "all" ]; then
  echo
  echo " Target Directories (CAUTION: They may be overwritten):"
  echo
  for (( i=1; i<${number_of_repos}+1; i++ ));
  do
    repo_type=$(echo " "${repo_names[$i-1]} | cut -d' ' -f 2)

    if [ "$repo_type" == "#" ]
    then
        echo ${repo_names[$i-1]}        
    else
        echo " "${repo_names[$i-1]} | cut -d' ' -f 5
    fi
  done

  if [[ ${2^^} != "YES" ]]
  then
    echo
    read -p "Do you wish to continue? " -n 1 -r
    echo    # (optional) move to a new line
  fi

  if [[ $REPLY =~ ^[Yy]$ ]] || [[ ${2^^} == "YES" ]]
  then
    for (( i=1; i<${number_of_repos}+1; i++ ));
    do
      clone_directory "${repo_names[$i-1]}"
    done
  else
    exit 1
  fi

  echo
  echo "-----------------------------------------------------------------"
  echo "---       CEP Get External Dependencies Script Complete       ---"
  echo "-----------------------------------------------------------------"
  echo 

  exit 1

fi  # end if ALL option

if [ "$1" == "append" ]; then

  echo "Appending .gitignore..."

#  echo "# The following directories have been added to match those" >> .gitignore
#  echo "# created by the ./get_external_dependencies.sh script" >> .gitignore

  for (( i=1; i<${number_of_repos}+1; i++ ));
  do
    repo_type=$(echo " "${repo_names[$i-1]} | cut -d' ' -f 2)
    if [ "$repo_type" != "#" ]; then
      echo " "${repo_names[$i-1]} | cut -d' ' -f 5 | tail -c +3 >> .gitignore
    fi
  done

  echo
  echo "-----------------------------------------------------------------"
  echo "---       CEP Get External Dependencies Script Complete       ---"
  echo "-----------------------------------------------------------------"
  echo 

  exit 1

fi  # end of append option

# List ALL of the dependencies
if [ "$1" == "list" ]; then

  for (( i=1; i<${number_of_repos}+1; i++ ));
  do
    repo_type=$(echo " "${repo_names[$i-1]} | cut -d' ' -f 2)

    if [ "$repo_type" == "#" ]
    then
        echo ${repo_names[$i-1]}        
    else
        echo " "${repo_names[$i-1]} | cut -d' ' -f 5
    fi
  done

  echo
  echo "-----------------------------------------------------------------"
  echo "---       CEP Get External Dependencies Script Complete       ---"
  echo "-----------------------------------------------------------------"
  echo 

  exit 1

fi  # end if list option

# Perform a matching update: All modules that match the string
if [ "$1" == "matching" ]; then

  # Create an empty array
  declare -a match_indexes

  # Search through the list of repositories for a recursive substring (do not include
  # Do not include repos that are commented out
  for ((match_index=0; match_index<${number_of_repos}; match_index++)); do

    repo_type=$(echo " "${repo_names[$i-1]} | cut -d' ' -f 2)

    if [[ ${repo_names[$match_index]} == *$2* ]] && [[ ! $repo_type == "#" ]]; then
      match_indexes+=($match_index)
    fi
  done

  # If the match_indexes array length is zero, then no matches were found
  if [ ${#match_indexes[@]}  == 0 ]; then
    echo "No matching repository entry was found for \"$2\""
    echo
    
    exit 1  
  fi

  # A match was found, proceed to getting that specific module
  echo "The following directory(ies) may be overwritten"
  for i in "${match_indexes[@]}"; do
    echo " "${repo_names[$i]} | cut -d' ' -f 5
  done

  if [[ ${3^^} != "YES" ]]
  then
    echo
    read -p "Do you wish to continue? " -n 1 -r
    echo    # (optional) move to a new line
  fi

  if [[ $REPLY =~ ^[Yy]$ ]] || [[ ${3^^} == "YES" ]]
  then

    for i in "${match_indexes[@]}"; do
      clone_directory "${repo_names[$i]}"
    done
  else
    exit 1
  fi # end if $REPLY = Y?

  echo 
  echo "-----------------------------------------------------------------"
  echo "---       CEP Get External Dependencies Script Complete       ---"
  echo "-----------------------------------------------------------------"
  echo 

  exit 1

fi # end if matching option


# Update a specific module IF a match exits
if [ "$1" == "one" ]; then
  
  # Search through the list of repositories for a matching substring
  for ((match_index=0; match_index<${number_of_repos}; match_index++)); do
    if [[ ${repo_names[$match_index]} == *$2* ]]; then
      break;
    fi
  done

  # Save the repo type early
  repo_type=$(echo " "${repo_names[$match_index]} | cut -d' ' -f 2)

  # No match was found
  if [ $match_index == $number_of_repos ] || [ $repo_type == "#" ]; then
    echo "No matching repository entry was found for \"$2\""
    echo
    
    exit 1
  fi

  # A match was found, proceed to getting that specific module
  echo "The following directory may be overwritten"
    echo " "${repo_names[$match_index]} | cut -d' ' -f 5

  if [[ ${3^^} -ne "YES" ]]
  then
    echo
    read -p "Do you wish to continue? " -n 1 -r
    echo    # (optional) move to a new line
  fi

  if [[ $REPLY =~ ^[Yy]$ ]] || [[ ${3^^} == "YES" ]]
  then
    clone_directory "${repo_names[$match_index]}"
  fi  # if $REPLY

  echo 
  echo "-----------------------------------------------------------------"
  echo "---       CEP Get External Dependencies Script Complete       ---"
  echo "-----------------------------------------------------------------"
  echo 

  exit 1

fi # end if one option

echo "Usage:"
echo "  all                    - Get all external dependecies"
echo "  append                 - Append the list of all dependencies to .gitignore"
echo "  one <module>           - Get just <module> dependency"
echo "                           (first match will be selected)"
echo "  matching <module>      - Get all matching <module>"
echo "  list                   - List all external dependecies"
echo ""
echo "  For the options that ask for confirmation, specify a YES as the last"
echo "  argument will automatically confirm the request"
echo ""
exit 0
