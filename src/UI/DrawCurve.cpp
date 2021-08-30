#include "DrawCurve.h"
#include <QRandomGenerator>
#include <Logger.h>
using namespace UI;

/**
 * Only instance of the class
 */

static DrawCurve *INSTANCE = nullptr;

QT_CHARTS_USE_NAMESPACE
Q_DECLARE_METATYPE(QAbstractAxis *)
Q_DECLARE_METATYPE(QAbstractSeries *)

DrawCurve::DrawCurve(QObject *parent) : QObject(parent)
{
    // Register data types
    qRegisterMetaType<QAbstractAxis *>();
    qRegisterMetaType<QAbstractSeries *>();
    // Module signal/slots
    auto io = IO::Manager::getInstance();
    connect(io, SIGNAL(frameReceived(QByteArray)), this,
            SLOT(receiveBufferData(QByteArray)));
    Initialization();
}

DrawCurve *DrawCurve::getInstance()
{
    if (!INSTANCE) {
        INSTANCE = new DrawCurve();
    }
    return INSTANCE;
}

void DrawCurve::Initialization()
{
    m_framecounts = 0;
    m_historyT.clear();
    m_historyV.clear();
    m_historyI.clear();
    m_historyH.clear();
    m_historyL.clear();
    m_historyE.clear();
    m_historyHeatPower.clear();
    m_historyEnvTemp.clear();
    m_displayedT.clear();
    m_displayedV.clear();
    m_displayedI.clear();
    m_displayedH.clear();
    m_displayedL.clear();
    m_displayedE.clear();
    m_displayHeatPower.clear();
    m_displayEnvTemp.clear();
    m_historyT.resize(m_channelNums[0]);
    m_historyV.resize(m_channelNums[1]);
    m_historyI.resize(m_channelNums[2]);
    m_historyH.resize(m_channelNums[3]);
    m_historyL.resize(m_channelNums[4]);
    m_historyE.resize(m_channelNums[5]);
    m_historyHeatPower.resize(m_channelNums[1]);
    m_historyEnvTemp.resize(m_channelNums[5] + 1);
    m_displayedT.resize(m_channelNums[0]);
    m_displayedV.resize(m_channelNums[1]);
    m_displayedI.resize(m_channelNums[2]);
    m_displayedH.resize(m_channelNums[3]);
    m_displayedL.resize(m_channelNums[4]);
    m_displayedE.resize(m_channelNums[5]);
    m_displayHeatPower.resize(m_channelNums[1]);
    m_displayEnvTemp.resize(m_channelNums[5] + 1);
    m_minT = m_maxT = m_minV = m_maxV = m_minI = m_maxI = m_minE = m_maxE = m_minHP = m_maxHP = 0.0;
    m_minHistT = m_maxHistT = m_minHistV = m_maxHistV = m_minHistI = m_maxHistI = m_minHistE = m_maxHistE = m_minHistHP = m_maxHistHP = 0.0;
}

int DrawCurve::frameCount()
{
    return m_framecounts;
}

int DrawCurve::sumarray(int *array, int len)
{
    int result = 0;
    for (int i = 0; i < len; i++) {
        result += array[i];
    }
    return result;
}

void DrawCurve::receiveBufferData(const QByteArray &data)
{
    if (data.isEmpty()) {
        return;
    }
    m_framecounts++;
    QString binstr = (QString)data;
    QStringList valstr = binstr.split(",");
    QPointF pts;
    // For T:
    for (int i = 1; i <= sumarray(m_channelNums, 1); i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyT[i - 1].append(pts);
        m_displayedT[i - 1].append(pts);
        m_curTableTemp.append(valstr.at(i).toDouble());
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedT[i - 1].clear();
        }
    }
    // For V
    for (int i = sumarray(m_channelNums, 1) + 1; i <= sumarray(m_channelNums, 2);
         i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyV[i - sumarray(m_channelNums, 1) - 1].append(pts);
        m_displayedV[i - sumarray(m_channelNums, 1) - 1].append(pts);
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedV[i - sumarray(m_channelNums, 1) - 1].clear();
        }
    }
    // For I
    for (int i = sumarray(m_channelNums, 2) + 1; i <= sumarray(m_channelNums, 3);
         i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyI[i - sumarray(m_channelNums, 2) - 1].append(pts);
        m_displayedI[i - sumarray(m_channelNums, 2) - 1].append(pts);
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedI[i - sumarray(m_channelNums, 2) - 1].clear();
        }
    }
    // For H
    for (int i = sumarray(m_channelNums, 3) + 1; i <= sumarray(m_channelNums, 4);
         i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyH[i - sumarray(m_channelNums, 3) - 1].append(pts);
        m_displayedH[i - sumarray(m_channelNums, 3) - 1].append(pts);
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedH[i - sumarray(m_channelNums, 3) - 1].clear();
        }
    }
    // For L
    for (int i = sumarray(m_channelNums, 4) + 1; i <= sumarray(m_channelNums, 5);
         i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyL[i - sumarray(m_channelNums, 4) - 1].append(pts);
        m_displayedL[i - sumarray(m_channelNums, 4) - 1].append(pts);
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedL[i - sumarray(m_channelNums, 4) - 1].clear();
        }
    }
    // For E
    for (int i = sumarray(m_channelNums, 5) + 1; i <= sumarray(m_channelNums, 6);
         i++) {
        pts.setX(m_framecounts);
        pts.setY(valstr.at(i).toDouble());
        m_historyE[i - sumarray(m_channelNums, 5) - 1].append(pts);
        m_displayedE[i - sumarray(m_channelNums, 5) - 1].append(pts);
        if (m_framecounts % m_displaynumer == 0) {
            m_displayedE[i - sumarray(m_channelNums, 5) - 1].clear();
        }
    }
    m_historyHeatPower = getHeatPower(m_historyV, m_historyI);
    m_displayHeatPower = getHeatPower(m_displayedV, m_displayedI);
    m_historyEnvTemp = getEnvTemp(m_historyE);
    m_displayEnvTemp = getEnvTemp(m_displayedE);
    if (m_framecounts % m_displaynumer == 0) {
        for (int i = 0 ; i < m_displayHeatPower.size(); i ++) {
            m_displayHeatPower[i].clear();
        }
    }
    if (m_framecounts % m_displaynumer == 0) {
        for (int i = 0 ; i < m_displayEnvTemp.size(); i ++) {
            m_displayEnvTemp[i].clear();
        }
    }
    getAxiesValues(m_displayedT, m_minT, m_maxT);
    getAxiesValues(m_displayedV, m_minV, m_maxV);
    getAxiesValues(m_displayedI, m_minI, m_maxI);
    getAxiesValues(m_displayedE, m_minE, m_maxE);
    getAxiesValues(m_displayHeatPower, m_minHP, m_maxHP);
    getAxiesValues(m_historyT, m_minHistT, m_maxHistT);
    getAxiesValues(m_historyV, m_minHistV, m_maxHistV);
    getAxiesValues(m_historyI, m_minHistI, m_maxHistI);
    getAxiesValues(m_historyE, m_minHistE, m_maxHistE);
    getAxiesValues(m_historyHeatPower, m_minHistHP, m_maxHistHP);
    emit sendFrameCount();
    emit sendDisplayedTemp();
    emit sendDisplayedHeatPower();
    emit sendDisplayedEnvTemp();
    emit sendCurTableTemp();
    m_curTableTemp.clear();
}

void DrawCurve::updateDisplayedTempGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_displayedT[index]);
    }
}

void DrawCurve::updateHistoryTempGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_historyT[index]);
    }
}

void DrawCurve::updateDisplayedHeatPowerGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_displayHeatPower[index]);
    }
}

void DrawCurve::updateHistoryHeatPowerGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_historyHeatPower[index]);
    }
}

void DrawCurve::updateDisplayedEnvTempGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_displayEnvTemp[index]);
    }
}

void DrawCurve::updateHistoryEnvTempGraph(QAbstractSeries *series, const int index)
{
    // Validation
    assert(series != Q_NULLPTR);
    // Update data
    if (series->isVisible()) {
        static_cast<QXYSeries *>(series)->replace(m_historyEnvTemp[index]);
    }
}

QVector<QVector<QPointF>> DrawCurve::getHeatPower(const QVector<QVector<QPointF>> &V, const QVector<QVector<QPointF>> &I)
{
    QVector<QVector<QPointF>> result;
    result.resize(V.size());
    for (int i = 0 ; i < V.size(); i ++) {
        result[i].resize(V[i].size());
        for (int j = 0 ; j < V[i].size(); j ++) {
            result[i][j].setY(V[i][j].y() * I[i][j].y() / m_surfaceareas[i]);
            result[i][j].setX(V[i][j].x());
        }
    }
    return result;
}

QVector<QVector<QPointF>> DrawCurve::getEnvTemp(const QVector<QVector<QPointF>> &T)
{
    QVector<QPointF> temp;
    for (int i = 0 ; i < T[0].size(); i ++) {
        temp.append(QPointF(T[0][i].x(), (T[0][i].y() + T[1][i].y()) / 2));
    }
    QVector<QVector<QPointF>> result = T;
    result.append(temp);
    return result;
}

void DrawCurve::getAxiesValues(const QVector<QVector<QPointF>> &v, double &min, double &max)
{
    min = max =  v[0][0].y();
    for(int i = 0 ; i < v.size(); i ++) {
        for(int j = 0 ; j < v[i].size(); j ++) {
            double value = v[i][j].y();
            if (min > value) {
                min = value;
            }
            if (max < value) {
                max = value;
            }
        }
    }
}

void DrawCurve::sendHistTempSingle()
{
    emit sendHistoryTemp();
}

void DrawCurve::sendHistHPSingle()
{
    emit sendHistoryHeatPower();
}

void DrawCurve::sendHistEnvTempSingle()
{
    emit sendHistoryEnvTemp();
}

