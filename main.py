# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

time = [
    "00:00",
    "00:15",
    "00:30",
    "00:45",
    "01:00",
    "01:15",
    "01:30",
    "01:45",
    "02:00",
    "02:15",
    "02:30",
    "02:45",
    "03:00",
    "03:15",
    "03:30",
    "03:45",
    "04:00",
    "04:15",
    "04:30",
    "04:45",
    "05:00",
    "05:15",
    "05:30",
    "05:45",
    "06:00",
    "06:15",
    "06:30",
    "06:45",
    "07:00",
    "07:15",
    "07:30",
    "07:45",
    "08:00",
    "08:15",
    "08:30",
    "08:45",
    "09:00",
    "09:15",
    "09:30",
    "09:45",
    "10:00",
    "10:15",
    "10:30",
    "10:45",
    "11:00",
    "11:15",
    "11:30",
    "11:45",
    "12:00",
    "12:15",
    "12:30",
    "12:45",
    "13:00",
    "13:15",
    "13:30",
    "13:45",
    "14:00",
    "14:15",
    "14:30",
    "14:45",
    "15:00",
    "15:15",
    "15:30",
    "15:45",
    "16:00",
    "16:15",
    "16:30",
    "16:45",
    "17:00",
    "17:15",
    "17:30",
    "17:45",
    "18:00"
]

opt = Options()
# opt.add_argument('--headless')

driver = Chrome(options=opt)


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    driver.implicitly_wait(10)
    driver.get("http://www.baidu.com")
    kw = driver.find_element(By.ID, "kw")
    kw.send_keys("test")

    submit = driver.find_element(By.ID, "su")
    submit.click()

    test = driver.find_element(By.ID, "virus-2020")
    text = test.get_property("name")
    print(text)

    # driver.refresh()

    print("123")


def print_hi2(name):
    # Use a breakpoint in the code line below to debug your script.
    driver.implicitly_wait(10)
    driver.get("http://192.168.102.15:5000/auth/login")
    username = driver.find_element(By.ID, "username")
    username.send_keys("admin")
    password = driver.find_element(By.ID, "password")
    password.send_keys("admin")

    submit = driver.find_element(By.XPATH, "/html/body/div/section/div/div/div/div/form/div[3]/button")
    submit.click()

    for n in range(3):
        url = "http://192.168.102.15:5000/?start=2021-09-30%20{start}:00&end=2021-09-30%20{end}:00&ip=10.150.0.10"
        temp = {"start": time[n], "end": time[n+1]}
        driver.get(url.format(**temp))
        export = driver.find_element(By.XPATH, "/html/body/div[1]/section/div[1]/div/div/div/form/div/div[3]/button[2]")
        export.click()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi2('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

