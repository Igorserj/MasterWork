from Chat.Backend.Processing_data import Processing_data
from PySide6.QtQml import QmlElement
from PySide6.QtCore import Slot, QObject

QML_IMPORT_NAME = "ChatModel"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class Chat(QObject):
    def __init__(self, parent=None):
        super(Chat, self).__init__(parent)
        pass

    @Slot(list, bool)
    def training(self, tariffs_list, restore):
        path_to_file = 'Chat/telecom.json'
        self.nn = Processing_data(path_to_file)
        self.nn.text_data_modifier(tariffs_list)
        if restore: self.nn.restoring_data()
        else: self.nn.processing()

    @Slot(str, result=list)
    def send_action(self, message):
        if message != "":
            user_text = message
            return [{'type': "bot", 'text': self.answer_post_process(self.nn.response(sentence=user_text))}]

    @Slot(str, str, str)
    def user_info(self, name, balance, tariff):
        self.nn.user_name = name
        self.nn.balance = balance
        self.nn.tariff = tariff
        self.nn.yes = self.nn.no_reply
        self.nn.no = self.nn.no_reply

    def answer_post_process(self, sentence):
        sentence = sentence.replace("*placeholder_name*", self.nn.user_name)
        sentence = sentence.replace("*placeholder_balance*", self.nn.balance)
        sentence = sentence.replace("*placeholder_tariff*", self.nn.tariff)
        sentence = sentence.replace("*placeholder_yes*", self.nn.yes)
        sentence = sentence.replace("*placeholder_no*", self.nn.no)
        return sentence
