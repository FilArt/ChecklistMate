import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/checklist.dart';
import '../providers/checklist_provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChecklistScreen extends StatelessWidget {
  final Checklist checklist;
  final _formKey = GlobalKey<FormBuilderState>();

  ChecklistScreen(this.checklist, {super.key});

  @override
  Widget build(BuildContext context) {
    String checklistTitle = checklist.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist $checklistTitle'),
      ),
      body: Consumer<ChecklistProvider>(
        builder: (ctx, checklistProvider, _) => ListView.builder(
          itemCount: checklistProvider.items.values
              .where((item) => item.checklistId == checklist.id)
              .length,
          itemBuilder: (ctx, i) {
            var item = checklistProvider.items.values.toList()[i];
            return ListTile(
              leading: Checkbox(
                value: item.isDone,
                onChanged: (bool? isDone) {
                  Provider.of<ChecklistProvider>(context, listen: false)
                      .updateChecklistItem(
                          item.id, {'isDone': isDone == true ? 1 : 0});
                },
              ),
              title: Text(item.title),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this item?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Provider.of<ChecklistProvider>(context,
                                      listen: false)
                                  .removeChecklistItem(item.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('New Item'),
                content: FormBuilder(
                  key: _formKey,
                  child: FormBuilderTextField(
                    name: 'item',
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Add'),
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        Provider.of<ChecklistProvider>(context, listen: false)
                            .addItem(
                                _formKey.currentState?.fields['item']?.value,
                                checklist.id);
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
