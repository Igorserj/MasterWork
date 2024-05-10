# -*- coding: utf-8 -*-
"""Chatbot.ipynb
    https://colab.research.google.com/drive/11VdQtbFk2C9RqlkDiu_DgJNqxWSPUr9K
"""

# Libraries needed for NLP
import nltk
import copy
nltk.download('punkt')
from nltk.stem.lancaster import LancasterStemmer
stemmer = LancasterStemmer()

# Libraries needed for Tensorflow processing
import tensorflow as tf
# print(tf.__version__)
import numpy as np
import tflearn
import random
import json
import pickle
import os.path

class Processing_data:
    def __init__(self, path_to_file):
        self.context = {}
        self.no_reply = "Вибачте, не зрозумів Ваш запит"
        self.ERROR_THRESHOLD = 0.25
        self.path_to_file = path_to_file
        with open(path_to_file) as json_data:
            self.supports = json.load(json_data)

    def text_data_modifier(self, tariffs_list):
        supports = copy.copy(self.supports)
        indices = []
        for i, tariff in enumerate(tariffs_list):
            for j, item in enumerate(tariff):
                if (str(item) == '-1.0'):
                    indices.append([i, j])

        for i in indices:
            tariffs_list[i[0]][i[1]] = '∞'

        for index, support in enumerate(supports['supports']):
            if support['tag'] == 'customtariff':
                remove_index = index
                custom_tariff = support

        tariff_backup = custom_tariff
        del supports['supports'][remove_index]

        for tariff in tariffs_list:
            custom_tariff = copy.copy(tariff_backup)
            custom_tariff['tag'] = tariff[0]
            query_list = []
            for query in custom_tariff['querry']:
                query_list.append(query % tariff[0])
            custom_tariff['querry'] = query_list
            answer_list = []
            for answer in custom_tariff['answer']:
                answer_list.append(answer % (tariff[1], tariff[2], tariff[3], tariff[4]))
            custom_tariff['answer'] = answer_list
            supports['supports'].append({'tag': custom_tariff['tag'], 'querry': custom_tariff['querry'], 'answer': custom_tariff['answer']})
        self.supports = supports


    def processing(self):
        words = []
        classes = []
        documents = []
        ignore = ['?']

        # loop through each sentence in the intent's patterns
        for support in self.supports['supports']:
            for pattern in support['querry']:
                # tokenize each and every word in the sentence
                w = nltk.word_tokenize(pattern)
                # add word to the words list
                words.extend(w)
                # add word(s) to documents
                documents.append((w, support['tag']))
                # add tags to our classes list
                if support['tag'] not in classes:
                    classes.append(support['tag'])

        # Perform stemming and lower each word as well as remove duplicates
        words = [stemmer.stem(w.lower()) for w in words if w not in ignore]
        words = sorted(list(set(words)))

        # remove duplicate classes
        classes = sorted(list(set(classes)))

        print (len(documents), "documents")
        print (len(classes), "classes", classes)
        print (len(words), "unique stemmed words", words)

        # create training data
        training = []
        # create an empty array for output
        output_empty = [0] * len(classes)

        # create training set, bag of words for each sentence
        for doc in documents:
            # initialize bag of words
            bag = []
            # list of tokenized words for the pattern
            pattern_words = doc[0]
            # stemming each word
            pattern_words = [stemmer.stem(word.lower()) for word in pattern_words]
            # create bag of words array
            for w in words:
                bag.append(1) if w in pattern_words else bag.append(0)

            # output is '1' for current tag and '0' for rest of other tags
            output_row = list(output_empty)
            output_row[classes.index(doc[1])] = 1

            training.append([bag, output_row])

        # shuffling features and turning it into np.array
        random.shuffle(training)
        train_x = [np.array(i) for i, _ in training]

        # creating training lists
        train_x = [i[0] for i in training]
        train_y = [i[1] for i in training]

        # resetting underlying graph data
        tf.compat.v1.reset_default_graph()

        # Building neural network
        net = tflearn.input_data(shape=[None, len(train_x[0])])
        net = tflearn.fully_connected(net, 10)
        net = tflearn.fully_connected(net, 10)
        net = tflearn.fully_connected(net, len(train_y[0]), activation='softmax')
        net = tflearn.regression(net)

        # Defining model and setting up tensorboard
        model = tflearn.DNN(net, tensorboard_dir='tflearn_logs')

        # Start training
        model.fit(train_x, train_y, n_epoch=3000, batch_size=8, show_metric=True)
        model.save('model.tflearn')
        pickle.dump( {'words': words, 'classes':classes, 'train_x':train_x, 'train_y':train_y}, open( "training_data", "wb" ) )
        self.model = model
        self.words = words
        self.classes = classes


    def restoring_data(self):
        if os.path.exists("./model.tflearn.meta"):
            # restoring all the data structures
            data = pickle.load( open( "training_data", "rb" ) )
            words = data['words']
            self.words = words
            classes = data['classes']
            self.classes = classes
            train_x = data['train_x']
            train_y = data['train_y']

            # Building neural network
            net = tflearn.input_data(shape=[None, len(train_x[0])])
            net = tflearn.fully_connected(net, 10)
            net = tflearn.fully_connected(net, 10)
            net = tflearn.fully_connected(net, len(train_y[0]), activation='softmax')
            net = tflearn.regression(net)
            model = tflearn.DNN(net, tensorboard_dir='tflearn_logs')

            # load the saved model
            model.load('./model.tflearn')
            self.model = model
        else:
            self.processing()


    def clean_up_sentence(self, sentence):
        # tokenizing the pattern
        sentence_words = nltk.word_tokenize(sentence)
        # stemming each word
        sentence_words = [stemmer.stem(word.lower()) for word in sentence_words]
        return sentence_words

    # returning bag of words array: 0 or 1 for each word in the bag that exists in the sentence
    def bow(self, sentence, words, show_details=False):
        # tokenizing the pattern
        sentence_words = self.clean_up_sentence(sentence)
        # generating bag of words
        bag = [0]*len(words)
        for s in sentence_words:
            for i,w in enumerate(words):
                if w == s:
                    bag[i] = 1
                    if show_details:
                        print ("found in bag: %s" % w)

        return(np.array(bag))

    def classify(self, sentence):
        # generate probabilities from the model
        results = self.model.predict([self.bow(sentence, self.words)])[0]
        # filter out predictions below a threshold
        results = [[i,r] for i,r in enumerate(results) if r>self.ERROR_THRESHOLD]
        # sort by strength of probability
        results.sort(key=lambda x: x[1], reverse=True)
        return_list = []
        for r in results:
            return_list.append((self.classes[r[0]], r[1]))
        # return tuple of intent and probability
        return return_list

    def response(self, sentence):
        results = self.classify(sentence)
        # if we have a classification then find the matching intent tag
        if results:
            # loop as long as there are matches to process
            while results:
                for i in self.supports['supports']:
                    # find a tag matching the first result
                    if i['tag'] == results[0][0]:
                        if i['tag'] == "mytariff":
                            self.yes = ("Покажи тариф %s" % self.tariff)
                            self.no = "Добре, які ще є питання?"
                        elif i['tag'] == "yes" and self.yes != self.no_reply:
                            return self.additional_response(self.yes)
                        elif i['tag'] == "no" and self.no != self.no_reply:
                            return self.additional_response(self.no)
                        elif self.yes != self.no_reply:
                            self.yes = self.no_reply
                            self.no = self.no_reply
                        # set context for this intent if necessary
                        return random.choice(i['answer'])

                results.pop(0)

    def additional_response(self, sentence):
        results = self.classify(sentence)
        if results:
            while results:
                for i in self.supports['supports']:
                    if i['tag'] == results[0][0]:
                        print(results[0][0])
                        return random.choice(i['answer'])

                results.pop(0)
