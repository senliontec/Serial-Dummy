#include "formdata.h"
#include "Logger.h"
#include "IO/Manager.h"
using namespace UI;
static FormData *INSTANCE = nullptr;

FormData::FormData(QObject *parent) : QObject(parent)
{
}

FormData *FormData::getInstance()
{
    if (!INSTANCE) {
        INSTANCE = new FormData();
    }
    return INSTANCE;
}

void FormData::sendWarningMess()
{
    QMessageBox box;
    box.setTextFormat(Qt::RichText);
    box.setIcon(QMessageBox::Critical);
    QString text = tr("目标温度有空值,请确认！");
    box.setInformativeText(text);
    box.setDefaultButton(QMessageBox::Yes);
    if (box.exec() == QMessageBox::Yes) {
        box.exec();
    }
}

void FormData::sendTemps(const QString &data)
{
    QByteArray bin = data.toUtf8();
    IO::Manager::getInstance()->writeData(bin);
}
