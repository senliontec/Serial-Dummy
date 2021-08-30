#ifndef FORMDATA_H
#define FORMDATA_H
#include <QObject>
#include <QMessageBox>


//tableview的简易model
namespace UI
{
    class FormData : public QObject
    {
        Q_OBJECT
    public:
        static FormData *getInstance();
        explicit FormData(QObject *parent = nullptr);

    public slots:
        void sendWarningMess();
        void sendTemps(const QString &data);
    };
}

#endif // FORMDATA_H
