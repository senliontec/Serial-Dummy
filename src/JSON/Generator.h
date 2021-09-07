/*
 * Copyright (c) 2020-2021 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef JSON_GENERATOR_H
#define JSON_GENERATOR_H

#include <QFile>
#include <QJSEngine>
#include <QJSValue>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QObject>
#include <QPair>
#include <QQmlEngine>
#include <QSettings>
#include <QThread>
#include <QTimer>

#include "Frame.h"
#include "FrameInfo.h"

namespace JSON {
class JSONWorker : public QObject {
  Q_OBJECT

signals:
  void finished();
  void jsonReady(const JFI_Object &info);

public:
  JSONWorker(const QByteArray &data, const quint64 frame,
             const QDateTime &time);

public slots:
  void process();

private:
  QDateTime m_time;
  QByteArray m_data;
  quint64 m_frame;
  QJSEngine *m_engine;
};

class Generator : public QObject {
  // clang-format off
    Q_OBJECT
    Q_PROPERTY(QString jsonMapFilename
               READ jsonMapFilename
               NOTIFY jsonFileMapChanged)
    Q_PROPERTY(QString jsonMapFilepath
               READ jsonMapFilepath
               NOTIFY jsonFileMapChanged)
    Q_PROPERTY(OperationMode operationMode
               READ operationMode
               WRITE setOperationMode
               NOTIFY operationModeChanged)
  // clang-format on

signals:
  void jsonFileMapChanged();
  void operationModeChanged();
  void jsonChanged(const JFI_Object &info);

public:
  enum OperationMode {
    kManual = 0x00,
    kAutomatic = 0x01,
  };
  Q_ENUMS(OperationMode)

public:
  static Generator *getInstance();

  QString jsonMapData() const;
  QString jsonMapFilename() const;
  QString jsonMapFilepath() const;
  OperationMode operationMode() const;

public slots:
  void loadJsonMap();
  void setOperationMode(const OperationMode mode);
  void loadJsonMap(const QString &path, const bool silent = false);

private:
  Generator();

public slots:
  void readSettings();
  void loadJFI(const JFI_Object &info);
  void writeSettings(const QString &path);
  void loadJSON(const QJsonDocument &json);

private slots:
  void reset();
  void readData(const QByteArray &data);

private:
  QFile m_jsonMap;
  quint64 m_frameCount;
  QSettings m_settings;
  QString m_jsonMapData;
  OperationMode m_opMode;

  QThread m_workerThread;
  JSONWorker *m_jsonWorker;
};
} // namespace JSON

#endif
