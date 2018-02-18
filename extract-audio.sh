#!/bin/bash

# For ramhlun_south_hs_dated_24-01-2017 and durtlang_hs_data_extraction_english_23-01-2017

# cur_dir=$1
# cd $cur_dir
# zip_files=($(ls *.zip))


# # for each zip file
# for ((i=0; i<${#zip_files[@]}; ++i));
# do

#     echo "unzip ${zip_files[$i]}"
#     unzip "${zip_files[$i]}"
 
#     # Remove spaces from the files and folder names
#     find -iname "* *" -type f | rename 's/ /_/g'
#     find -iname "* *" -type d | rename 's/ /_/g'

#     #unzip pc3-Program_FilesCLIxModules_v1.0.8-QBank-2017-01-23-11-04-48.zip 
#     new_audio_filename="$cur_dir-$(echo ${zip_files[$i]} | cut -d- -f1)" ;

#     dir_extracted=$(ls -d */)
#     cd ${dir_extracted}repository/AssetContent/
    
#     echo "Here3 : $(pwd): ${dir_extracted}"
#     audio_files=($(ls *))
#     # for each audio file
#     for ((m=0; m<${#audio_files[@]}; ++m));
#     do
#         new_audio_filename_final=$new_audio_filename-${audio_files[$m]}
#         if [[ ! -d ../../../../$cur_dir-extracted ]]; then
#             mkdir -p ../../../../$cur_dir-extracted
#         fi 
#         echo "        rsync -avzPh ${audio_files[$m]}      ../../../../$cur_dir-extracted/$new_audio_filename_final"
#         rsync -avzPh ${audio_files[$m]}      ../../../../$cur_dir-extracted/$new_audio_filename_final
#     done
#     cd -
#     rm -rf /tmp/${dir_extracted}
#     mv ${dir_extracted} /tmp/
# #    rm -rf /tmp/${dir_extracted}
# done



# for bethlehem_HS_student_artefacts
cur_dir=$1
cd $cur_dir

dir_names=($(ls -d */))
# for each directory names
for ((m=0; m<${#dir_names[@]}; ++m));
do
    
    cd "${dir_names[$m]}"
    #echo "pwd: $(pwd) : $(ls ) :: dir name - ${dir_names[$m]}"
    echo "${dir_names[@]} dir name (${#dir_names[@]}) - $m - ${dir_names[$m]}"

    zip_files=($(ls *.zip))

    # for each zip file
    for ((i=0; i<${#zip_files[@]}; ++i));
    do

        echo "unzip ${zip_files[$i]}"
        unzip "${zip_files[$i]}"  >> /dev/null
    
        # Remove spaces from the files and folder names
        find -iname "* *" -type f | rename 's/ /_/g'
        find -iname "* *" -type d | rename 's/ /_/g'

        #unzip pc3-Program_FilesCLIxModules_v1.0.8-QBank-2017-01-23-11-04-48.zip 
        new_audio_filename="$cur_dir-$(echo ${dir_names[$m]} | cut -d/ -f1)" ;

        dir_extracted=$(ls -d */)
        cd ${dir_extracted}repository/AssetContent/
        
        echo "Here3 : $(pwd): ${dir_extracted}"
        audio_files=($(ls *))
        # for each audio file
        for ((n=0; n<${#audio_files[@]}; ++n));
        do
            new_audio_filename_final=$new_audio_filename-${audio_files[$n]}
            if [[ ! -d ../../../../../$cur_dir-extracted ]]; then
                mkdir -p ../../../../../$cur_dir-extracted
            fi 

            echo "        rsync -avzPh ${audio_files[$n]}      ../../../../../$cur_dir-extracted/$new_audio_filename_final"
            rsync -avzPh ${audio_files[$n]}      ../../../../../$cur_dir-extracted/$new_audio_filename_final

        done
        cd -
        echo "Here:::::$(pwd)"
        rm -rf /tmp/${dir_extracted}
        mv ${dir_extracted} /tmp/
    #    rm -rf /tmp/${dir_extracted}
        cd ..
    done
done