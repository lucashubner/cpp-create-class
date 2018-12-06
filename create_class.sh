#! /bin/bash
#########################################################################
function showHelp {
	echo "create_class.sh (ClassName) {(type):(attribute_name) ...}"
	exit
}
#########################################################################

CLASS_NAME=$1

if [[ $1 == "" ]];
then
	showHelp
fi
shift

LIST_SIZE="0"

# Checa parâmetros
for ARG in $*
	do
	TYPE=$(echo $ARG | awk -F ":" '{print $1}')
	VAR_NAME=$(echo $ARG |awk -F ":" '{print $2}')
	
	TYPES["$TYPE"]=1
	echo $TYPE

	if [[ $TYPE == "" || $VAR_NAME == "" ]];
	then
		echo "Malformed parameteres...."
		echo "\t Type: $TYPE"
		echo "\t Attribute Name: $VAR_NAME"
		showHelp
	fi
done

for K in "${!TYPES[@]}"; do echo $K; done


#########################################################################
function getUserName {
	return $(git config user.name)
}
function getUserEmail {
	return $(git config user.email)
}
#########################################################################
#Finaliza arquivo .h
function writeHeaderEnd {
cat >> $CLASS_NAME.h << @EOF 
};
#endif // SRC_$(echo $CLASS_NAME | awk '{print toupper($0)}')_H_

@EOF
}
#########################################################################
function writeHeaderMiddle {
#Escreve as definições de funções no header
cat >> $CLASS_NAME.h << @EOF 
public:
	$CLASS_NAME();
	~$CLASS_NAME();
@EOF
}
#########################################################################
function writeHeaderBegin {
# INICIO DO HEADER 
# Escreve a parte inicial do header
cat > $CLASS_NAME.h << @EOF 

/**
 * @file $CLASS_NAME.h
 *
 * @brief This message displayed in Doxygen Files index
 *
 * @ingroup PackageName
 * (Note: this needs exactly one @defgroup somewhere)
 *
 * @author  $(getUserName)
 * Contact: $(getUserEmail)
 *
 */
#ifndef SRC_$(echo $CLASS_NAME | awk '{print toupper($0)}')_H_
#define SRC_$(echo $CLASS_NAME | awk '{print toupper($0)}')_H_

class $CLASS_NAME{
@EOF
}
#########################################################################
function writeAttributeHeader {
	TYPE=$(echo $1 | awk -F ":" '{print $1}')
	VAR_NAME=$(echo $1 |awk -F ":" '{print $2}')
# INICIO DO HEADER 
cat >> $CLASS_NAME.h << @EOF 
	$TYPE $VAR_NAME;
@EOF
}

#########################################################################
function writeFunctionDef {
	TYPE=$(echo $1 | awk -F ":" '{print $1}')
	VAR_NAME=$(echo $1 |awk -F ":" '{print $2}')
cat >> $CLASS_NAME.h << @EOF 
	$TYPE get${VAR_NAME^}();
	void set${VAR_NAME^}($TYPE $VAR_NAME);

@EOF
}
########################################################################
function writeCppBegin {
cat >> $CLASS_NAME.cpp <<  @EOF 
#include "$CLASS_NAME.h"

$CLASS_NAME::$CLASS_NAME(){
}
$CLASS_NAME::~$CLASS_NAME(){
}
@EOF
}
########################################################################
function writeCpp {
	TYPE=$(echo $1 | awk -F ":" '{print $1}')
	VAR_NAME=$(echo $1 |awk -F ":" '{print $2}')

cat >> $CLASS_NAME.cpp <<  @EOF 
$TYPE $CLASS_NAME::get${VAR_NAME^}(){
	return this->$VAR_NAME;
}

void $CLASS_NAME::set${VAR_NAME^}($TYPE $VAR_NAME){
	this->$VAR_NAME = $VAR_NAME;
}

@EOF
}
#########################################################################
# Trunca arquivos
echo "" > $CLASS_NAME.h
echo "" > $CLASS_NAME.cpp
# INICIO DO CPP
writeCppBegin
writeHeaderBegin

for ARG in $*
	do
	writeCpp $ARG
	writeAttributeHeader $ARG
done

writeHeaderMiddle

for ARG in $*
	do
	writeFunctionDef $ARG
done


writeHeaderEnd
