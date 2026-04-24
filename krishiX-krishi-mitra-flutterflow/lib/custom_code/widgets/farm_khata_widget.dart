// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class FarmKhataWidget extends StatefulWidget {
  const FarmKhataWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmKhataWidgetState createState() => _FarmKhataWidgetState();
}

class _FarmKhataWidgetState extends State<FarmKhataWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isExpenseMode = true;
  bool _isSubmitting = false;

  // --- 1. Fetch Data Stream (Real-time) ---
  Stream<List<Map<String, dynamic>>> get _transactionsStream {
    return Supabase.instance.client
        .from('farm_khata')
        .stream(primaryKey: ['id']).order('created_at', ascending: false);
  }

  // --- 2. Add Entry to Supabase ---
  Future<void> _addEntry() async {
    final String title = _titleController.text.trim();
    final String amountStr = _amountController.text.trim();

    if (title.isEmpty || amountStr.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to save data.')),
        );
        return;
      }

      await Supabase.instance.client.from('farm_khata').insert({
        'title': title,
        'amount': double.tryParse(amountStr) ?? 0.0,
        'is_expense': _isExpenseMode,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      _titleController.clear();
      _amountController.clear();
    } catch (e) {
      print('Error adding entry: $e');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // --- 3. Delete Entry from Supabase ---
  Future<void> _deleteEntry(int id) async {
    try {
      await Supabase.instance.client.from('farm_khata').delete().eq('id', id);
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _transactionsStream,
      builder: (context, snapshot) {
        // --- Loading State ---
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
          );
        }

        final transactions = snapshot.data!;

        // --- Calculate Totals ---
        double totalIncome = 0;
        double totalExpense = 0;

        for (var t in transactions) {
          final amount = (t['amount'] as num).toDouble();
          if (t['is_expense'] == true) {
            totalExpense += amount;
          } else {
            totalIncome += amount;
          }
        }
        final netProfit = totalIncome - totalExpense;

        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 600,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Column(
            children: [
              // -------------------------------------------
              // DASHBOARD
              // -------------------------------------------
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Farm Khata',
                            style: FlutterFlowTheme.of(context).headlineSmall),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: netProfit >= 0
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            netProfit >= 0 ? 'Profitable' : 'Loss',
                            style: TextStyle(
                              color: netProfit >= 0
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            title: 'Income',
                            amount: totalIncome,
                            color: Colors.green,
                            icon: Icons.arrow_downward,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            context,
                            title: 'Expense',
                            amount: totalExpense,
                            color: Colors.red,
                            icon: Icons.arrow_upward,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Net Balance',
                              style: FlutterFlowTheme.of(context).labelMedium),
                          Text(
                            '₹${netProfit.toStringAsFixed(0)}',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: netProfit >= 0
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------------------------------
              // ADD ENTRY FORM
              // -------------------------------------------
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Entry',
                        style: FlutterFlowTheme.of(context).labelMedium),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: 'Item (e.g. Seeds)',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelSmall,
                                  border: InputBorder.none,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                      FlutterFlowTheme.of(context).alternate),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '₹ Amount',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelSmall,
                                  border: InputBorder.none,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildTypeChip('Expense', true),
                              SizedBox(width: 8),
                              _buildTypeChip('Income', false),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: _isSubmitting ? null : _addEntry,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: _isSubmitting
                                  ? Colors.grey
                                  : FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: _isSubmitting
                                  ? SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : Text(
                                      'ADD',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // -------------------------------------------
              // TRANSACTION LIST
              // -------------------------------------------
              Expanded(
                child: Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: transactions.isEmpty
                      ? Center(
                          child: Text(
                            'No records yet',
                            // --- FIX IS HERE ---
                            // We use bodyMedium and override the Color
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(16),
                          itemCount: transactions.length,
                          separatorBuilder: (ctx, i) => SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final t = transactions[index];
                            final isExp = t['is_expense'] as bool;
                            final id = t['id'] as int;
                            final date = DateTime.parse(t['created_at']);

                            return Dismissible(
                              key: Key(id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _deleteEntry(id),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isExp
                                            ? Colors.red.shade50
                                            : Colors.green.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isExp
                                            ? Icons.shopping_bag_outlined
                                            : Icons.monetization_on_outlined,
                                        color:
                                            isExp ? Colors.red : Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t['title'] ?? 'Unknown',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Text(
                                            DateFormat('MMM d, y').format(date),
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${isExp ? "-" : "+"} ₹${t['amount'].toString()}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: isExp
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildSummaryCard(BuildContext context,
      {required String title,
      required double amount,
      required Color color,
      required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              SizedBox(width: 4),
              Text(title,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isExp) {
    final bool isSelected = _isExpenseMode == isExp;
    final Color activeColor = isExp ? Colors.red : Colors.green;

    return InkWell(
      onTap: () {
        setState(() {
          _isExpenseMode = isExp;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? activeColor
                : FlutterFlowTheme.of(context).alternate,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : FlutterFlowTheme.of(context).secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
