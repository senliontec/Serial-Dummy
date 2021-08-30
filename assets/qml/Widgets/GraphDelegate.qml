

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
import QtQuick 2.12
import QtCharts 2.3

import SerialStudio 1.0

Window {
    id: root

    property double scalefactor: 1.01
    property int graphId: -1
    property alias sellinearr: chartView.linearr
    spacing: -1
    showIcon: false
    visible: opacity > 0
    opacity: enabled ? 1 : 0
    borderColor: root.headerVisible ? "#517497" : "transparent"
    property int framenumber
    property int min_value: 0
    property int max_value: Cpp_UI_DrawCurve.windowsize
    property double minvalue_Y
    property double maxvalue_Y
    Connections {
        target: Cpp_UI_DrawCurve

        function onSendFrameCount() {
            framenumber = Cpp_UI_DrawCurve.frameCount
            if (framenumber % Cpp_UI_DrawCurve.windowsize === 0) {
                let num = framenumber / Cpp_UI_DrawCurve.windowsize
                min_value = Cpp_UI_DrawCurve.windowsize * num
                max_value = Cpp_UI_DrawCurve.windowsize * (num + 1)
            }
        }
        function onSendDisplayedEnvTemp() {
            if (root.title === "室内温度曲线") {
                for (var n = 0; n < 3; n++) {
                    Cpp_UI_DrawCurve.updateDisplayedEnvTempGraph(
                                chartView.linearr[n], n)
                }
            }
            setAxisYValue()
        }

        function onSendDisplayedHeatPower() {
            if (root.title === "热功率曲线") {
                for (var m = 0; m < Cpp_UI_DrawCurve.heatPowerNum; m++) {
                    Cpp_UI_DrawCurve.updateDisplayedHeatPowerGraph(
                                chartView.linearr[m], m)
                }
            }
            setAxisYValue()
        }

        function onSendDisplayedTemp() {
            if (root.title === "体表温度曲线") {
                for (var i = 0; i < Cpp_UI_DrawCurve.tempCurveNum; i++) {
                    Cpp_UI_DrawCurve.updateDisplayedTempGraph(
                                chartView.linearr[i], i)
                }
            }
            setAxisYValue()
        }
    }

    ChartView {
        id: chartView
        animationOptions: ChartView.NoAnimation
        theme: ChartView.ChartThemeDark
        antialiasing: true
        anchors.fill: parent
        legend.visible: false
        backgroundRoundness: 0
        enabled: root.enabled
        visible: root.enabled
        backgroundColor: root.backgroundColor
        property var linearr: []

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        ValueAxis {
            id: axisX
            min: min_value
            max: max_value
            tickCount: 10
            labelsColor: "#ffffff"
            labelsFont.pointSize: 13
            labelsFont.bold: true
            labelFormat: '%d'
        }

        ValueAxis {
            id: axisY
            min: minvalue_Y
            max: maxvalue_Y
        }
    }

    Component.onCompleted: {
        for (var n = 0; n < Cpp_UI_DrawCurve.tempCurveNum; n++) {
            var series = chartView.createSeries(ChartView.SeriesTypeLine,
                                                "line series", axisX, axisY)
            series.useOpenGL = true
            chartView.linearr.push(series)
        }
    }

    function setAxisYValue() {
        if (root.title === "体表温度曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minT
            maxvalue_Y = Cpp_UI_DrawCurve.maxT * scalefactor
        }
        if (root.title === "热功率曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minHP
            maxvalue_Y = Cpp_UI_DrawCurve.maxHP * scalefactor
        }
        if (root.title === "室内温度曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minE
            maxvalue_Y = Cpp_UI_DrawCurve.maxE * scalefactor
        }
    }
}
