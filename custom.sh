#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present DiegroSan (RETROFENIX)

# Esse código foi criado com o intuito de adicionar os cores caso necessário, manualmente e mantê-los atualizados.
# Por padrão, após o reiniciar, os cores serão restaurados. Esse código garantirá que os cores a adcionado não seja apagada 

log_file="/userdata/system/logs/cores.log"
cores_dir="/userdata/cores/libretro"
cores_backup="/userdata/cores/cores_backup"
libretro_dir="/usr/lib/libretro"

mkdir -p "$(dirname "${log_file}")"
mkdir -p "${cores_dir}"
mkdir -p "${cores_backup}"

rm -f "${log_file}"

for core_file in "${libretro_dir}"/*.so; do
    core_name=$(basename "${core_file}")
    
    if [ ! -f "${cores_dir}/${core_name}" ]; then
        echo "Backup do core ${core_name} não encontrado. Criando backup..." >> "${log_file}"
        cp -f "${core_file}" "${cores_dir}/"
        if [ $? -eq 0 ]; then
            echo "Backup de ${core_name} criado com sucesso em ${cores_dir}." >> "${log_file}"
        else
            echo "Erro ao criar backup de ${core_name}." >> "${log_file}"
        fi
    else
        echo "Backup de ${core_name} já existe em ${cores_dir}." >> "${log_file}"
    fi
done

for core_file in "${libretro_dir}"/*.so; do
    core_name=$(basename "${core_file}")
    
    if [ ! -f "${cores_backup}/${core_name}" ]; then
        echo "Backup do core ${core_name} não encontrado. Criando backup..." >> "${log_file}"
        cp -f "${core_file}" "${cores_backup}/"
        if [ $? -eq 0 ]; then
            echo "Backup de ${core_name} criado com sucesso em ${cores_backup}." >> "${log_file}"
        else
            echo "Erro ao criar backup de ${core_name}." >> "${log_file}"
        fi
    else
        echo "Backup de ${core_name} já existe em ${cores_backup}." >> "${log_file}"
    fi
done

if [ ! -d "${libretro_dir}" ]; then
    echo "Erro: o diretório ${libretro_dir} não existe." >> "${log_file}"
    exit 1
fi

rm -rf ${libretro_dir}
sleep 2
ln -s ${cores_dir} ${libretro_dir}

if [ $? -eq 0 ]; then
    echo "Link simbólico criado para ${cores_dir} em ${libretro_dir}." >> "${log_file}"
else
    echo "Erro ao criar o link simbólico para ${cores_dir} em ${libretro_dir}." >> "${log_file}"
fi

exit 0
