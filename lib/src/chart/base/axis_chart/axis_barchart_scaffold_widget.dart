import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

/// A scaffold to show an axis-based chart
///
/// It contains some placeholders to represent an axis-based chart.
///
/// It's something like the below graph:
/// |----------------------|
/// |      |  top  |       |
/// |------|-------|-------|
/// | left | chart | right |
/// |------|-------|-------|
/// |      | bottom|       |
/// |----------------------|
///
/// `left`, `top`, `right`, `bottom` are some place holders to show titles
/// provided by [AxisChartData.titlesData] around the chart
/// `chart` is a centered place holder to show a raw chart.
class AxisBarchartScaffoldWidget extends StatelessWidget {
  const AxisBarchartScaffoldWidget({
    super.key,
    required this.chart,
    required this.data,
    required this.groupSpace,
  });
  final Widget chart;
  final AxisChartData data;
  final double groupSpace;

  bool get showLeftTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  List<Widget> stackWidgets(BoxConstraints constraints) {
    final widgets = <Widget>[
      Container(
        margin: EdgeInsets.only(
          right: data.titlesData.allSidesPadding.right,
          top: data.titlesData.allSidesPadding.top,
          bottom: data.titlesData.allSidesPadding.bottom,
        ),
        decoration: BoxDecoration(
          border: data.borderData.isVisible() ? data.borderData.border : null,
        ),
        child: chart,
      ),
    ];

    int insertIndex(bool drawBelow) => drawBelow ? 0 : widgets.length;

    if (showTopTitles) {
      widgets.insert(
        insertIndex(data.titlesData.topTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.top,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        insertIndex(data.titlesData.rightTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.right,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        insertIndex(data.titlesData.bottomTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.bottom,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: groupSpace,
              padding: EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: stackWidgets(constraints),
                  );
                },
              ),
            ),
          ),
        ),
        showLeftTitles
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return SideTitlesWidget(
                    side: AxisSide.left,
                    axisChartData: data,
                    parentSize: constraints.biggest,
                  );
                },
              )
            : SizedBox(),
      ],
    );
  }
}
