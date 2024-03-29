library improved_data_table;

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:nodemarketcap/add_coin_page.dart';


/// A material design data table that shows data using multiple pages.
///
/// A Improved data table shows [rowsPerPage] rows of data per page and
/// provides controls for showing other pages.
///
/// Data is read lazily from from a [DataTableSource]. The widget is presented
/// as a [Card].
///
/// See also:
///
///  * [DataTable], which is not Improved.
///  * <https://material.io/go/design-data-tables#data-tables-tables-within-cards>
class ImprovedDataTable extends StatefulWidget {
  /// Creates a widget describing a Improved [DataTable] on a [Card].
  ///
  /// The [header] should give the card's header, typically a [Text] widget. It
  /// must not be null.
  ///
  /// The [columns] argument must be a list of as many [DataColumn] objects as
  /// the table is to have columns, ignoring the leading checkbox column if any.
  /// The [columns] argument must have a length greater than zero and cannot be
  /// null.
  ///
  /// If the table is sorted, the column that provides the current primary key
  /// should be specified by index in [sortColumnIndex], 0 meaning the first
  /// column in [columns], 1 being the next one, and so forth.
  ///
  /// The actual sort order can be specified using [sortAscending]; if the sort
  /// order is ascending, this should be true (the default), otherwise it should
  /// be false.
  ///
  /// The [source] must not be null. The [source] should be a long-lived
  /// [DataTableSource]. The same source should be provided each time a
  /// particular [ImprovedDataTable] widget is created; avoid creating a new
  /// [DataTableSource] with each new instance of the [ImprovedDataTable]
  /// widget unless the data table really is to now show entirely different
  /// data from a new source.
  ///
  /// The [rowsPerPage] and [availableRowsPerPage] must not be null (they
  /// both have defaults, though, so don't have to be specified).
  ImprovedDataTable({
    Key key,
    @required this.header,
    this.actions,
    @required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[defaultRowsPerPage, defaultRowsPerPage * 2, defaultRowsPerPage * 5, defaultRowsPerPage * 10],
    this.onRowsPerPageChanged,
    @required this.source
  }) : assert(header != null),
        assert(columns != null),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null || (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(sortAscending != null),
        assert(rowsPerPage != null),
        assert(rowsPerPage > 0),
        assert(() {
          if (onRowsPerPageChanged != null)
            assert(availableRowsPerPage != null && availableRowsPerPage.contains(rowsPerPage));
          return true;
        }()),
        assert(source != null),
        super(key: key);

  /// The table card's header.
  ///
  /// This is typically a [Text] widget, but can also be a [ButtonBar] with
  /// [FlatButton]s. Suitable defaults are automatically provided for the font,
  /// button color, button padding, and so forth.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items.
  final Widget header;

  /// Icon buttons to show at the top right of the table.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget> actions;

  /// The configuration and labels for the columns in the table.
  final List<DataColumn> columns;

  /// The current primary sort key's column.
  ///
  /// See [DataTable.sortColumnIndex].
  final int sortColumnIndex;

  /// Whether the column mentioned in [sortColumnIndex], if any, is sorted
  /// in ascending order.
  ///
  /// See [DataTable.sortAscending].
  final bool sortAscending;

  /// Invoked when the user selects or unselects every row, using the
  /// checkbox in the heading row.
  ///
  /// See [DataTable.onSelectAll].
  final ValueSetter<bool> onSelectAll;

  /// The index of the first row to display when the widget is first created.
  final int initialFirstRowIndex;

  /// Invoked when the user switches to another page.
  ///
  /// The value is the index of the first row on the currently displayed page.
  final ValueChanged<int> onPageChanged;

  /// The number of rows to show on each page.
  ///
  /// See also:
  ///
  /// * [onRowsPerPageChanged]
  /// * [defaultRowsPerPage]
  final int rowsPerPage;

  /// The default value for [rowsPerPage].
  ///
  /// Useful when initializing the field that will hold the current
  /// [rowsPerPage], when implemented [onRowsPerPageChanged].
  static const int defaultRowsPerPage = 10;

  /// The options to offer for the rowsPerPage.
  ///
  /// The current [rowsPerPage] must be a value in this list.
  ///
  /// The values in this list should be sorted in ascending order.
  final List<int> availableRowsPerPage;

  /// Invoked when the user selects a different number of rows per page.
  ///
  /// If this is null, then the value given by [rowsPerPage] will be used
  /// and no affordance will be provided to change the value.
  final ValueChanged<int> onRowsPerPageChanged;

  /// The data source which provides data to show in each row. Must be non-null.
  ///
  /// This object should generally have a lifetime longer than the
  /// [ImprovedDataTable] widget itself; it should be reused each time the
  /// [ImprovedDataTable] constructor is called.
  final DataTableSource source;

  @override
  ImprovedDataTableState createState() => new ImprovedDataTableState();
}

/// Holds the state of a [ImprovedDataTable].
///
/// The table can be programmatically paged using the [pageTo] method.
class ImprovedDataTableState extends State<ImprovedDataTable> {
  int _firstRowIndex;
  int _rowCount;
  bool _rowCountApproximate;
  int _selectedRowCount;
  final Map<int, DataRow> _rows = <int, DataRow>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.of(context)?.readState(context) ?? widget.initialFirstRowIndex ?? 0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(ImprovedDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }



  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) &&
        (oldFirstRowIndex != _firstRowIndex))
      widget.onPageChanged(_firstRowIndex);
  }

  DataRow _getBlankRowFor(int index) {
    return new DataRow.byIndex(
        index: index,
        cells: widget.columns.map<DataCell>((DataColumn column) => DataCell.empty).toList()
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    bool haveProgressIndicator = false;
    final List<DataCell> cells = widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return new DataRow.byIndex(
        index: index,
        cells: cells
    );
  }

  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final List<DataRow> result = <DataRow>[];
    final int nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    bool haveProgressIndicator = false;
    for (int index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(index, () => widget.source.getRow(index));
        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      row ??= _getBlankRowFor(index);
      result.add(row);
    }
    return result;
  }

  final GlobalKey _tableKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO(ianh): This whole build function doesn't handle RTL yet.
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    double startPadding = 24.0;
    if (_selectedRowCount == 0) {
      headerWidgets.add(new Expanded(child: widget.header));
      if (widget.header is ButtonBar) {
        // We adjust the padding when a button bar is present, because the
        // ButtonBar introduces 2 pixels of outside padding, plus 2 pixels
        // around each button on each side, and the button itself will have 8
        // pixels internally on each side, yet we want the left edge of the
        // inside of the button to line up with the 24.0 left inset.
        // TODO(ianh): Better magic. See https://github.com/flutter/flutter/issues/4460
        startPadding = 12.0;
      }
    } else {
      headerWidgets.add(new Expanded(
        child: new Text(localizations.selectedRowCountTitle(_selectedRowCount)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
          widget.actions.map<Widget>((Widget action) {
            return new Padding(
              // 8.0 is the default padding of an icon button
              padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
              child: action,
            );
          }).toList()
      );
    }

    // FOOTER
    final TextStyle footerTextStyle = themeData.textTheme.caption;


    // CARD
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Semantics(
            container: true,
            child: new DefaultTextStyle(
              // These typographic styles aren't quite the regular ones. We pick the closest ones from the regular
              // list and then tweak them appropriately.
              // See https://material.google.com/components/data-tables.html#data-tables-tables-within-cards
                style: _selectedRowCount > 0 ? themeData.textTheme.subhead.copyWith(color: themeData.accentColor)
                    : themeData.textTheme.title.copyWith(fontWeight: FontWeight.w400),
                child: IconTheme.merge(
                    data: const IconThemeData(
                        opacity: 0.54
                    ),
                    child: new ButtonTheme.bar(
                        child: new Container(
                            height: 64.0,
                            padding: new EdgeInsetsDirectional.only(start: startPadding, end: 14.0),
                            // TODO(ianh): This decoration will prevent ink splashes from being visible.
                            // Instead, we should have a widget that prints the decoration on the material.
                            // See https://github.com/flutter/flutter/issues/3782
                            color: _selectedRowCount > 0 ? themeData.secondaryHeaderColor : null,
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: headerWidgets
                            )
                        )
                    )
                )
            ),
          ),
          new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: new DataTable(
                  key: _tableKey,
                  columns: widget.columns,
                  sortColumnIndex: widget.sortColumnIndex,
                  sortAscending: widget.sortAscending,
                  onSelectAll: widget.onSelectAll,
                  rows: _getRows(_firstRowIndex, widget.rowsPerPage)
              )
          ),
          new DefaultTextStyle(
            style: footerTextStyle,
            child: IconTheme.merge(
              data: const IconThemeData(
                  opacity: 0.54
              ),
              child: new Container(
                height: 56.0,
                child: new Center(
                  child: new IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () { }
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
