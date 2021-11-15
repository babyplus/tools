import os
import shutil
import zipfile
from PyPDF4 import PdfFileMerger
import time


def get_files():
    files = os.listdir(global_path)
    return files


def process(path):
    if zipfile.is_zipfile(path):
        zip_file = zipfile.ZipFile(path)
        files = zip_file.namelist()
        file_index = 0
        for file in files:
            zip_file.extract(file, global_temp_path)
            origin_file_name = global_temp_path + "/" + file
            target_file_name = global_temp_path + "/" + str(global_file_index) + str(file_index) + ".pdf"
            os.rename(origin_file_name, target_file_name)
            merger.append(target_file_name)
            file_index += 1
        zip_file.close()
    elif path.endswith(".pdf"):
        merger.append(path)
    else:
        print("warring: unsupported file({})".format(path))


if __name__ == '__main__':
    global_path = 'C:/Users/root/Documents/六捷/202111/211109.黄汉加.交通发票'
    global_temp_path = global_path + "_unzip_temp_{}".format(time.time_ns())
    output = global_path + "/output.pdf".format()
    global_pdf_file = []
    global_file_index = 0

    try:
        os.remove(output)
    except FileNotFoundError:
        pass

    merger = PdfFileMerger()

    for file_path in get_files():
        process(global_path + "/" + file_path)
        global_file_index += 1

    merger.write(output)
    merger.close()
    shutil.rmtree(global_temp_path, True)
