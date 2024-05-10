import logging

from PySide6.QtCore import Qt, Slot
from PySide6.QtSql import QSqlDatabase, QSqlQuery, QSqlTableModel
from PySide6.QtQml import QmlElement

table_name = "Accounts"
QML_IMPORT_NAME = "AccountModel"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

def createTable():
    if table_name in QSqlDatabase.database().tables():
        return

@QmlElement
class SqlLoginModel(QSqlTableModel):
    def __init__(self, parent=None):
        super(SqlLoginModel, self).__init__(parent)

        createTable()
        self.setTable(table_name)
        self.setSort(2, Qt.DescendingOrder)
        self.setEditStrategy(QSqlTableModel.OnRowChange)
        self.number = '0000000000'
        self.password = ''
        self.name = 'Клієнт'
        self.user_id = 0
        self.session_id = 0

        self.select()
        logging.debug("Table was loaded successfully.")

    @Slot(str, str, int)
    def registration(self, number, password, user_tariff): # CHECK

        new_record = self.record()
        new_record.setValue("number", number)
        new_record.setValue("password", password)
        new_record.setValue("user_tariff", user_tariff)

        logging.debug(f'Tariff: "{user_tariff}" \n User: "{number}"')

        if not self.insertRecord(self.rowCount(), new_record):
            logging.error("Registration failed: {self.lastError().text()}")
            return

        self.submitAll()
        self.select()

    @Slot(str, str, result=list)
    def login(self, number, password):
        messages = ["Такого номера не існує!", "Користувача з таким номером не існує!", "Введено неправильний праоль", "Вітаю %s!"]
        query = QSqlQuery(f"SELECT User_id FROM Mobile_number WHERE Number = '{number}'")
        if query.next():
            user_id = query.value(0)
            query = QSqlQuery(f"SELECT Password, Name FROM User_info WHERE User_id = '{user_id}'")
            if query.next():
                if password == query.value(0):
                    self.number = number
                    self.password = password
                    self.name = query.value(1)
                    self.user_id = user_id
                    return [messages[3] % query.value(1), True]
                else:
                    return [messages[2], False]
            else: return [messages[1], False]
        else:
            return [messages[0], False]

    @Slot(result=list)
    def auto_login(self):
        if self.user_id != 0:
            messages = ["Користувача з таким номером не існує!", "Введено неправильний праоль"]
            query = QSqlQuery(f"SELECT Password, Name FROM User_info WHERE User_id = '{self.user_id}'")
            if query.next():
                if self.password == query.value(0):
                    return ["", True]
                else:
                    return [messages[1], False]
            else: return [messages[0], False]
        else:
            return ["", False]

    @Slot(result=bool)
    def logout(self):
        self.number = '0000000000'
        self.password = ''
        self.name = 'Клієнт'
        self.user_id = 0

    @Slot(result=list)
    def get_user_info(self):
        query = QSqlQuery(f"SELECT Tariff_code, Data, Calls, SMS, Balance, Update_date FROM Package WHERE Number = '{self.number}'")
        if query.next():
            tariff = query.value(0)
            data = query.value(1)
            calls = query.value(2)
            sms = query.value(3)
            balance = query.value(4)
            update_date = query.value(5)
            query = QSqlQuery(f"SELECT Tariff_name, Data, Calls, SMS, Price FROM Tariff WHERE Tariff_code = '{tariff}'")
            if query.next():
                t_name = query.value(0)
                t_data = query.value(1)
                t_calls = query.value(2)
                t_sms = query.value(3)
                price = query.value(4)
                user = QSqlQuery(f"SELECT Name FROM Mobile_number INNER JOIN User_info ON User_info.User_id  = Mobile_number.User_id WHERE Mobile_number.number = '{self.number}';")
                if user.next():
                    return [data, calls, sms, balance, update_date, t_name, t_data, t_calls, t_sms, price, user.value(0)]
            else:
                return [False]
        else:
            return [False]

    @Slot(result=list)
    def get_tariff_info(self):
        query = QSqlQuery("SELECT Tariff_name, Data, Calls, SMS, Price FROM Tariff")
        tariff_data = []
        while query.next():
            tariff_data.append([query.value(0), query.value(1), query.value(2), query.value(3), query.value(4)])
        return tariff_data

    def session_id_update(self):
        if self.session_id == 0:
            date = QSqlQuery("SELECT datetime('now')")
            if date.next():
                QSqlQuery(f"INSERT INTO Session (Date, Number) VALUES ('{date.value(0)}', '{self.number}')")
                id = QSqlQuery(f"SELECT Session_id FROM Session WHERE Date = '{date.value(0)}' AND Number = '{self.number}'")
                if id.next():
                    self.session_id = id.value(0)

    @Slot(str, str)
    def saving_chat(self, query, answer):
        self.session_id_update()
        ses = QSqlQuery(f"SELECT Number FROM Session WHERE Session_id = '{self.session_id}'")
        if ses.next():
            if ses.value(0) != self.number:
                self.session_id = 0
                self.session_id_update()
            time = QSqlQuery("SELECT TIME('now')")
            if time.next():
                QSqlQuery(f"INSERT INTO Chat VALUES ('{query}', '{answer}', '{time.value(0)}', '{self.session_id}');")

    @Slot(result=list)
    def load_chat(self):
        local_chat = []
        if self.session_id != 0:
            ses = QSqlQuery(f"SELECT Query, Answer FROM Chat WHERE Session_id = '{self.session_id}'")
            while ses.next():
                local_chat.append([{'type': 'user', 'text': ses.value(0)}, {'type': 'bot', 'text': ses.value(1)}])
        return local_chat
