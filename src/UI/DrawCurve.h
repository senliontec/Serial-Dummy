#ifndef DRAWCURVE_H
#define DRAWCURVE_H

#include <IO/Manager.h>
#include <QAbstractSeries>
#include <QMetaType>
#include <QObject>
#include <QXYSeries>
#include <QtMath>

QT_CHARTS_USE_NAMESPACE

namespace UI
{
    class DrawCurve : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(int frameCount
                   READ frameCount
                   NOTIFY sendFrameCount)
        Q_PROPERTY(int windowsize
                   READ getWindowSize
                   NOTIFY sendWindowSize)
        Q_PROPERTY(int envCurveNum
                   READ getEnvCurveNum)
        Q_PROPERTY(int heatPowerNum
                   READ getHeatPowerCurveNum)
        Q_PROPERTY(int tempCurveNum
                   READ getTempCurveNum)
        Q_PROPERTY(double minT
                   READ getMinT)
        Q_PROPERTY(double maxT
                   READ getMaxT)
        Q_PROPERTY(double minV
                   READ getMinV)
        Q_PROPERTY(double maxV
                   READ getMaxV)
        Q_PROPERTY(double minI
                   READ getMinI)
        Q_PROPERTY(double maxI
                   READ getMaxI)
        Q_PROPERTY(double minE
                   READ getMinE)
        Q_PROPERTY(double maxE
                   READ getMaxE)
        Q_PROPERTY(double minHP
                   READ getMinHP)
        Q_PROPERTY(double maxHP
                   READ getMaxHP)

        /////////////////
        /// \brief DrawCurve
        /// \param parent
        ///
        Q_PROPERTY(double minHistT
                   READ getMinHistT)
        Q_PROPERTY(double maxHistT
                   READ getMaxHistT)
        Q_PROPERTY(double minHistV
                   READ getMinHistV)
        Q_PROPERTY(double maxHistV
                   READ getMaxHistV)
        Q_PROPERTY(double minHistI
                   READ getMinHistI)
        Q_PROPERTY(double maxHistI
                   READ getMaxHistI)
        Q_PROPERTY(double minHistE
                   READ getMinHistE)
        Q_PROPERTY(double maxHistE
                   READ getMaxHistE)
        Q_PROPERTY(double minHistHP
                   READ getMinHistHP)
        Q_PROPERTY(double maxHistHP
                   READ getMaxHistHP)

        Q_PROPERTY(QVector<double> curTableTemp
                   READ getCurTableTemp
                   NOTIFY sendCurTableTemp)

    public:
        explicit DrawCurve(QObject *parent = nullptr);
        Q_INVOKABLE void sendHistTempSingle();
        Q_INVOKABLE void sendHistHPSingle();
        Q_INVOKABLE void sendHistEnvTempSingle();


    signals:
        void sendFrameCount();
        void sendWindowSize();
        void sendDisplayedTemp();
        void sendHistoryTemp();
        void sendDisplayedHeatPower();
        void sendHistoryHeatPower();
        void sendDisplayedEnvTemp();
        void sendHistoryEnvTemp();
        void sendCurTableTemp();

    public slots:
        void receiveBufferData(const QByteArray &data);

        void updateDisplayedHeatPowerGraph(QAbstractSeries *series, const int index);
        void updateDisplayedTempGraph(QAbstractSeries *series, const int index);
        void updateDisplayedEnvTempGraph(QAbstractSeries *series, const int index);

        void updateHistoryHeatPowerGraph(QAbstractSeries *series, const int index);
        void updateHistoryTempGraph(QAbstractSeries *series, const int index);
        void updateHistoryEnvTempGraph(QAbstractSeries *series, const int index);

    private:
        const int m_displaynumer = 600;
        int m_channelNums[6] = {29, 29, 29, 2, 9, 2};
        int m_framecounts;
        double m_minT, m_maxT;
        double m_minV, m_maxV;
        double m_minI, m_maxI;
        double m_minE, m_maxE;
        double m_minHP, m_maxHP;

        double m_minHistT, m_maxHistT;
        double m_minHistV, m_maxHistV;
        double m_minHistI, m_maxHistI;
        double m_minHistE, m_maxHistE;
        double m_minHistHP, m_maxHistHP;

        double m_surfaceareas[29] = {
            36684.795, 36684.795, 36684.795, 36684.795, 22561.135,
            22561.135, 22561.135, 22561.135, 77724.03, 80863.31,
            98602.61, 98893.26, 66741.36, 62222.86, 79821.28,
            59027.77, 79821.28, 59027.77, 39844.05, 30236.5,
            39844.05, 30236.5, 54305.71, 54305.71, 54305.71,
            54305.71, 39232.4, 39232.4, 58893.34
        };

        QVector<QVector<QPointF>> m_historyT;
        QVector<QVector<QPointF>> m_historyV;
        QVector<QVector<QPointF>> m_historyI;
        QVector<QVector<QPointF>> m_historyH;
        QVector<QVector<QPointF>> m_historyL;
        QVector<QVector<QPointF>> m_historyE;
        QVector<QVector<QPointF>> m_historyHeatPower;
        QVector<QVector<QPointF>> m_historyEnvTemp;

        QVector<QVector<QPointF>> m_displayedT;
        QVector<QVector<QPointF>> m_displayedV;
        QVector<QVector<QPointF>> m_displayedI;
        QVector<QVector<QPointF>> m_displayedH;
        QVector<QVector<QPointF>> m_displayedL;
        QVector<QVector<QPointF>> m_displayedE;
        QVector<QVector<QPointF>> m_displayHeatPower;
        QVector<QVector<QPointF>> m_displayEnvTemp;

        QVector<double> m_curTableTemp;

    public:
        static DrawCurve *getInstance();
        void Initialization();
        int frameCount();
        int getWindowSize()
        {
            return m_displaynumer;
        }
        int getEnvCurveNum()
        {
            return m_channelNums[5] + 1;
        }
        int getHeatPowerCurveNum()
        {
            return m_channelNums[1];
        }
        int getTempCurveNum()
        {
            return m_channelNums[0];
        }

        double getMinT()
        {
            return m_minT;
        }
        double getMaxT()
        {
            return m_maxT;
        }
        double getMinV()
        {
            return m_minV;
        }
        double getMaxV()
        {
            return m_maxV;
        }
        double getMinI()
        {
            return m_minI;
        }
        double getMaxI()
        {
            return m_maxI;
        }
        double getMinE()
        {
            return m_minE;
        }
        double getMaxE()
        {
            return m_maxE;
        }
        double getMinHP()
        {
            return m_minHP;
        }
        double getMaxHP()
        {
            return m_maxHP;
        }
        /////////////////////////////////////

        double getMinHistT()
        {
            return m_minHistT;
        }
        double getMaxHistT()
        {
            return m_maxHistT;
        }
        double getMinHistV()
        {
            return m_minHistV;
        }
        double getMaxHistV()
        {
            return m_maxHistV;
        }
        double getMinHistI()
        {
            return m_minHistI;
        }
        double getMaxHistI()
        {
            return m_maxHistI;
        }
        double getMinHistE()
        {
            return m_minHistE;
        }
        double getMaxHistE()
        {
            return m_maxHistE;
        }
        double getMinHistHP()
        {
            return m_minHistHP;
        }
        double getMaxHistHP()
        {
            return m_maxHistHP;
        }

        QVector<double> getCurTableTemp()
        {
            return m_curTableTemp;
        }

        int sumarray(int *array, int len);
        QVector<QVector<QPointF>> getHeatPower(const QVector<QVector<QPointF>> &V, const QVector<QVector<QPointF>> &I);
        QVector<QVector<QPointF>> getEnvTemp(const QVector<QVector<QPointF>> &T);
        void getAxiesValues(const QVector<QVector<QPointF>> & v, double & min, double& max);
    };
} // namespace UI

#endif // DRAWCURVE_H
