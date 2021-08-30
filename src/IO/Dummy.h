#ifndef DUMMY_H
#define DUMMY_H

#include <QObject>

class Dummy : public QObject {
  Q_OBJECT

private:
  const int m_AreaNums = 29;
  const double m_SurfaceAreas[29] = {
      1.00,  2.00,  3.00,  4.00,  5.00,  6.00,  7.00,  8.00,  9.00,  10.00,
      11.00, 12.00, 13.00, 14.00, 15.00, 16.00, 17.00, 18.00, 19.00, 20.00,
      21.00, 22.00, 23.00, 24.00, 25.00, 26.00, 27.00, 28.00, 29.00};

public:
  explicit Dummy(QObject *parent = nullptr);
  ~Dummy();

  const double *getSurfaceAres();
  inline int getAreasNums() { return m_AreaNums; }

  // convert the dataframe to
  QString dataFormat(const QString &data);

signals:
};

#endif // DUMMY_H
