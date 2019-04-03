# /bin/bash
#########################################################################
function showHelp {
	echo "create_cmake_project.sh ProjectName"
	exit
}
#########################################################################

PROJECT_NAME=$1

if [[ $1 == "" ]];
then
	showHelp
fi

mkdir src
mkdir build

cat >> CMakeLists.txt << @EOF 
# Versão Mínima Para o CMAKE
cmake_minimum_required(VERSION 2.8)
project($PROJECT_NAME)

file (GLOB_RECURSE srcs
  "src/*.hpp"
  "src/*.cpp"
  "src/*.h"
  "src/*.c"
)

# compila o executável
add_executable($PROJECT_NAME \${srcs})

@EOF

cat >> src/main.cpp << @EOF 

#include <cstdio>

int main(int argc, char *argv[]){

}

@EOF

