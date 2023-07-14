import 'package:app/models/checklist.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'checklist_screen.dart';
import '../providers/checklist_provider.dart';

class ChecklistsScreen extends StatelessWidget {
  const ChecklistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklists'),
      ),
      body: Consumer<ChecklistProvider>(
        builder: (ctx, checklistProvider, _) => ListView.builder(
          itemCount: checklistProvider.checklists.length,
          itemBuilder: (ctx, i) =>
              _buildChecklist(checklistProvider, i, context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('New Checklist'),
                content: FormBuilder(
                  key: formKey,
                  child: FormBuilderTextField(
                    name: 'checklist',
                    decoration:
                        const InputDecoration(labelText: 'Checklist Name'),
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
                      if (formKey.currentState?.saveAndValidate() ?? false) {
                        Provider.of<ChecklistProvider>(context, listen: false)
                            .addChecklist(formKey
                                .currentState?.fields['checklist']?.value);
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

  ListTile _buildChecklist(
      ChecklistProvider checklistProvider, int i, BuildContext context) {
    Checklist checklist = checklistProvider.checklists[i];
    return ListTile(
      title: Text(checklist.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChecklistScreen(checklist)),
        );
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text(
                    'Are you sure you want to delete this checklist?'),
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
                      Provider.of<ChecklistProvider>(context, listen: false)
                          .removeChecklist(checklist.id);
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
  }
}
