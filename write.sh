#/bin/sh

#0 NONE		-> Ne rien afficher.
#1 FATAL	-> Situation d’erreur critique, qui entraîne un blocage voire un arrêt du système. (Affiche : 1)
#2 ERROR	-> Situation d’erreur ou inattendue, qui n’entraine pas forcément une situation de blocage. (Affiche : 2-1)
#3 WARN		-> Situation d’exécution non idéale. (Affiche : 3-2-1)
#4 INFO		-> Information essentielle sur le programme, suivi de l’exécution d’un point de vue global. (Affiche : 4-3-2-1)
#5 DEBUG	-> Information détaillée pour le suivi d’exécution du programme. (Affiche : 5-4-3-2-1)
#6 TRACE	-> Niveau d’information ultrafin. (Affiche : 6-5-4-3-2-1)

OUTPUT_CMD_LEVEL='TRACE'
OUTPUT_LOG_LEVEL='DEBUG'
DATE=$(date +%Y-%m-%d)
WRITE_LOG_PATH="output_${DATE}.log"

declare -A CLR_WRITE_LEVEL
CLR_WRITE_LEVEL['TRACE']="1;30"
CLR_WRITE_LEVEL['DEBUG']="1;34"
CLR_WRITE_LEVEL['INFO']="1;36"
CLR_WRITE_LEVEL['WARN']="1;33"
CLR_WRITE_LEVEL['ERROR']="1;31"
CLR_WRITE_LEVEL['FATAL']="1;35"
CLR_WRITE_LEVEL['RAZ']="0"

## PARAMS ##
# $1 = Niveau (TRACE, DEBUG, INFO ...)
# $2 = Texte
# $3 = Pas de retour à la ligne (-n)
write_level(){
	declare -A LOG_LEVEL=(['NONE']=0 ['FATAL']=1 ['ERROR']=2 ['WARN']=3 ['INFO']=4 ['DEBUG']=5 ['TRACE']=6)
	local DATE=$(date)
	## Si -n pas de retour à la ligne ##
	if [[ ${3} == "-n" ]];then
		local saut='n'
	fi
	## Si niveau attendu est plus grand ou égale au niveau demandé ##
	# Pour les commandes
	if [[ ${LOG_LEVEL[${OUTPUT_CMD_LEVEL}]} -ge ${LOG_LEVEL[${1}]} ]];then
		echo -e${saut} "\\033[${CLR_WRITE_LEVEL[${1}]}m${2}\\033[${CLR_WRITE_LEVEL['RAZ']}m"
	fi
	# Pour les logs
	if [[ ${LOG_LEVEL[${OUTPUT_LOG_LEVEL}]} -ge ${LOG_LEVEL[${1}]} ]];then
		echo "[${DATE}][${1}] ${2}" >> ${WRITE_LOG_PATH}
	fi
}

write_trace(){
	write_level "TRACE" "${1}" "${2}"
}
write_debug(){
	write_level "DEBUG" "${1}" "${2}"
}
write_info(){
	write_level "INFO" "${1}" "${2}"
}
write_warning(){
	write_level "WARN" "${1}" "${2}"
}
write_error(){
	write_level "ERROR" "${1}" "${2}"
}
write_fatal(){
	write_level "FATAL" "${1}" "${2}"
}

write_warning "teste"