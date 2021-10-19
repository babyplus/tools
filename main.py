import os
import zipfile
from PyPDF4 import PdfFileMerger


def get_files():
    files = os.listdir(global_path)
    return files


def unzip(path):
    if zipfile.is_zipfile(path):
        zip_file = zipfile.ZipFile(path)
        files = zip_file.namelist()
        file_index = 0
        for file in files:
            zip_file.extract(file, global_temp_path)
            origin_file_name = global_temp_path + "/" + file
            target_file_name = global_temp_path + "/" + str(global_file_index) + str(file_index) + ".pdf"
            os.rename(origin_file_name, target_file_name)
            input_file = open(target_file_name, "rb")
            input_list.append(input_file)
            merger.append(input_file)
            file_index += 1
        zip_file.close()


if __name__ == '__main__':
    global_path = 'C:/Users/root/Downloads/新建文件夹/'
    global_temp_path = global_path + "unzip_temp"
    output = global_path + "output.pdf"
    input_list = []
    global_pdf_file = []
    global_file_index = 0

    try:
        os.remove(output)
    except FileNotFoundError:
        pass

    merger = PdfFileMerger()

    for zip_path in get_files():
        unzip(global_path + "/" + zip_path)
        global_file_index += 1

    merger.write(output)

    for i in input_list:
        i.close()
