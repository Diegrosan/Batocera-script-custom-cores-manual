#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present RETROFENIX (DiegroSan)
# Esse código foi criado com o intuito de adicionar os cores caso necessário, manualmente e mantê-los atualizados.
# Por padrão após ao reiniciar, os cores serão restaurados, esse código garantirá a pasta cores não seja apagada 
# (A pasta cores e o padrão do sistema) estaram disponíveis. Caso não haja arquivos na pasta cores,
# o Batocera usará os cores padrão do sistema.


log_file="/userdata/system/logs/cores.log"
cores_dir="/userdata/cores/"
libretro_dir="/usr/lib/libretro/"

mkdir -p $(dirname ${log_file})
mkdir -p ${cores_dir}

rm -f ${log_file}

if [ ! -d ${libretro_dir} ]; then
    echo "Erro: o diretório ${libretro_dir} não existe." >> "$log_file"
    exit 1
fi

for core_file in ${cores_dir}*_libretro.so; do
    core_name=$(basename ${core_file})
    target_file="${libretro_dir}${core_name}"
    
    if [ -f "${target_file}" ]; then
        rm -f "${target_file}"
        echo "Arquivo ${core_name} removido de ${libretro_dir}." >> "$log_file"
    fi
    
    ln -s ${core_file} ${target_file}
    if [ $? -eq 0 ]; then
        echo "Link simbólico criado para ${core_file} em ${libretro_dir}." >> "$log_file"
    else
        echo "Erro ao criar o link simbólico para ${core_file} em ${libretro_dir}." >> "$log_file"
    fi
done

exit 0
