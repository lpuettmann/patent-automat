from scipy.io import loadmat
import pandas as pd
import os
import multiprocessing as mp
import re
import numpy as np




### Combine Series to a DataFrame
def create_dataframe(elem1, elem2):
    df = pd.concat([elem1, elem2], axis=1)
    return df



def create_file(file):
    mat = loadmat(file)
    mdata = mat['patsearch_results'][0]
    df = pd.DataFrame().fillna(0) ### Initialise DataFrame
    for key in ['patentnr', 'classnr']:
        series = pd.Series([mdata[key][0][x][0][0] for x in range(mdata['patentnr'][0].shape[0])], name=key)
        df = create_dataframe(df, series)
    for key in ['week']:
        series = pd.Series([mdata[key][0][x][0][0][0] for x in range(mdata['patentnr'][0].shape[0])], name=key)
        df = create_dataframe(df, series)
    for key in ['length_pattext']:
        series = pd.Series([mdata[key][0][x][0] for x in range(mdata['patentnr'][0].shape[0])], name=key)
        df = create_dataframe(df, series)
    for key in ['title_matches', 'abstract_matches', 'body_matches']:
        df_sub = pd.DataFrame(mdata[key][0])
        df_sub.columns = [key + '_' + mdata['dictionary'][0][0][x][0] for x in range(mdata['dictionary'][0].shape[1])]
        df = create_dataframe(df, df_sub)
    year = re.compile("[0-9]{4}").findall(file)
    df['year'] = year*mdata['patentnr'][0].shape[0]
    df.to_csv('patsearch_results_' + year[0] + '.csv') #change name



def multi(file_array):
    pool = mp.Pool(mp.cpu_count()) # detects logical cpus (with hyperthreading)     # If you want to restrict the number of cpus change it to <<pool = mp.Pool(#numberofcpus)>>
    pool.map_async(create_file, file_array).get()

def combine_dataframes(array):
    df = pd.concat([pd.read_csv(file, index_col=0, dtype={'patentnr':np.int,'classnr':object,'week':np.int,'length_pattext':np.int,'title_matches_automat':np.int,'title_matches_robot':np.int,'title_matches_movable arm':np.int,'title_matches_algorithm':np.int,'title_matches_manual':np.int,'title_matches_software':np.int,'title_matches_computer':np.int,'title_matches_program':np.int,'title_matches_digital':np.int,'title_matches_autonomous':np.int,'title_matches_adaptive':np.int,'title_matches_self-adjust':np.int,'title_matches_self-generat':np.int,'title_matches_detect':np.int,'title_matches_independent':np.int,'title_matches_motor':np.int,'title_matches_engine':np.int,'title_matches_communicat':np.int,'title_matches_semi-conductor':np.int,'title_matches_semiconductor':np.int,'title_matches_chip':np.int,'title_matches_bus':np.int,'title_matches_circuit':np.int,'title_matches_circuitry':np.int,'title_matches_antigen':np.int,'title_matches_antigenic':np.int,'title_matches_chromatography':np.int,'abstract_matches_automat':np.int,'abstract_matches_robot':np.int,'abstract_matches_movable arm':np.int,'abstract_matches_algorithm':np.int,'abstract_matches_manual':np.int,'abstract_matches_software':np.int,'abstract_matches_computer':np.int,'abstract_matches_program':np.int,'abstract_matches_digital':np.int,'abstract_matches_autonomous':np.int,'abstract_matches_adaptive':np.int,'abstract_matches_self-adjust':np.int,'abstract_matches_self-generat':np.int,'abstract_matches_detect':np.int,'abstract_matches_independent':np.int,'abstract_matches_motor':np.int,'abstract_matches_engine':np.int,'abstract_matches_communicat':np.int,'abstract_matches_semi-conductor':np.int,'abstract_matches_semiconductor':np.int,'abstract_matches_chip':np.int,'abstract_matches_bus':np.int,'abstract_matches_circuit':np.int,'abstract_matches_circuitry':np.int,'abstract_matches_antigen':np.int,'abstract_matches_antigenic':np.int,'abstract_matches_chromatography':np.int,'body_matches_automat':np.int,'body_matches_robot':np.int,'body_matches_movable arm':np.int,'body_matches_algorithm':np.int,'body_matches_manual':np.int,'body_matches_software':np.int,'body_matches_computer':np.int,'body_matches_program':np.int,'body_matches_digital':np.int,'body_matches_autonomous':np.int,'body_matches_adaptive':np.int,'body_matches_self-adjust':np.int,'body_matches_self-generat':np.int,'body_matches_detect':np.int,'body_matches_independent':np.int,'body_matches_motor':np.int,'body_matches_engine':np.int,'body_matches_communicat':np.int,'body_matches_semi-conductor':np.int,'body_matches_semiconductor':np.int,'body_matches_chip':np.int,'body_matches_bus':np.int,'body_matches_circuit':np.int,'body_matches_circuitry':np.int,'body_matches_antigen':np.int,'body_matches_antigenic':np.int,'body_matches_chromatography':np.int,'year':np.int,'title_matches_mechaniz':np.int,'title_matches_system and method':np.int,'title_matches_method and system':np.int,'title_matches_machine':np.int,'title_matches_aparatus':np.int,'title_matches_determine':np.int,'title_matches_determining':np.int,'abstract_matches_mechaniz':np.int,'abstract_matches_system and method':np.int,'abstract_matches_method and system':np.int,'abstract_matches_machine':np.int,'abstract_matches_aparatus':np.int,'abstract_matches_determine':np.int,'abstract_matches_determining':np.int,'body_matches_mechaniz':np.int,'body_matches_system and method':np.int,'body_matches_method and system':np.int,'body_matches_machine':np.int,'body_matches_aparatus':np.int,'body_matches_determine':np.int,'body_matches_determining':np.int}) for file in array], ignore_index=True)
    df.to_csv('patsearch_results_1976-2015.csv')


### Start parallel computing of the files
if __name__ == '__main__': # function to check whether the file is called standalone or as a module; somehow important to mp?!
    mat_array = []
    answer_1 = input('Do you want to convert .mat to .csv (0) or combine .csv files to one (1)? Enter 0 or 1\n-->')
    if answer_1 == '0':
        answer_10 = input('Are the Matlab-files in the python-file\'s directory (y/n)?\n-->')
        if answer_10 == 'y':
             ### Read file names
            for file in os.listdir(os.getcwd()):
                if file.endswith(".mat"):
                    mat_array.append(file)
            multi(mat_array)
        else:
            path = input('Enter the path: (e.g. C:\...)\n-->')
            os.chdir(path)
            ### Read file names
            for file in os.listdir(os.getcwd()):
                if file.endswith(".mat"):
                    mat_array.append(file)
            multi(mat_array)
    else:
        answer_11 = input('Are the CSV-files in the python-file\'s directory (y/n)?\n-->')
        csv_array = []
        if answer_11 == 'y':
             ### Read file names
            for file in os.listdir(os.getcwd()):
                if file.endswith(".csv"):
                    csv_array.append(file)
            combine_dataframes(csv_array)
        else:
            path = input('Enter the path: (e.g. C:\...)\n-->')
            os.chdir(path)
            ### Read file names
            for file in os.listdir(os.getcwd()):
                if file.endswith(".csv"):
                    csv_array.append(file)
            combine_dataframes(csv_array)


########################################################### Ideas to improve the code #################################################
###		-	the multiprocessing package seems to seperate the file load into packs for each logical processor. Because of that, some instances finish far earlier than others.
###			The tool should make a stack of files and distribute it to a processor when it is not busy.
###
###     -   Add a progressbar to the instances


### dtype={'patentnr':np.int,'classnr':object,'week':np.int,'length_pattext':np.int,'title_matches_automat':np.int,'title_matches_robot':np.int,'title_matches_movable arm':np.int,'title_matches_algorithm':np.int,'title_matches_manual':np.int,'title_matches_software':np.int,'title_matches_computer':np.int,'title_matches_program':np.int,'title_matches_digital':np.int,'title_matches_autonomous':np.int,'title_matches_adaptive':np.int,'title_matches_self-adjust':np.int,'title_matches_self-generat':np.int,'title_matches_detect':np.int,'title_matches_independent':np.int,'title_matches_motor':np.int,'title_matches_engine':np.int,'title_matches_communicat':np.int,'title_matches_semi-conductor':np.int,'title_matches_semiconductor':np.int,'title_matches_chip':np.int,'title_matches_bus':np.int,'title_matches_circuit':np.int,'title_matches_circuitry':np.int,'title_matches_antigen':np.int,'title_matches_antigenic':np.int,'title_matches_chromatography':np.int,'abstract_matches_automat':np.int,'abstract_matches_robot':np.int,'abstract_matches_movable arm':np.int,'abstract_matches_algorithm':np.int,'abstract_matches_manual':np.int,'abstract_matches_software':np.int,'abstract_matches_computer':np.int,'abstract_matches_program':np.int,'abstract_matches_digital':np.int,'abstract_matches_autonomous':np.int,'abstract_matches_adaptive':np.int,'abstract_matches_self-adjust':np.int,'abstract_matches_self-generat':np.int,'abstract_matches_detect':np.int,'abstract_matches_independent':np.int,'abstract_matches_motor':np.int,'abstract_matches_engine':np.int,'abstract_matches_communicat':np.int,'abstract_matches_semi-conductor':np.int,'abstract_matches_semiconductor':np.int,'abstract_matches_chip':np.int,'abstract_matches_bus':np.int,'abstract_matches_circuit':np.int,'abstract_matches_circuitry':np.int,'abstract_matches_antigen':np.int,'abstract_matches_antigenic':np.int,'abstract_matches_chromatography':np.int,'body_matches_automat':np.int,'body_matches_robot':np.int,'body_matches_movable arm':np.int,'body_matches_algorithm':np.int,'body_matches_manual':np.int,'body_matches_software':np.int,'body_matches_computer':np.int,'body_matches_program':np.int,'body_matches_digital':np.int,'body_matches_autonomous':np.int,'body_matches_adaptive':np.int,'body_matches_self-adjust':np.int,'body_matches_self-generat':np.int,'body_matches_detect':np.int,'body_matches_independent':np.int,'body_matches_motor':np.int,'body_matches_engine':np.int,'body_matches_communicat':np.int,'body_matches_semi-conductor':np.int,'body_matches_semiconductor':np.int,'body_matches_chip':np.int,'body_matches_bus':np.int,'body_matches_circuit':np.int,'body_matches_circuitry':np.int,'body_matches_antigen':np.int,'body_matches_antigenic':np.int,'body_matches_chromatography':np.int,'year':np.int}

# dtypestring = """dtype={'patentnr':np.int,'classnr':object,'week':np.int,'length_pattext':np.int,
# 'title_matches_automat':np.int,'title_matches_robot':np.int,
# 'title_matches_movable arm':np.int,'title_matches_algorithm':np.int,
# 'title_matches_manual':np.int,'title_matches_software':np.int,'title_matches_computer':np.int,
# 'title_matches_program':np.int,'title_matches_digital':np.int,'title_matches_autonomous':np.int,
# 'title_matches_adaptive':np.int,'title_matches_self-adjust':np.int,
# 'title_matches_self-generat':np.int,'title_matches_detect':np.int,
# 'title_matches_independent':np.int,'title_matches_motor':np.int,'title_matches_engine':np.int,
# 'title_matches_communicat':np.int,'title_matches_semi-conductor':np.int,
# 'title_matches_semiconductor':np.int,'title_matches_chip':np.int,'title_matches_bus':np.int,
# 'title_matches_circuit':np.int,'title_matches_circuitry':np.int,'title_matches_antigen':np.int,
# 'title_matches_antigenic':np.int,'title_matches_chromatography':np.int,
# 'abstract_matches_automat':np.int,'abstract_matches_robot':np.int,
# 'abstract_matches_movable arm':np.int,'abstract_matches_algorithm':np.int,
# 'abstract_matches_manual':np.int,'abstract_matches_software':np.int,
# 'abstract_matches_computer':np.int,'abstract_matches_program':np.int,
# 'abstract_matches_digital':np.int,'abstract_matches_autonomous':np.int,
# 'abstract_matches_adaptive':np.int,'abstract_matches_self-adjust':np.int,
# 'abstract_matches_self-generat':np.int,'abstract_matches_detect':np.int,
# 'abstract_matches_independent':np.int,'abstract_matches_motor':np.int,
# 'abstract_matches_engine':np.int,'abstract_matches_communicat':np.int,
# 'abstract_matches_semi-conductor':np.int,'abstract_matches_semiconductor':np.int,
# 'abstract_matches_chip':np.int,'abstract_matches_bus':np.int,'abstract_matches_circuit':np.int,
# 'abstract_matches_circuitry':np.int,'abstract_matches_antigen':np.int,
# 'abstract_matches_antigenic':np.int,'abstract_matches_chromatography':np.int,
# 'body_matches_automat':np.int,'body_matches_robot':np.int,'body_matches_movable arm':np.int,
# 'body_matches_algorithm':np.int,'body_matches_manual':np.int,'body_matches_software':np.int,
# 'body_matches_computer':np.int,'body_matches_program':np.int,'body_matches_digital':np.int,
# 'body_matches_autonomous':np.int,'body_matches_adaptive':np.int,
# 'body_matches_self-adjust':np.int,'body_matches_self-generat':np.int,
# 'body_matches_detect':np.int,'body_matches_independent':np.int,'body_matches_motor':np.int,
# 'body_matches_engine':np.int,'body_matches_communicat':np.int,
# 'body_matches_semi-conductor':np.int,'body_matches_semiconductor':np.int,
# 'body_matches_chip':np.int,'body_matches_bus':np.int,'body_matches_circuit':np.int,
# 'body_matches_circuitry':np.int,'body_matches_antigen':np.int,
# 'body_matches_antigenic':np.int,'body_matches_chromatography':np.int,'year':np.int}"""


#'title_matches_mechaniz':np.int,'title_matches_system and method':np.int,'title_matches_method and system':np.int,'title_matches_machine':np.int,'title_matches_aparatus':np.int,'title_matches_determine':np.int,'title_matches_determining':np.int