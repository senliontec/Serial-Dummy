#include "Dummy.h"

Dummy::Dummy(QObject *parent) : QObject(parent) {}

// get the surface area of dummy
const double *Dummy::getSurfaceAres() { return m_SurfaceAreas; }

// destructor
Dummy::~Dummy() {}

/**
 * remove @c V: @c T: @c I: @c H: @c L: @c E: from QString data.
 * remove all the space in QString and returns the satisfied data format for
 * GUI visualization
 */
QString Dummy::dataFormat(const QString &data) {
  QString str = data;
  return str.replace(QRegExp("[VTIHLE:]"), " ").remove(QRegExp("\\s"));
}
