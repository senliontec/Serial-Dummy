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

#ifndef CSV_EXPORT_H
#define CSV_EXPORT_H

#include <JSON/FrameInfo.h>
#include <QFile>
#include <QJsonObject>
#include <QList>
#include <QObject>
#include <QTextStream>
#include <QVariant>

namespace CSV {
class Export : public QObject {
  // clang-format off
    Q_OBJECT
    Q_PROPERTY(bool isOpen
               READ isOpen
               NOTIFY openChanged)
    Q_PROPERTY(bool exportEnabled
               READ exportEnabled
               WRITE setExportEnabled
               NOTIFY enabledChanged)
  // clang-format on

signals:
  void openChanged();
  void enabledChanged();

public:
  static Export *getInstance();

  bool isOpen() const;
  bool exportEnabled() const;

private:
  Export();
  ~Export();

public slots:
  void closeFile();
  void openCurrentCsv();
  void setExportEnabled(const bool enabled);

private slots:
  void writeValues();
  void registerFrame(const JFI_Object &info);

private:
  QFile m_csvFile;
  bool m_exportEnabled;
  QTextStream m_textStream;
  QList<JFI_Object> m_jsonList;
};
} // namespace CSV

#endif
