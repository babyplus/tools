# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

import xlrd
from xlutils.copy import copy
import sys


def _handle(cell):
    # ctype： 0 empty,1 string, 2 number, 3 date, 4 boolean, 5 error
    # if 0 == cell.ctype:
    #     value = ""
    # elif 1 == cell.ctype:
    #     value = cell.value
    # elif 2 == cell.ctype and 0 == cell.value % 1:
    #     print("整数")
    #     value = str(int(cell.value))
    # elif 2 == cell.ctype and 0 != cell.value % 1:
    #     print("浮点数")
    #     value = str(cell.value)
    return "" if 0 == cell.ctype else (cell.value if 1 == cell.ctype else (
            str(int(cell.value)) if (2 == cell.ctype and 0 == cell.value % 1) else str(cell.value)))


def handle(cell):
    return _handle(cell).strip()


def read(change_xls):
    workbook = xlrd.open_workbook(change_xls)
    sheet = workbook.sheet_by_index(0)
    rows = sheet.nrows
    for row in range(0, rows):
        word = [handle(sheet.row(row)[0]), handle(sheet.row(row)[1])]
        words.append(word)


def change(excel_file_name, sheet_name, target_file_name):
    workbook = xlrd.open_workbook(excel_file_name)
    sheet = workbook.sheet_by_name(sheet_name)
    rows = sheet.nrows
    cols = sheet.ncols
    copybook = copy(workbook)
    copybook_sheet = copybook.get_sheet(sheet_name)

    for row in range(0, rows):
        for col in range(0, cols):
            content = handle(sheet.cell(row, col))
            content_size = len(content)
            for word in words:
                word_size = len(word[0])
                if -1 != content.find(word[0]) and word_size == content_size:
                    copybook_sheet.write(row, col, word[1])

    copybook.save(target_file_name)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    '''
    example:
        python main.py origin.xls sheet1 keyword.xls target.xls
    '''
    words = []
    read(sys.argv[1:][2])
    print(words)
    change(sys.argv[1:][0], sys.argv[1:][1], sys.argv[1:][3])

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
