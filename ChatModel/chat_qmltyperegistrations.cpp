/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#include </home/igorserj/Documents/MasterWork/Chat/Backend/chat.py>


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_ChatModel()
{
    qmlRegisterTypesAndRevisions<Chat>("ChatModel", 1);
    QMetaType::fromType<QObject *>().id();
    qmlRegisterModule("ChatModel", 1, 0);
}

static const QQmlModuleRegistration chatModelRegistration("ChatModel", qml_register_types_ChatModel);
